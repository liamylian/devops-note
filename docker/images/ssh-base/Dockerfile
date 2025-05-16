# 替换为你的基础镜像
FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt install openssh-server -y && \
    mkdir -p /var/run/sshd && mkdir -p /root/.ssh

ADD sshd_config /etc/ssh/

# 后台能运行，使用本命令
# chmod 700 /etc/ssh/*_key
# chmod 700 /run/sshd
# service ssh start
CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config"]