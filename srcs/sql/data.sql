create database nathandemo;
CREATE USER nathanuser@localhost IDENTIFIED BY 'Str0nGPassword';
grant all privileges on nathandemo.* to nathanuser@localhost;
FLUSH privileges;