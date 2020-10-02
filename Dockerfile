FROM debian:buster

RUN apt update \
    && apt -y upgrade
# installation des modules necessaires 
RUN echo "Start install Packages\n" \
    && apt -yq install  nginx mariadb-server wget\
    && apt -yq install  php php-common php-fpm php-mysql php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip \
    && wget https://files.phpmyadmin.net/phpMyAdmin/4.8.4/phpMyAdmin-4.8.4-all-languages.tar.gz -P /tmp \
    && wget https://wordpress.org/latest.tar.gz -P /tmp \
    && wget -O /tmp/wp_key.txt https://api.wordpress.org/secret-key/1.1/salt/ \
    && mkdir /app

COPY srcs/. .

RUN echo "Lunch all services\n" \
    && service mysql start \
    && echo "- Configure MySql" \
    && mysql -u root < /app/init_WPDB.sql \
    && echo "- Installing phpmyadmin" \
    && tar -xf  /tmp/phpMyAdmin-4.8.4-all-languages.tar.gz -C /tmp \
    && mv /tmp/phpMyAdmin-4.8.4-all-languages /usr/share/phpmyadmin \
    && echo "- Configuring phpMyAdmin" \
    && ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin \
    && mv var/www/html/config.inc.php var/www/html/phpmyadmin/config.inc.php \
    && chown -R www-data:www-data /var/www/html/phpmyadmin \
    && sed -i "s~\$cfg\['blowfish_secret'\] = '';~\$cfg\['blowfish_secret'\] = 'STRINGOFTHIRTYTWORANDOMCHARACTERS';~g" /usr/share/phpmyadmin/config.inc.php \
    && echo "- installing WordPress" \
    && mkdir /var/www/html/wordpress \
    && tar xzf /tmp/latest.tar.gz --strip-components=1 -C /var/www/html/wordpress \
    && echo "- Configuring WordPress" \
    && mv /var/www/html/wp-config.php /var/www/html/wordpress/wp-config.php \
    && chown -R www-data:www-data /var/www/html/wordpress \
    && find /var/www/html/wordpress/ -type d -exec chmod 750 {} \; \
    && find /var/www/html/wordpress/ -type f -exec chmod 640 {} \; \
    && sed -i -e "/^define( 'AUTH_KEY',         'put your unique phrase here' );/r /tmp/wp_key.txt" -e "/^define( 'AUTH_KEY',         'put your unique phrase here' );/,/^define( 'NONCE_SALT',       'put your unique phrase here' );/d" /var/www/html/wordpress/wp-config.php \
    && rm /tmp/wp_key.txt /var/www/html/index.nginx-debian.html

RUN echo "- configurate SSL"\
    && mkdir /app/ssl \
    && openssl req -nodes -newkey rsa:2048 -sha256 -keyout /app/ssl/private.key -out /app/ssl/server.csr -subj "/C=FR/ST=69/L=Lyon/O=LECAILLE NATHAN/CN=Localhost" \
    && openssl x509 -req -days 365 -in /app/ssl/server.csr -signkey /app/ssl/private.key -out /app/ssl/server.crt \
    && nginx -t

ENV AUTOINDEX="ON"
CMD service mysql restart && service php7.3-fpm start &&  nginx -g 'daemon off;'
