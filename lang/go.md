# Go

## 一、Go 镜像加速

```shell
alias goproxy="
    export GOPROXY=https://goproxy.cn,direct;
    export GOSUMDB=sum.golang.google.cn;
    export GOPRIVATE=git.example.com;
    export GONOSUMDB=git.example.com;"

alias ngoproxy="
    unset GOPROXY;
    unset GOSUMDB;
    unset GOPRIVATE;
    unset GONOSUMDB;"
```

## 二、Goland 远程调试失败

https://blog.csdn.net/lady_killer9/article/details/116396555
