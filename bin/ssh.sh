#!/usr/bin/env bash
if [[ $1 ]]; then
  echo "need add param name user to ssh"
  exit
fi
docker exec -u $1 -it docker-magento2_magento_1 /bin/bash