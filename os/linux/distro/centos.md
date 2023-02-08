# Cent OS

## 静态IP配置

```shell
cd /etc/sysconfig/network-scripts/

vi ifcfg-ens3
# 修改 BOOTPROTO=static
#     ONBOOT=yes
# 添加 IPADDR=192.168.0.40
#     GATEWAY=192.168.0.1
#     NETMASK=255.255.255.0
#     DNS1=114.114.114.114

systemctl restart network
```

## U盘无法安装CENT OS系统

镜像下载地址： https://www.centos.org/centos-linux/

问题解决方法见：https://zhuanlan.zhihu.com/p/428355575