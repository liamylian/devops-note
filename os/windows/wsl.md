# WSL2.0

## 限制内存

1. 在用户目录创建 `.wslconfig`文件：

```
[wsl2]
memory=2GB
swap=0
localhostForwarding=true
```

2. 重启WSL

```
wsl --shutdown
```
