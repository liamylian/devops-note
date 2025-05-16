# HTTPS 双向认证

## 一、生成证书

```shell
./openssl_gen.sh
```

## 二、配置 Nginx

例：

```
server {
  listen       8000 ssl;
  server_name  test1.example.com;

  ssl_certificate        /etc/nginx/certs/server-cert.pem;
  ssl_certificate_key    /etc/nginx/certs/server-key.pem;

  ssl_verify_client      on;
  ssl_client_certificate /etc/nginx/certs/ca-cert.pem;

  location / {
    root   html;
    index  index.html index.htm;
    proxy_pass  http://127.0.0.1:8001;
  }
}
```

## 三、验证结果

```shell
curl -k --cert ./client-cert.pem --key ./client-key.pem https://test1.example.com:8000
curl -k --cert ./client-cert.pem --key ./client-key.pem -k https://ip:8000
```