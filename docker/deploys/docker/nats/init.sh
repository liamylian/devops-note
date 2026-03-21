#!/bin/bash

NAME=nats
WD=/home/liam/VMs/nats

sudo docker rm -f $NAME
sudo docker run -d --name $NAME \
  -e NATS_USERNAME=root \
  -e NATS_PASSWORD=changeme \
  -v $WD/data:/data/jetstream \
  -p 4222:4222 \
  -p 8222:8222 \
  -p 6222:6222 \
  nats:2.12 \
  --js \
  --store_dir /data/jetstream \
  --http_port 8222 \
  --cluster_name nats-cluster
