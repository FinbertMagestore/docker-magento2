#!/usr/bin/env bash
USER=$1
if [[ ! $USER ]]; then
    USER=ww-data
fi
docker exec -u $1 -it docker-magento2_magento_1 /bin/bash