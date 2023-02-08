Linux管理

## 用户及权限管理

- 添加用户：useradd [username] -g [group] -d [directory]
- 修改用户密码： passwd [username]

- 添加用户组：groupadd [groupname]
- 添加用户组用户：usermod -G [group] [username]
- 删除用户组用户：gpasswd -d [username] [groupname]
- 查看用户所属用户组： groups [username]

- 修改文件夹权限：chmod -R 777 [dir]
- 修改文件所有者：chown -R [username] [dir]
- 修改文件所有组：chgrp -R [groupname] [dir]

## 语言管理

- 当前配置：localectl status
- 可用区域语言：localectl list-locales |grep en
- 设置区域语言：localectl set-locale LANG=en_US.utf8
- 键盘配置：localectl list-keymaps
- 设置键盘：localectl set-keymap us
- 设置x11键盘：localectl set-x11-keymap us

### 虚拟摄像头

```bash
sudo apt-get install v4l2loopback-dkms
ls -l /dev/vidoe*
sudo modprobe v4l2loopback video_nr=5 card_label=“Virtual cam”

ffmpeg -re -stream_loop -1 -f lavfi -i "movie=benchmark.mp4" -f v4l2 /dev/video0
```
