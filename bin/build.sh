#!/usr/bin/env bash

source .env
cp data/prepare_data/$MAGENTO_VERSION data/prepare_data/magento2.sql

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
if [[ ! -f /etc/nginx/sites-enabled/$NGINX_CONF ]]; then
  sudo ln -s /etc/nginx/sites-available/$NGINX_CONF /etc/nginx/sites-enabled/
fi
sudo service nginx restart

sudo cp magento/install_magento.sh src/
# stop then remove all container start by docker composer
 docker-compose build