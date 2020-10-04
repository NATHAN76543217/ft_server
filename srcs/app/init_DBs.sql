create database WPDB;
create database phpmyadmin;
create USER nlecaill@localhost;
grant all privileges on WPDB.* to nlecaill@localhost IDENTIFIED BY 'PASSS';
GRANT all privileges on phpmyadmin.* to nlecaill@localhost;
FLUSH privileges;