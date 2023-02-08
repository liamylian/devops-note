# Ubuntu

## 磁盘扩容一倍

```shell
vgdisplay
lvextend -l +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv
resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
```

## 加速源


```shell
sed -i s/archive.ubuntu.com/cn.archive.ubuntu.com/g /etc/apt/sources.list
sed -i s/security.ubuntu.com/cn.archive.ubuntu.com/g /etc/apt/sources.list
# sed -i s/archive.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list
# sed -i s/security.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list
apt-get clean
apt-get update
```

## 固定IP

1. 添加文件`etc/netplan/99_config.yaml`:

```
network:
  version: 2
  renderer: networkd
  ethernets:
    enp3s0:
      addresses:
        - 192.168.5.83/24
      gateway4: 192.168.5.1
      nameservers:
        addresses: [114.114.114.114, 8.8.8.8]
      dhcp4: no
```

2. 执行`netplan apply`
