create database WPDB;
create USER nlecaill@localhost;
grant all privileges on WPDB.* to nlecaill@localhost IDENTIFIED BY 'PASSS';;
FLUSH privileges;