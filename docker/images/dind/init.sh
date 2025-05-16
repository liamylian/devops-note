#!/bin/bash

#
# https://docs.docker.com/engine/containers/run/
# https://docs.docker.com/engine/security/seccomp/
# https://pypi.org/project/docker-systemctl-replacement/
#

NAME=dind
WD=/data/workspace/docker-vms/${NAME}

sudo docker run -d --name ${NAME} \
  --privileged \
  dind:latest