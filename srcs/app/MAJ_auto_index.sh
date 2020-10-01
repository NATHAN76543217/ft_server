if [ "${AUTOINDEX}" = "off" ] || [ "${AUTOINDEX}" = "OFF" ]
then
    sed -i "s/autoindex on/autoindex off/" /etc/nginx/sites-available/default;
    nginx -s reload
elif [ "${AUTOINDEX}" = "on" ] || [ "${AUTOINDEX}" = "ON" ]
then
    sed -i "s/autoindex off/autoindex on/" /etc/nginx/sites-available/default;
    nginx -s reload
else
    echo "Syntax error in env variable AUTOINDEX"
fi