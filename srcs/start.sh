#!/bin/bash

service mysql start
#sed -i -r 's/index index.html index.htm index.nginx-debian.html/index index.html index.htm index.nginx-debian.html index.php/g' /etc/nginx/sites-enabled/default
#sed -i 's/\t#location ~ \\.php\$ {/\tlocation ~ \\.php$ {/g' /etc/nginx/sites-enabled/default
#sed -i 's|#\tfastcgi_pass unix:/run/php/php7.3-fpm.sock;|\tfastcgi_pass unix:/run/php/php7.3-fpm.sock;\n}|g' /etc/nginx/sites-enabled/default
nginx -t
service nginx restart
echo "coucou"

service php7.3-mysql start
service php7.3-fpm start
echo "PHP start"

#touch /var/www/html/index.php
#echo "<?php phpinfo();" >> /var/www/html/index.php
#cat /var/www/html/index.php
while true; do sleep 1000; done
