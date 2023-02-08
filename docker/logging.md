# 日志配置

方式一：配置`/etc/docker/daemon.json`文件，限制日志文件大小。

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3",
    "labels": "production_status",
    "env": "os,customer"
  }
}
```

方式二：单容器配置：

```yaml
    logging:
      driver: "json-file"
      options:
        max-size: "500m"
```
