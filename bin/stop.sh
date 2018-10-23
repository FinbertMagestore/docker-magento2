#!/usr/bin/env bash

docker-compose down
docker-compose rm -s -f
docker-compose down --rmi all