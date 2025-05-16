FROM ubuntu:22.04

RUN apt update && apt install -y docker.io python3-pip && \
    sed -i 's#\(ExecStart=.*\)-H fd:\/\/\(.*\)#\1\2#' /usr/lib/systemd/system/docker.service
RUN pip3 install docker-systemctl-replacement && \
    cp /usr/local/bin/systemctl.py /usr/bin/systemctl

CMD ["systemctl.py", "--init"]