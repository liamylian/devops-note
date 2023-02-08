# Homebrew

## Install

```
# 安装
wget https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
# 手动更改 BREW_REPO="https://mirrors.ustc.edu.cn/brew.git"

# 国内镜像加速
git -C "$(brew --repo)" remote set-url origin https://mirrors.ustc.edu.cn/brew.git
git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git
git -C "$(brew --repo homebrew/cask)" remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git
brew update

# 长期替换homebrew-bottles
echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles' >> ~/.zshrc
source ~/.zshrc
```
