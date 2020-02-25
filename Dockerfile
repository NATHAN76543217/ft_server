FROM debian:10
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y nginx
RUN apt-get install -y mariadb-server
RUN apt-get install -y php php-common php-fpm php-mysql php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip
RUN apt-get install -y vim

COPY ./srcs/start.sh ./app/
COPY ./srcs/default ./etc/nginx/sites-enabled/default
#COPY ./srcs/doc.html ./var/www/html/doc.html
CMD ["/bin/bash", "/app/start.sh"] +
