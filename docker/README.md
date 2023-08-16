# Docker

## 清理镜像

```
docker image prune -a
docker image prune -a -f # 强制，不需要确认
```

## 代理

```
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://xxxxx.mirror.aliyuncs.com"]
}
EOF
systemctl daemon-reload
systemctl restart docker
```


```
tee /etc/docker/config.json <<-'EOF'
{
    "proxies": {
          "default": {
                  "httpProxy":"socks5h://user:password@xxx.com:1080",
                  "httpsProxy":"socks5h://user:password@xxx.com:1080"
          }
    }
}
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
