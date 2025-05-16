FROM ubuntu:22.04

RUN apt update && apt install -y python3-pip
RUN pip3 install docker-systemctl-replacement && \
    cp /usr/local/bin/systemctl.py /usr/bin/systemctl

CMD ["systemctl.py", "--init"]