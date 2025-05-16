#!/bin/bash

VM=infra-emqx
WD=/data/docker-vms/infra/emqx

sudo docker rm -f $VM

sudo docker run -d \
  --name $VM \
  --restart always \
  -e EMQX_ZONE__EXTERNAL__MAX_MQUEUE_LEN=50000 \
  -e EMQX_ALLOW_ANONYMOUS=false \
  -v $WD/data/loaded_plugins:/opt/emqx/data/loaded_plugins \
  -v $WD/plugins/emqx_auth_mnesia.conf:/opt/emqx/etc/plugins/emqx_auth_mnesia.conf \
  -p 1883:1883 \
  emqx/emqx:4.3.11