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

#COPY ./srcs/default ./etc/nginx/sites-enabled/default
COPY    ./srcs/sql/data.sql ./app/data.sql
COPY    ./srcs/sql/conf_php.sql ./app/conf_php.sql
COPY    ./srcs/doc.html ./var/www/html/doc.html
EXPOSE  80
EXPOSE  443
ENV     autoindex=on
CMD ["/bin/bash", "/app/start.sh"] +
