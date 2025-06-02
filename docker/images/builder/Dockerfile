FROM ubuntu:22.04

# buildah 容器需要开启如下功能才能制作镜像：
#   1. 使用特权模式(--privileged)
#   2. 挂载宿主机 /sys/fs/cgroup，从而获得写权限
#   3. 从宿主机挂载一个目录到容器内 /var/lib/containers
#
# 如：
#   docker run -td --name builder --privileged -v /sys/fs/cgroup:/sys/fs/cgroup -v ./:/var/lib/containers builder:latest sh

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /root

RUN apt-get update && apt-get install -y buildah vim git git-lfs

COPY config.sh /config.sh
COPY start.sh /start.sh
RUN chmod +x /config.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]