#!/usr/bin/env bash

# install nginx
sudo apt update
sudo apt install nginx -y
sudo ufw allow 'Nginx HTTP'
sudo service nginx restart

# init nginx reverse proxy
sudo mkdir -p /etc/nginx/ssl
sudo cp magento/server.crt /etc/nginx/ssl/magento2_ssl.crt
sudo cp magento/server.key /etc/nginx/ssl/magento2_ssl.key

NGINX_CONF=nginx-magento2-docker.conf
sudo cp nginx/$NGINX_CONF /etc/nginx/sites-available
if [[ ! -f /etc/nginx/sites-available/$NGINX_CONF ]]; then
  echo "file site available not exist"
  exit
fi
sudo ln -s /etc/nginx/sites-available/$NGINX_CONF /etc/nginx/sites-enabled/
sudo service nginx restart

# stop then remove all container start by docker composer
 docker-compose build