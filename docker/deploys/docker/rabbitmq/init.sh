#!/bin/bash

NAME=infra-rabbitmq
WD=/data/docker-vms/infra/rabbitmq

sudo docker rm -f $NAME

sudo docker run -d --name $NAME --restart always \
  -e RABBITMQ_DEFAULT_USER=root \
  -e RABBITMQ_DEFAULT_PASS=changeme \
  -v $WD/data:/var/lib/rabbitmq \
  -p 5672:5672 \
  rabbitmq:3.12.13