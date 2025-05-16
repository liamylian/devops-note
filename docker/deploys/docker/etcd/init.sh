#!/bin/bash

#
# https://etcd.io/docs/v3.4/op-guide/configuration/
#

NAME=infra-etcd
WD=/data/docker-vms/infra/etcd

sudo mkdir $WD/data && sudo chmod 777 $WD/data

sudo docker rm -f $NAME

sudo docker run -d --name $NAME --restart always \
  -e ETCD_AUTO_COMPACTION_MODE=periodic \
  -e ETCD_AUTO_COMPACTION_RETENTION=12h \
  -e ETCD_ROOT_PASSWORD=changeme \
  -e ETCD_ADVERTISE_CLIENT_URLS=http://localhost:2379 \
  -v $WD/data:/bitnami/etcd/ \
  -p 2379:2379 \
  bitnami/etcd:3.5.13