# ft_server

Projet web du cusus 2019 de 42_Lyon.

***But***: automatiser la creation et la mise en fonctionnement d'un serveur avec docker.


* serveur: nginx
* services:
    * BDD mariadb
    * phpMyAdmin
    * WordPress

auto-indexage désactible en changeant la ligne
<br/>ENV     autoindex=on
<br/>du dockerfile par
<br/>ENV     autoindex=off
