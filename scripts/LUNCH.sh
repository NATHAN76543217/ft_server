echo "Build img_server"
docker build -t img_server .
echo "Run container_server"
docker run -d -t --name container_server -p 80:80 -p 443:443 img_server