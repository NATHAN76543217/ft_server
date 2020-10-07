FROM debian:buster

RUN apt-get update \
    && apt-get -y upgrade
RUN echo "--install Packages\n" \
    && apt-get -yq install  nginx mariadb-server wget\
    && apt-get -yq install  php php-common php-fpm php-mysql php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip \
    && wget https://wordpress.org/latest.tar.gz -P /tmp \
    && wget -O /tmp/wp_key.txt https://api.wordpress.org/secret-key/1.1/salt/ \
    && mkdir /app

COPY srcs/. .

RUN echo "\nLaunching all services:\n" \
    && service mysql start \
    && echo "- Configure MySql" \
    && mysql -u root < /app/init_DBs.sql \
    && echo "- Install phpmyadmin" \
    && mv /phpMyAdmin-5.0.2-all-languages /usr/share/phpmyadmin \
    && echo "- Configure phpMyAdmin" \
    && ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin \
    && chown -R www-data:www-data /var/www/html/phpmyadmin \
    && mkdir -p /var/www/html/phpmyadmin/tmp \
    && chown -RH www-data:www-data /var/www/html/phpmyadmin/tmp \
    && mysql -u root < /app/create_tables.sql \
    && sed -i "s~\$cfg\['blowfish_secret'\] = '';~\$cfg\['blowfish_secret'\] = 'STRINGOFTHIRTYTWORANDOMCHARACTERS';~g" /usr/share/phpmyadmin/config.inc.php \
    && echo "- install WordPress" \
    && mkdir /var/www/html/wordpress \
    && tar xzf /tmp/latest.tar.gz --strip-components=1 -C /var/www/html/wordpress \
    && echo "- Configure WordPress" \
    && mv /var/www/html/wp-config.php /var/www/html/wordpress/wp-config.php \
    && chown -R www-data:www-data /var/www/html/wordpress \
    && find /var/www/html/wordpress/ -type d -exec chmod 750 {} \; \
    && find /var/www/html/wordpress/ -type f -exec chmod 640 {} \; \
    && mysql -u root < /app/WPDB.sql \
    && sed -i -e "/^define( 'AUTH_KEY',         'put your unique phrase here' );/r /tmp/wp_key.txt" -e "/^define( 'AUTH_KEY',         'put your unique phrase here' );/,/^define( 'NONCE_SALT',       'put your unique phrase here' );/d" /var/www/html/wordpress/wp-config.php \
    && rm /tmp/wp_key.txt /var/www/html/index.nginx-debian.html

ENV AUTOINDEX="OFF"

RUN echo "- configure SSL"\
    && mkdir /app/ssl \
    && openssl req -nodes -newkey rsa:2048 -sha256 -keyout /app/ssl/private.key -out /app/ssl/server.csr -subj "/C=FR/ST=69/L=Lyon/O=LECAILLE NATHAN/CN=Localhost" \
    && openssl x509 -req -days 365 -in /app/ssl/server.csr -signkey /app/ssl/private.key -out /app/ssl/server.crt \ 
    && nginx -t \
    && service nginx start \    
    && bash /app/MAJ_auto_index.sh 

CMD service mysql restart && service php7.3-fpm start && nginx -g 'daemon off;'
