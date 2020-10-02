echo "Delete all <none> images"
docker rmi $(docker images -a | grep "<none>" | cut -d " " -f29)
echo "Delete all stopped container"
docker rm $(docker ps -a -q)
