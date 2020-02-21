#!/bin/bash

service mysql start
sed -i -r 's/index index.html index.htm index.nginx-debian.html/index index.html index.htm index.nginx-debian.html index.php/g' /etc/nginx/sites-enabled/default
sed -i -r 's|        #location ~ \.php$ {|        location ~ \.php$ {|g' /etc/nginx/sites-enabled/default
sed -i -r 's|       #       fastcgi_pass unix:/run/php/php7.3-fpm.sock;|              fastcgi_pass unix:/run/php/php7.3-fpm.sock;|g' /etc/nginx/sites-enabled/default
while true; do sleep 1000; done