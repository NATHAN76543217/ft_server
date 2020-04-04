docker container kill mydoc_cont && docker container rm -v mydoc_cont
docker build -t mydoc . && docker run --name mydoc_cont -p 80:80 -p 443:443 mydoc
