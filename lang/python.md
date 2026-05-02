# Python

## Conda

```shell
vi ~/.condarc
conda clean -i
conda config --get channels
```

```
channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
show_channel_urls: true

auto_activate: false
```

> 可能没有效果，请在具体的环境中，使用 Pip 方式进行设置。

## Pip 镜像加速

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
