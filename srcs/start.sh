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
nginx -t
service nginx restart

#telecharger wordpress
wget https://wordpress.org/latest.tar.gz -P /tmp
mkdir /var/www/html/wordpress
tar xzf /tmp/latest.tar.gz --strip-components=1 -C /var/www/html/wordpress
cp /var/www/html/wordpress/wp-config{-sample,}.php

#generer une cle de secu
curl -s https://api.wordpress.org/secret-key/1.1/salt/ > /tmp/key.txt

#remplacer les cless de secu dans le fichier
sed -i -e "/^define( 'AUTH_KEY',         'put your unique phrase here' );/r tmp/key.txt" -e "/^define( 'AUTH_KEY',         'put your unique phrase here' );/,/^define( 'NONCE_SALT',       'put your unique phrase here' );/d" /var/www/html/wp-config.php

#definir les parametre de config wordpress
sed -i "s/define( 'DB_NAME', 'database_name_here' );/define( 'DB_NAME', 'nathandemo' );/g" /var/www/html/wordpress/wp-config.php
sed -i "s/define( 'DB_USER', 'username_here' );/define( 'DB_USER', 'nathanuser' );/g" /var/www/html/wordpress/wp-config.php
sed -i "s/define( 'DB_PASSWORD', 'password_here' );/define( 'DB_PASSWORD', 'Str0nGPassword' );/g" /var/www/html/wordpress/wp-config.php
sed -i "s/define( 'DB_HOST', 'localhost' );/define( 'DB_HOST', 'localhost' );/g" /var/www/html/wordpress/wp-config.php
sed -i "s/define( 'DB_CHARSET', 'utf8' );/define( 'DB_CHARSET', 'utf8' );/g" /var/www/html/wordpress/wp-config.php
chown -R www-data:www-data /var/www/html/

#telecharge PhpMyAdmin
wget https://files.phpmyadmin.net/phpMyAdmin/4.8.4/phpMyAdmin-4.8.4-all-languages.tar.gz -P /tmp
tar -xf  /tmp/phpMyAdmin-4.8.4-all-languages.tar.gz -C /tmp
mv /tmp/phpMyAdmin-4.8.4-all-languages /usr/share/phpmyadmin

#configure phpMyadmin
mkdir -p /var/lib/phpmyadmin/tmp
chown -R www-data:www-data /var/lib/phpmyadmin
cp /usr/share/phpmyadmin/config.sample.inc.php /usr/share/phpmyadmin/config.inc.php
sed -i "s~\$cfg\['blowfish_secret'\] = '';~\$cfg\['blowfish_secret'\] = 'STRINGOFTHIRTYTWORANDOMCHARACTERS';~g" /usr/share/phpmyadmin/config.inc.php
echo "\$cfg['TempDir'] = '/var/lib/phpmyadmin/tmp';" >> /usr/share/phpmyadmin/config.inc.php

#cree les tables sql necessaires a PMA
mysql -u root < /usr/share/phpmyadmin/sql/create_tables.sql
mysql -u root < /app/conf_php.sql
ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin


#generer cle rsa necessaire a la creation d'un certificat
mkdir /var/certs
touch /tmp/passfile
echo "motdepasse" >> /tmp/passfile
openssl genrsa -des3 -passout file:/tmp/passfile -out /var/certs/server.key 4096
#generer fichier csr
openssl req -batch -passin file:/tmp/passfile -new -key /var/certs/server.key -out /var/certs/server.csr
openssl req -new -sha256 -key /var/certs/server.key -subj "/C=FR/ST=CA/O=MyOrg, Inc./CN=localhost" -out /var/certs/server.csr

#enlever la demande auto de mot de passe
cp /var/certs/server.key /var/certs/server.key.org
openssl rsa -passin file:/tmp/passfile -in /var/certs/server.key.org -out /var/certs/server.key
# generation du certificat
openssl x509 -req -days 365 -in /var/certs/server.csr -signkey /var/certs/server.key -out /var/certs/server.crt
# ln /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
nginx -t
service nginx restart
#gerer auto index
echo autoindex = $(printenv autoindex)
echo autoindex = $(printenv autoindex) | grep on | wc | sed 's/^[ \t]*//' | cut -f1 -d ' ' 
while true; do sleep 1000; done
