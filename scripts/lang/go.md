## Goland 远程调试失败

https://blog.csdn.net/lady_killer9/article/details/116396555

```
alias goproxy="
    export GOPROXY=https://goproxy.cn,direct;
    export GOSUMDB=sum.golang.google.cn;
    export GOPRIVATE=git.inspii.com;
    export GONOSUMDB=git.inspii.com;"

alias ngoproxy="
    unset GOPROXY;
    unset GOSUMDB;
    unset GOPRIVATE;
    unset GONOSUMDB;"
```
