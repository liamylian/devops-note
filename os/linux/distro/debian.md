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

# dash-to-dock, transparent-top-bar, freon, screen-rotate
sudo apt install gnome-shell-extension-appindicator
```
