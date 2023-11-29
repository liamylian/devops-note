## 镜像加速

创建或编辑 `~/.cargo/config` 文件：

```
[source.crates-io]
registry ="https://github.com/rust-lang/crates.io-index"
replace-with = 'ustc'

[source.ustc]
registry = "http://mirrors.ustc.edu.cn/crates.io-index"
```
