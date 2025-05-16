#!/bin/bash

NAME=infra-minio
WD=/data/docker-vms/infra/minio

sudo docker rm -f $NAME

sudo docker run -d --name $NAME \
  --restart always \
  -e MINIO_ACCESS_KEY=root \
  -e MINIO_SECRET_KEY=changeme \
  -p 9000:9000 \
  -p 9001:9001 \
  -v "$WD"/data:/data \
  minio/minio:RELEASE.2024-03-03T17-50-39Z \
  server /data --console-address ":9001"

# 在局域网的其他节点上，执行如下命令
# sudo iptables -t nat -A OUTPUT -d 63.218.225.68/32 -p tcp -m tcp --dport 9000 -j DNAT --to-destination 10.122.130.131:9000
# sudo iptables -t nat -A PREROUTING -d 63.218.225.68/32 -p tcp -m tcp --dport 9000 -j DNAT --to-destination 10.122.130.131:9000
