docker rmi $(docker images -a | grep "<none>" | cut -d " " -f29)
docker rm $(docker ps -a -q)
