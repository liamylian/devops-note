#!/bin/bash

VM=infra-mysql
WD=/data/docker-vms/infra/mysql

sudo docker rm -f $VM

sudo docker run -d \
  --name $VM \
  --restart always \
  -e MYSQL_ROOT_PASSWORD=changeme \
  -v $WD/data:/var/lib/mysql \
  -p 3306:3306 \
  mysql:8.0.27