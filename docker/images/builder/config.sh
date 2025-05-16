#!/bin/bash

INSECURE_REGISTRIES=${INSECURE_REGISTRIES:-""}
REGISTRIES=${REGISTRIES:-""}

#
# 1. 配置不完全的镜像仓库
#

CONFIG_FILE="/etc/containers/registries.conf"

if [ -n "$INSECURE_REGISTRIES" ]; then
  echo "--------------------"
  echo "Config Insecure Registries..."
  echo "--------------------"

  mkdir -p "$(dirname "$CONFIG_FILE")"
  cat <<EOF > "$CONFIG_FILE"
  # 自动生成的不安全镜像仓库配置
  # 以下仓库被标记为不安全（insecure）

EOF

  IFS=',' read -ra registries <<< "$INSECURE_REGISTRIES"
  for registry in "${registries[@]}"; do
    cat <<EOF >> "$CONFIG_FILE"
  [[registry]]
  location = "$registry"
  insecure = true

EOF
  done
fi

#
# 2. 登录镜像仓库
#

echo "--------------------"
echo "Login Registries..."
echo "--------------------"

IFS=',' read -ra registries <<< "$REGISTRIES"
for registry in "${registries[@]}"; do
  user_pass=$(echo $registry | sed 's/@[^@]*$//')
  registry_url=$(echo $registry | sed 's/.*@//')

  registry_user=$(echo $user_pass | sed 's/:.*$//')
  registry_pass=$(echo $user_pass | sed 's/[^:]*://')
  echo "Logging into $registry_url with user $registry_user"
  buildah login -u "$registry_user" -p "$registry_pass" "$registry_url"
done