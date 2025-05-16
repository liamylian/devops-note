#!/bin/bash

#
# 编译说明（注意：官方教程并没有带 --enable-nvenc 选项，需自行添加）：
#   https://docs.nvidia.com/video-technologies/video-codec-sdk/12.0/ffmpeg-with-nvidia-gpu/index.html
#
# Nvidia Video Codec SDK 下载地址：
#   https://developer.nvidia.com/video-codec-sdk-archive
#

# 检查动态依赖库是否添加了 /usr/local/lib，后面 nv-codec-header 会安装至此目录
cat /etc/ld.so.conf

# 安装 nv-codec-header
git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
git tag -l
git checkout n12.0.16.1 # git checkout -b new-branch n12.0.16.1
cd nv-codec-headers && sudo make install && cd ..
# 检查 ffnvcodec，一定要安装 pkg-config，不然 ffmepg 找不到 ffnvcodec
pkg-config --modversion ffnvcodec

# 容器中可能会缺少 libnvcuvid.so 等动态库
# 可将宿主机上的 libnv*.so(一般在 /usr/lib/x86_64-linux-gnu 目录下)拷贝至容器中（也在 /usr/lib/x86_64-linux-gnu）。
# 或者在 docker run 时指定 -e NVIDIA_DRIVER_CAPABILITIES=all，但该方法目前测试对 FFMpeg 还存在问题。
# cp /usr/lib/x86_64-linux-gnu/libnv* [目标路径]

# 安装 FFMpeg
sudo apt-get install build-essential yasm cmake libtool libc6 libc6-dev unzip wget libnuma1 libnuma-dev
git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg/
cd ffmpeg
# 注意 --enable-nvenc 选项
./configure --enable-nonfree --enable-cuda-nvcc --enable-libnpp --enable-nvenc --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 --disable-static --enable-shared
make -j 8
sudo make install

# 检查安装成功
cd /usr/local/bin
./ffmpeg -h encoder=h264_nvenc

# 测试
./ffmpeg -hwaccel cuda  -i test.mp4 -q:v 2 -vf fps=1 out%d.png
./ffmpeg -y -vsync 0 -hwaccel cuda -hwaccel_output_format cuda -i input.mp4 -c:a copy -c:v h264_nvenc -b:v 5M output.mp4