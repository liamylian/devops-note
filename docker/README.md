# Docker

## 清理镜像

```
docker image prune -a
docker image prune -a -f # 强制，不需要确认
```

## 代理

```
# https://github.com/DaoCloud/public-image-mirror
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": [
    "https://docker.m.daocloud.io"
  ]
}
EOF
systemctl daemon-reload
systemctl restart docker
```


```
mkdir -p /etc/systemd/system/docker.service.d
tee /etc/docker/http-proxy.conf <<-'EOF'
[Service]
Environment="HTTP_PROXY=socks5://user:password@abc.com:1080" "HTTPS_PROXY=socks5://user:password@abc.com:1080" "NO_PROXY=localhost,127.0.0.1"
EOF
```

## 免超级用户

```
sudo usermod -aG docker $USER
reboot
```

## 导出导入

```
docker save -o nginx.tar nginx:latest
gzip nginx.tar nginx.tar.gz
gzip -d nginx.tar.gz
docker load -i nginx.tar
```

```
docker export -o nginx.tar nginx:latest
docker import -i nginx.tar nginx:latest
```
