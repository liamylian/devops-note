#!/bin/bash

NAME=clickhouse
WD=/home/liam/VMs/clickhouse

sudo docker rm -f $NAME
sudo docker run -d --name $NAME \
  -e CLICKHOUSE_USER=root \
  -e CLICKHOUSE_PASSWORD=changeme \
  -v $WD/data:/var/lib/clickhouse \
  -v $WD/logs:/var/log/clickhouse-server \
  -p 8123:8123 \
  -p 9000:9000 \
  --ulimit nofile=262144:262144 \
  clickhouse:25.6.4
