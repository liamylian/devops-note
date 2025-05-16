FROM alpine:3.19

RUN sed -e 's/dl-cdn[.]alpinelinux.org/mirrors.aliyun.com/g' -i~ /etc/apk/repositories && \
    apk update && \
    apk add --no-cache bash git openssh rsync augeas shadow rssh && \
    deluser $(getent passwd 33 | cut -d: -f1) && \
    delgroup $(getent group 33 | cut -d: -f1) 2>/dev/null || true && \
    mkdir -p ~root/.ssh /etc/authorized_keys && chmod 700 ~root/.ssh/ && \
    augtool 'set /files/etc/ssh/sshd_config/AuthorizedKeysFile ".ssh/authorized_keys /etc/authorized_keys/%u"' && \
    echo -e "Port 22\n" >> /etc/ssh/sshd_config && \
    cp -a /etc/ssh /etc/ssh.cache && \
    rm -rf /var/cache/apk/*

EXPOSE 22
ENV SSH_ENABLE_ROOT=true
ENV SSH_ENABLE_ROOT_PASSWORD_AUTH=true

RUN mkdir -p /etc/entrypoint.d/
COPY entrypoint.d/setpasswd.sh /etc/entrypoint.d/
COPY entry.sh /entry.sh

ENTRYPOINT ["/entry.sh"]

CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config"]