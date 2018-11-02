#!/usr/bin/env bash

docker-compose rm -s -f
docker-compose down --rmi all
docker image prune