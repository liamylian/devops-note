
## Server

[fhs-install-v2ray](https://github.com/v2fly/fhs-install-v2ray)


```json
{
    "inbounds": [
        {
            "port": 443, 
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "d0fa763d-0691-4eeb-aa2c-xxxxxxxxxxxx"
                    },
                    {
                        "id": "8dd3928f-d1fa-41b8-b2bb-xxxxxxxxxxxx"
                    },
                    {
                        "id": "709a974e-d50c-4007-966a-xxxxxxxxxxxx"
                    }
                ]
            },
	    "streamSettings": {
                "network": "ws",
                "security": "tls", 
                "tlsSettings": {
                    "certificates": [{
                        "certificateFile": "/usr/local/etc/v2ray/server.crt",
                        "keyFile": "/usr/local/etc/v2ray/private.key"
                    }]
                },
		"wsSettings": {
		    "path": "/vmwss",
		    "headers": {
			"Host":"us.example.com"
	            }
	        }
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}

```

## Client

[FIClash](https://github.com/chen08209/FlClash)


```
mixed-port: 7890
proxies:
  - name: 'USECS'
    type: vmess
    server: us.example.com 
    port: 443
    uuid: d0fa763d-0691-4eeb-aa2c-xxxxxxxxxxxx
    alterId: 0
    cipher: auto
    network: ws
    tls: true
    skip-cert-verify: true
    udp: false
    ws-opts:
      path: /vmwss

rules:
  - 'IP-CIDR,192.168.0.0/16,DIRECT,no-resolve'
  - 'IP-CIDR,10.1.0.0/16,DIRECT,no-resolve'
  - 'IP-CIDR,127.0.0.0/8,DIRECT,no-resolve'
  - 'DOMAIN-SUFFIX,inspii.com,DIRECT'
  - 'DOMAIN-SUFFIX,google.com,USECS'
  - 'DOMAIN-SUFFIX,wind.com.cn,DIRECT'
  - GEOIP,CN,DIRECT
  - MATCH,USECS

```
