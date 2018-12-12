#!/usr/bin/env bash

docker-compose up -d
until docker exec -it docker-magento2_db_1 bash -c 'mysql --user=root --password=magento --execute \"SHOW DATABASES;\"' > /dev/null 2>&1; do sleep 2; done
docker exec -u root -it docker-magento2_magento_1 bash -c "chown -R www-data:www-data ./ && chmod -R 777 ./"
docker exec -u www-data -it docker-magento2_magento_1 bash -c "./install_magento.sh"