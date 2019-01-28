#!/usr/bin/env bash

source .env

# init folder mount docker
mkdir -p src
mkdir -p data/mysql

sudo rm /etc/nginx/sites-available/nginx-magento2-docker*
sudo rm /etc/nginx/sites-enabled/nginx-magento2-docker*

if [[ ! -f magento/magento2.tar.gz ]]; then
  echo "Please place file magento2.tar.gz at folder magento"
  exit
fi

if [[ ! -f src/magento2.tar.gz ]]; then
    cp magento/magento2.tar.gz src/
fi

# install nginx
if ! which nginx > /dev/null 2>&1; then
    echo "Nginx installing ..."
    sudo apt update
    sudo apt install nginx -y
    sudo ufw allow 'Nginx Full'
    sudo service nginx restart
fi
echo "Nginx installed."

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