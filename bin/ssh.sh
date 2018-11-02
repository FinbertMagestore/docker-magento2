#!/usr/bin/env bash
USER=$1
if [[ ! $USER ]]; then
    USER=www-data
fi
docker exec -u $USER -it docker-magento2_magento_1 /bin/bash