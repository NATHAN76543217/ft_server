# ft_server

Projet web du cursus 2019 de l'école 42 by Nlecaill.

***But***: Automatiser la création et la mise en fonctionnement d'un serveur avec docker.


* server: nginx
* services:
    * BDD mariadb
    * phpMyAdmin
    * WordPress

L'Auto-indexage est activable/désactivable en donnant à la variable d'environnement AUTOINDEX une des valeurs ["on","ON","off" "OFF"]  
puis en exécutant le script **/app/MAJ_auto_index.sh**

-----

***Les scripts***
* LUNCH.sh: Construit une image docker puis lance un container à partir de cet image.
* RELUNCH.sh: Lance STOP.sh, DELETE.sh puis LUNCH.sh
* STOP.sh: Stop le container Docker.
* DELETE.sh: Supprime le container docker ainsi que son image.
* CLEAN.sh: Supprime toutes les images intermediaires qui ont pu étre créés ainsi que tout les containers.

-----

# Docker

 ***Les commandes Docker***:

- Crée une image docker: docker build <-path repertoire du dockerfile->
    - -t = permet de donner un nom au container.

- Lancer un container: docker run <-image name->
    - -d : permet de detacher le container du processus: le terminal redevient utilisable
    - -p : permet de définir les redirections de port au format (externe:interne) 8080:80.
    - -t: empeche le container de se fermer meme si aucune commande n'est lancé.
    - -name: permet de donner un nom au container 

- Executer une commande dans le container: docker exec <-container name-> <-command->
    - Entrer dans un container docker: docker exec -ti <-container name-> bash

- Lister les container: docker ps

- Stopper un container: docker stop <-container name->

- Forcer l'arret d'un container: docker kill <-container name->

- Supprimer un container: docker rm <-container name->



***Les commandes du dockerfile***:

* FROM: Permet d'indiquer à partir de quel image nous voulons crée notre image.
* RUN: Permet d'executer des commandes dans le container.
* ADD: Permet de crée un fichier ou un dossier.
* EXPORT: indique les ports d'écoute du container pour une communication INTER-CONTAINER sinon utiliser docker run -p
* WORKDIR: indique le repertoire courant
* VOLUME: permet d'indiquer quel repertoire l'on veut partager avec l'host
* CMD: définit la commande par defaut.
