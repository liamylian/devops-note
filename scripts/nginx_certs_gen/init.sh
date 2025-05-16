#!/bin/bash

HOST_CONF_DIR=/home/ubuntu/nginx/conf.d
HOST_CERTS_DIR=/home/ubuntu/nginx/certs

sudo docker run -d \
  --name nginx \
  --hostname nginx \
  --net host \
  --restart always \
  -v $HOST_CONF_DIR:/etc/nginx/conf.d \
  -v $HOST_CERTS_DIR:/etc/nginx/certs \
  nginx