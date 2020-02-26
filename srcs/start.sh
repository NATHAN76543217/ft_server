#!/bin/bash

service mysql start
#sed -i -r 's/index index.html index.htm index.nginx-debian.html/index index.html index.htm index.nginx-debian.html index.php/g' /etc/nginx/sites-enabled/default
#sed -i 's/\t#location ~ \\.php\$ {/\tlocation ~ \\.php$ {/g' /etc/nginx/sites-enabled/default
#sed -i 's|#\tfastcgi_pass unix:/run/php/php7.3-fpm.sock;|\tfastcgi_pass unix:/run/php/php7.3-fpm.sock;\n}|g' /etc/nginx/sites-enabled/default
nginx -t
service nginx restart

service php-mysql start
service php7.3-fpm start
mysql -u root < ./app/data.sql
ln -s /etc/nginx/sites-available/nathandemo /etc/nginx/sites-enabled/
nginx -t
service nginx restart
wget https://wordpress.org/latest.tar.gz -P /tmp
tar xzf /tmp/latest.tar.gz --strip-components=1 -C /var/www/html/
cp /var/www/html/wp-config{-sample,}.php
curl -s https://api.wordpress.org/secret-key/1.1/salt/ > key.txt
sed -i -e "/^define( 'AUTH_KEY',         'put your unique phrase here' );/r key.txt" -e "/^define( 'AUTH_KEY',         'put your unique phrase here' );/,/^define( 'NONCE_SALT',       'put your unique phrase here' );/d" /var/www/html/wp-config.php
sed -i "s/define( 'DB_NAME', 'database_name_here' );/define( 'DB_NAME', 'nathandemo' );/g" /var/www/html/wp-config.php
sed -i "s/define( 'DB_USER', 'username_here' );/define( 'DB_USER', 'nathanuser' );/g" /var/www/html/wp-config.php
sed -i "s/define( 'DB_PASSWORD', 'password_here' );/define( 'DB_PASSWORD', 'Str0nGPassword' );/g" /var/www/html/wp-config.php
sed -i "s/define( 'DB_HOST', 'localhost' );/define( 'DB_HOST', 'localhost' );/g" /var/www/html/wp-config.php
sed -i "s/define( 'DB_CHARSET', 'utf8' );/define( 'DB_CHARSET', 'utf8' );/g" /var/www/html/wp-config.php
chown -R www-data:www-data /var/www/html/

#touch /var/www/html/index.php
#echo "<?php phpinfo();" >> /var/www/html/index.php
#cat /var/www/html/index.php
while true; do sleep 1000; done
