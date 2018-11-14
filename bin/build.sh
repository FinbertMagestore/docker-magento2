#!/usr/bin/env bash

# init folder mount docker
mkdir -p src
mkdir -p data/mysql

# remove all persist data
sudo rm -rf data/mysql/*
sudo rm -rf src/*
sudo rm -rf src/.*
rm data/prepare_data/magento2.sql
sudo rm /etc/nginx/sites-available/nginx-magento2-docker*
sudo rm /etc/nginx/sites-enabled/nginx-magento2-docker*

if [[ ! -f magento/magento2.tar.gz ]]; then
  echo "Please place file magento2.tar.gz at folder magento"
  exit
fi

if [[ ! -f src/magento2.tar.gz ]]; then
    cp magento/magento2.tar.gz src/
fi

source .env
cp data/prepare_data/$MAGENTO_VERSION.sql data/prepare_data/magento2.sql

# install nginx
sudo apt update
sudo apt install nginx -y
sudo ufw allow 'Nginx HTTP'
sudo service nginx restart

# init nginx reverse proxy
sudo mkdir -p /etc/nginx/ssl
sudo cp magento/server.crt /etc/nginx/ssl/magento2_ssl.crt
sudo cp magento/server.key /etc/nginx/ssl/magento2_ssl.key

NGINX_CONF=nginx-magento2-docker
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