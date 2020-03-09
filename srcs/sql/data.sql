create database wordpress;
create USER pma@localhost;
grant all privileges on wordpress.* to pma@localhost;
FLUSH privileges;