# Build and run:
#   docker build --build-arg UID=$(id -u) -t liamylian/cpp-env-ubuntu:1.0 -f Dockerfile.cpp-env-ubuntu .
#
#   For more information, see: https://www.jetbrains.com/help/clion/clion-toolchains-in-docker.html

FROM ubuntu:20.04

# On macOS and Linux, CLion uses the host UID due to file permission limitations when writing to volumes from Docker containers
ARG UID=1000
RUN useradd -m -u ${UID} -s /bin/bash builder
USER builder

RUN sed -i s/archive.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list && \
    sed -i s/security.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list

RUN DEBIAN_FRONTEND="noninteractive" apt-get update && apt-get -y install tzdata

RUN apt-get update \
  && apt-get install -y build-essential \
      gcc \
      g++ \
      gdb \
      clang \
      make \
      ninja-build \
      cmake \
      autoconf \
      automake \
      locales-all \
      dos2unix \
      rsync \
      tar \
      python \
      python-dev \
  && apt-get clean