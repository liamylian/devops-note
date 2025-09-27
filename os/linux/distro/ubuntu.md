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

```yaml
network:
  ethernets:
    enp1s0:
      dhcp4: no
      addresses:
        - 192.168.31.80/24
      routes:
        - to: default
          via: 192.168.31.1
      nameservers:
        addresses:
          - 114.114.114.114
          - 8.8.8.8
    enp2s0:
      dhcp4: true
      optional: true
  version: 2
```

2. 执行`netplan apply`

## 向日葵

```
ubuntu24.04不能安装向日葵​​解决方法​​:
​​1. 安装依赖库 libgconf-2-4​​
在 Ubuntu 24.04 中，libgconf-2-4 可能不在默认软件源中，需要手动下载安装：
# 下载依赖包
wget http://kr.archive.ubuntu.com/ubuntu/pool/universe/g/gconf/libgconf-2-4_3.2.6-6ubuntu1_amd64.deb
wget http://kr.archive.ubuntu.com/ubuntu/pool/universe/g/gconf/gconf2-common_3.2.6-6ubuntu1_all.deb
# 安装依赖
sudo dpkg -i gconf2-common_3.2.6-6ubuntu1_all.deb
sudo dpkg -i libgconf-2-4_3.2.6-6ubuntu1_amd64.deb
​​2. 修复依赖关系​​
如果安装过程中仍有问题，运行以下命令修复：
sudo apt --fix-broken install 
```
