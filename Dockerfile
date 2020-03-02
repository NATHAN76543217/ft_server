FROM debian:10
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y nginx
RUN apt-get install -y openSSL
RUN apt-get install -y mariadb-server
RUN apt-get install -y php php-common php-fpm php-mysql php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip
RUN apt-get install -y vim
RUN apt-get install -y wget
RUN apt-get install -y curl


COPY ./srcs/start.sh ./app/start.sh
COPY ./srcs/default ./etc/nginx/sites-enabled/default
COPY ./srcs/data.sql ./app/data.sql
COPY ./srcs/conf_php.sql ./app/conf_php.sql
COPY ./srcs/nathandemo ./etc/nginx/sites-available/nathandemo 
#COPY ./srcs/doc.html ./var/www/html/doc.html
EXPOSE 80
EXPOSE 443
CMD ["/bin/bash", "/app/start.sh"] +
