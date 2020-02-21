FROM debian:10
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y nginx
RUN apt-get install -y mariadb-server
RUN apt-get install -y php-fpm php-mysql

COPY ./srcs/start.sh ./app/
CMD ["/bin/bash", "/app/start.sh"] +
