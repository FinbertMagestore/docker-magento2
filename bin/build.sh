#!/usr/bin/env bash

# stop then remove all container start by docker composer
sudo docker-compose rm -s -f
sudo docker-compose down --rmi all
sudo docker-compose build