## 一、首次安装

```shell
# 下载离线安装包 harbor-offline-installer-v2.9.3.tgz (https://github.com/goharbor/harbor/releases/download/v2.9.3/harbor-offline-installer-v2.9.3.tgz)
tar xzvf harbor-offline-installer-v2.9.3.tgz
cp haror.yml.tmpl harbor.yml
# 修改 harbor.yml 中的 hostname、http.port、harbor_admin_password、data_volume 等参数
sudo ./install.sh
```

## 二、后续修改

安装脚本不够灵活，比如生成的 `common/config/core/env` 中的 `EXT_ENDPOINT` 可能不正确，那么需要手动修改，然后执行如下命令:

```shell
sudo docker-compose up -d
```

如果配置需要调整，重新执行 `install.sh` 即可，不会造成数据丢失。

## 三、无法使用公网 IP 访问镜像仓库，或者公网 IP 访问过慢

```shell
# 在局域网的所有节点上，执行如下命令
sudo iptables -t nat -A OUTPUT -d 63.218.225.68/32 -p tcp -m tcp --dport 80 -j DNAT --to-destination 10.122.130.131:80
sudo iptables -t nat -A PREROUTING -d 63.218.225.68/32 -p tcp -m tcp --dport 80 -j DNAT --to-destination 10.122.130.131:80
sudo iptables -t nat -A OUTPUT -d 63.218.225.68/32 -p tcp -m tcp --dport 443 -j DNAT --to-destination 10.122.130.131:443
sudo iptables -t nat -A PREROUTING -d 63.218.225.68/32 -p tcp -m tcp --dport 443 -j DNAT --to-destination 10.122.130.131:443
```

## 四、使用

如果需要不重启Docker，并且让 Docker 能拉取内部自授权的安全镜像仓库，可将证书`ca.crt`
放至 `/etc/docker/certs.d/你的镜像仓库地址/` 目录下（如：`/etc/docker/certs.d/63.218.225.68:8443`）。
