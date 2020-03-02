bash CLEAN.sh
docker build -t mydoc . 
docker run --name mydoc_cont -p 80:80 mydoc