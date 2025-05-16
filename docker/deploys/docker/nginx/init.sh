#!/bin/bash

NAME=infra-nginx
HOST_DIR=/data/docker-vms/infra/nginx

host_conf_file=${HOST_DIR}/nginx.conf
host_conf_dir=${HOST_DIR}/conf.d
host_certs_dir=${HOST_DIR}/certs
host_static_dir=${HOST_DIR}/static


# SGID 共享目录功能，目前在容器中还不好使用
# sudo useradd -r nginx
# cat /etc/group | grep nginx
# sudo chmod 2777 $host_static_dir

sudo docker rm -f ${NAME}

sudo docker run -d \
  --name ${NAME} \
  --net host \
  --restart always \
  -v $host_conf_file:/etc/nginx/nginx.conf \
  -v $host_conf_dir:/etc/nginx/conf.d \
  -v $host_certs_dir:/etc/nginx/certs \
  -v $host_static_dir:/usr/share/nginx/html \
  nginx:1.25.4