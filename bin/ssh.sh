#!/usr/bin/env bash
USER=ww-data
if [[ $1 ]]; then
    USER=$1
fi
docker exec -u $1 -it docker-magento2_magento_1 /bin/bash