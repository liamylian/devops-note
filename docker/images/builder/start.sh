#!/bin/bash

# 脚本参数说明：
#
#   INSECURE_REGISTRIES         ...     可选，不安全的镜像仓库地址，多个地址用逗号分隔
#   REGISTRIES                  ...     镜像仓库地址，多个地址用逗号分隔
#   GIT_URL                     ...     git 仓库地址，格式：https://username:password@gitlab.com/group/repo.git
#   GIT_COMMIT(Optional)        ...     可选，git 提交版本
#   BUILD_IMAGE                 ...     构建镜像
#
#   BUILD_DIR(Optional)         ...     可选，构建工作目录
#   BUILD_DOCKERFILE(Optional)  ...     可选，构建 Dockerfile

# 禁止颜色输出，会影响日志
export NO_COLOR=1
export TERM=dumb

if [ -z "$BUILD_DIR" ]; then
  BUILD_DIR=/build
fi
if [ -z "$BUILD_DOCKERFILE" ]; then
  BUILD_DOCKERFILE=Dockerfile
fi

/config.sh

echo "--------------------"
echo "Cloning..."
echo "--------------------"
if ! GIT_LFS_SKIP_SMUDGE=1 LANG=en_US.UTF-8 git clone --progress "$GIT_URL" "$BUILD_DIR"; then
  echo "clone failed"
  exit 1
fi
if [ -n "$GIT_COMMIT" ]; then
  if ! cd "$BUILD_DIR" && git checkout "$GIT_COMMIT"; then
    echo "checkout failed"
    exit 2
  fi
fi
if ! cd "$BUILD_DIR" && GIT_LFS_FORCE_PROGRESS=1 git lfs pull; then
  echo "lfs pull failed"
  exit 3
fi

echo "--------------------"
echo "Preparing..."
echo "--------------------"
if ! cd "$BUILD_DIR" ; then
  echo "enter build dir failed"
  exit 4
fi

echo "--------------------"
echo "Building..."
echo "--------------------"
if ! buildah build -t "$BUILD_IMAGE" -f "$BUILD_DOKCERFILE" . ; then
    echo "build image failed"
    exit 6
fi

echo "--------------------"
echo "Pushing..."
echo "--------------------"
if ! buildah push "$BUILD_IMAGE" ; then
    echo "push image failed"
    exit 7
fi

echo "success"