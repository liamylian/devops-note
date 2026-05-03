# Debian

## Source

sudo vi /etc/apt/sources.list.d/debian.sources

```
Types: deb deb-src
URIs: https://mirrors.tuna.tsinghua.edu.cn/debian
Suites: trixie trixie-updates trixie-backports
Components: main contrib non-free non-free-firmware

Types: deb deb-src
URIs: https://mirrors.tuna.tsinghua.edu.cn/debian-security
Suites: trixie-security
Components: main contrib non-free non-free-firmware
```

## UI

```
sudo apt install gnome-shell-extension-manager
sudo apt install lm-sensors
sudo apt install gir1.2-gnomedesktop-3.0 libgnome-menu-3-0 gir1.2-gmenu-3.0
```

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

## EasyConnect

[详见](https://blog.csdn.net/weixin_43912621/article/details/135628542)

```
wget http://kr.archive.ubuntu.com/ubuntu/pool/main/p/pango1.0/libpango-1.0-0_1.40.14-1_amd64.deb
wget http://kr.archive.ubuntu.com/ubuntu/pool/main/p/pango1.0/libpangocairo-1.0-0_1.40.14-1_amd64.deb
wget http://kr.archive.ubuntu.com/ubuntu/pool/main/p/pango1.0/libpangoft2-1.0-0_1.40.14-1_amd64.deb

dpkg-deb -x libpango-1.0-0_1.40.14-1_amd64.deb ./libpango-1.0-0_1.40.14-1_amd64
dpkg-deb -x libpangocairo-1.0-0_1.40.14-1_amd64.deb ./libpangocairo-1.0-0_1.40.14-1_amd64
dpkg-deb -x libpangoft2-1.0-0_1.40.14-1_amd64.deb ./libpangoft2-1.0-0_1.40.14-1_amd64

sudo cp -v libpango-1.0-0_1.40.14-1_amd64/usr/lib/x86_64-linux-gnu/* /usr/share/sangfor/EasyConnect/
sudo cp -v libpangocairo-1.0-0_1.40.14-1_amd64/usr/lib/x86_64-linux-gnu/* /usr/share/sangfor/EasyConnect/
sudo cp -v libpangoft2-1.0-0_1.40.14-1_amd64/usr/lib/x86_64-linux-gnu/* /usr/share/sangfor/EasyConnect/

sudo apt install iptables libgtk2.0-0 libdbus-glib-1-2
```

## Rime

```
# sudo apt install ibus-libpinyin

sudo apt purge fcitx5
sudo apt autoremove
sudo apt install ibus
sudo apt install ibus-rime
```

```yaml
# $HOME/.config/ibus/rime/default.custom.yaml
patch:
  switcher:
    hotkeys:
      - "F3"
```
