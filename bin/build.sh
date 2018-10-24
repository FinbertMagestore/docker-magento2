#!/usr/bin/env bash

# stop then remove all container start by docker composer
cp magento/install_magento.sh src/
docker-compose build