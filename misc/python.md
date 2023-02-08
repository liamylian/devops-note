## Pip加速

1. 查看配置文件目录

```
pip -v config list
```

2. 修改配置文件
```
[global]
index-url=http://mirrors.aliyun.com/pypi/simple/
[install]
trusted-host=mirrors.aliyun.com
```
