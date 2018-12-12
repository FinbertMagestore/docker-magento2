#!/usr/bin/env bash

docker-compose up -d
docker exec -u root -it docker-magento2_magento_1 bash -c "chown -R www-data:www-data ./ && chmod -R 777 ./"
docker exec -u www-data -it docker-magento2_magento_1 bash -c "./install_magento.sh"