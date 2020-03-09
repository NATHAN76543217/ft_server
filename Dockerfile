FROM debian:10
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y nginx
RUN apt-get install -y openssl
RUN apt-get install -y mariadb-server
RUN apt-get install -y php php-common php-fpm php-mysql php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip
RUN apt-get install -y vim
RUN apt-get install -y wget
RUN apt-get install -y curl
RUN apt-get install -y net-tools

COPY    ./srcs/start.sh ./app/start.sh


#install nginx configuration
RUN     rm ./etc/nginx/sites-available/default ./etc/nginx/sites-enabled/default
COPY    ./srcs/configs/nathandemo ./etc/nginx/sites-available/default
RUN     chmod +x /etc/nginx/sites-available/default
RUN     cp ./etc/nginx/sites-available/default ./etc/nginx/sites-enabled/default

#telecherger wordpress
RUN wget https://wordpress.org/latest.tar.gz -P /tmp
RUN mkdir /var/www/html/wordpress
RUN tar xzf /tmp/latest.tar.gz --strip-components=1 -C /var/www/html/wordpress
RUN cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

#telecharger phppyadmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.8.4/phpMyAdmin-4.8.4-all-languages.tar.gz -P /tmp
RUN tar -xf  /tmp/phpMyAdmin-4.8.4-all-languages.tar.gz -C /tmp
RUN mv /tmp/phpMyAdmin-4.8.4-all-languages /usr/share/phpmyadmin

#COPY ./srcs/default ./etc/nginx/sites-enabled/default
COPY    ./srcs/sql/data.sql ./app/data.sql
COPY    ./srcs/sql/conf_php.sql ./app/conf_php.sql
COPY    ./srcs/doc.html ./var/www/html/doc.html
EXPOSE  80
EXPOSE  443
ENV     autoindex=on
CMD ["/bin/bash", "/app/start.sh"]
