#!/bin/bash

NAME=testbuild

REGISTRIES=user:password@192.168.2.98:8443
INSECURE_REGISTRIES=192.168.2.98:8443
GIT_URL=http://user:password@192.168.2.98:8929/liamylian/testbuild.git
GIT_COMMIT=
BUILD_IMAGE=192.168.2.98:8443/library/testbuild:latest

docker run --rm --name "$NAME" \
  -e REGISTRIES="$REGISTRIES" \
  -e INSECURE_REGISTRIES="$INSECURE_REGISTRIES" \
  -e GIT_URL="$GIT_URL" \
  -e GIT_COMMIT="$GIT_COMMIT" \
  -e BUILD_IMAGE="$BUILD_IMAGE" \
  -v /sys/fs/cgroup:/sys/fs/cgroup \
  --mount type=tmpfs,target=/var/lib/containers \
  --privileged \
  builder:latest