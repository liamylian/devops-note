# Git命令

## 打标签

```cmd
  git tag -l v1.*
  git tag -a v1.0.1 -m "Version 1.0.1"
  git push origin --tags
```

## 删除本地及远程标签

```
git tag -d <tagname> # 删除本地分支
git push --delete origin <tagname> # 方法一，如果有同名分支会失败
git push origin :refs/tags/<tagname> # 方法二
```

## 删除本地及远程所有标签

```
git tag -d $(git tag -l) # 删除本地所有标签
git fetch # 重新拉取远程标签
git push origin --delete $(git tag -l)
git tag -d $(git tag -l)
```


## Windows使用Linux子系统

Windows拉取仓库后，Linux子系统内会遇到^M字符，需要将Windows的`autocrlf`去除。

```bash
  git config --global core.autocrlf false
```
