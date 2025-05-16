#!/bin/bash

VM=infra-mongodb
WD=/data/docker-vms/infra/mongodb

sudo docker rm -f $VM

sudo docker run -d \
  --name $VM \
  --restart always \
  -e MONGO_INITDB_ROOT_USERNAME=root \
  -e MONGO_INITDB_ROOT_PASSWORD=changeme \
  -v $WD/data:/data/db \
  -p 27017:27017 \
  mongo:7.0.5