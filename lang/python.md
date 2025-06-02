# Python

## 一、Pip 镜像加速

| 镜像源 | 地址                                       | 
|-----|------------------------------------------|
| 豆瓣  | https://pypi.douban.com/simple/          | 
| 清华  | https://pypi.tuna.tsinghua.edu.cn/simple | 
| 阿里云 | https://mirrors.aliyun.com/pypi/simple/  | 

1. 查看配置文件目录

```
pip -v config list
```

2. 修改配置文件

```
[global]
index-url=https://mirrors.aliyun.com/pypi/simple/
[install]
trusted-host=mirrors.aliyun.com
```

或使用如下命令：

```
pip config set global.index-url http://mirrors.aliyun.com/pypi/simple/
```
