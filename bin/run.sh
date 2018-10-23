#!/usr/bin/env bash

docker-compose up -d
bash -c 'while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' magento2.com:9090)" != "200" ]]; do sleep 3; done'