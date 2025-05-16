#!/bin/bash

NAME=infra-redis
WD=/data/docker-vms/infra/redis

sudo docker rm -f $NAME
sudo docker run -d --name $NAME --restart always \
  -v $WD/data:/data \
  -p 6389:6379 \
  redis:7.2 \
  redis-server --requirepass changeme