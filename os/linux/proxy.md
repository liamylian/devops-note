#代理

## 系统代理

```shell
export PROXY_SERVER=socks5h://xxx.xxx.xxx.xxx:xxxx
alias proxy="
    export http_proxy=$PROXY_SERVER;
    export https_proxy=$PROXY_SERVER;
    export socks5_proxy=$PROXY_SERVER;
    export all_proxy=$PROXY_SERVER;
    export no_proxy=localhost,127.0.0.0/8,::1;
    export HTTP_PROXY=$PROXY_SERVER;
    export HTTPS_PROXY=$PROXY_SERVER;
    export SOCKS5_PROXY=$PROXY_SERVER;
    export ALL_PROXY=$PROXY_SERVER;
    export NO_PROXY=localhost,127.0.0.0/8,::1;"
alias unproxy="
    unset http_proxy;
    unset https_proxy;
    unset socks5_proxy;
    unset all_proxy;
    unset no_proxy;
    unset HTTP_PROXY;
    unset HTTPS_PROXY;
    unset SOCKS5_PROXY;
    unset ALL_PROXY;
    unset NO_PROXY;"
```

## snap代理

```shell
sudo snap set system proxy.http="socks5://xxx.xxx.xxx.xxx:xxxx"
sudo snap set system proxy.https="socks5://xxx.xxx.xxx.xxx:xxxx"
```

## proxychians代理

```shell
git clone github.com/rofl0r/proxychains-ng
cd proxychains-ng
./configure --prefix=/usr --sysconfdir=/etc
make
sudo make install
sudo make install-config
cat <<EOF >> /etc/proxychains.conf
socks5 xxx.xxx.xxx.xxx xxxx
EOF
```
