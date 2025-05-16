#!/bin/bash

NAME=ubuntu-systemd
WD=/data/docker-vms/test-vms/${NAME}

sudo docker run -d --name ${NAME} \
  ubuntu-systemd:latest