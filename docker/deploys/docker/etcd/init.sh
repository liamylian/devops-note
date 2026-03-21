#!/bin/bash

NAME=etcd
WD=/home/liam/VMs/etcd

# 创建数据目录
sudo mkdir -p $WD/data && sudo chmod 777 $WD/data

# 启动（首次无密码）
sudo docker rm -f $NAME
sudo docker run -d --name $NAME --restart always \
  -v $WD/data:/etcd-data \
  -p 2379:2379 \
  -p 2380:2380 \
  quay.io/coreos/etcd:v3.5.28 \
  /usr/local/bin/etcd \
  --data-dir=/etcd-data \
  --name=etcd-single \
  --listen-client-urls=http://0.0.0.0:2379 \
  --advertise-client-urls=http://0.0.0.0:2379 \
  --listen-peer-urls=http://0.0.0.0:2380 \
  --initial-advertise-peer-urls=http://0.0.0.0:2380 \
  --initial-cluster=etcd-single=http://0.0.0.0:2380 \
  --initial-cluster-token=etcd-cluster \
  --initial-cluster-state=new \
  --auto-compaction-mode=periodic \
  --auto-compaction-retention=12h

# 进入容器启用认证（只需执行一次）：
#   echo "changeme" | docker exec -i etcd etcdctl user add root --interactive=false
#   docker exec -i etcd etcdctl user grant-role root root
#   docker exec -i etcd etcdctl auth enable
