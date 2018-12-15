#!/usr/bin/env bash

source bin/common.sh

function check_nginx_installed() {
    if ! which nginx > /dev/null 2>&1; then
        echo "Install Nginx..."
        # install nginx
        sudo apt update
        sudo apt install nginx -y
        sudo ufw allow 'Nginx Full'
        sudo service nginx restart
    fi
    echo "Nginx installed."
}

function copy_ssl() {
    # init nginx reverse proxy
    sudo mkdir -p /etc/nginx/ssl
    sudo cp magento/server.crt /etc/nginx/ssl/magento2_ssl.crt
    sudo cp magento/server.key /etc/nginx/ssl/magento2_ssl.key
}

function init_config_nginx() {
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
}

function prepare_folder_install_magento() {
    cp magento/install_magento2.sh src/install_magento.sh
    local MAGENTO_SOURCE_FILENAME='magento/magento2-'${MAGENTO_VERSION}'.tar.gz'
    cp ${MAGENTO_SOURCE_FILENAME} src/magento.tar.gz
}

function prepare_docker_compose_file() {
    local php_version=`get_version_php "${MAGENTO_VERSION}"`
    local port_service_docker=`get_port_service_docker "${MAGENTO_VERSION}"`
    local port_ssl_service_docker=`get_port_ssl_service_docker "${MAGENTO_VERSION}"`
    docker_compose_file='docker-compose-magento-'${MAGENTO_VERSION}'-php-'${php_version}'.yml'
    if [[ ! -f ${docker_compose_file} ]]; then
cat >${docker_compose_file} <<EOL
version: '3'

services:
  magento${port_service_docker}:
    build:
      context: ./magento
      dockerfile: Dockerfile_image_${php_version}
    container_name: docker-magento2_magento_1
    ports:
      - ${port_service_docker}:80
      - ${port_ssl_service_docker}:443
    depends_on:
      - db
    environment:
      MAGENTO_URL: https://m2.io/
      MYSQL_DATABASE: magento${port_service_docker}
    volumes:
      - ./src:/var/www/html
    networks:
      webnet:
        aliases:
          - m2.io

  db:
    image: ngovanhuy0241/docker-magento-multiple-db:${MAGENTO_VERSION}
    container_name: docker-magento2_db_1
    environment:
      MYSQL_ROOT_PASSWORD: magento
    networks:
      - webnet
networks:
  webnet:
EOL
    fi
}

function main() {
    check_nginx_installed
    copy_ssl
    init_config_nginx
    prepare_folder_install_magento
}

calculate_time_run_command main