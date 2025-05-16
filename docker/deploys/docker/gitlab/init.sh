#!/bin/bash

# https://docs.gitlab.com/ee/administration/auth/ldap/?tab=Docker
# https://blog.csdn.net/weixin_45565886/article/details/138153649
# https://blog.csdn.net/2401_84931473/article/details/138881060
# https://docs.gitlab.com/ee/administration/lfs/
# https://docs.gitlab.com/ee/administration/object_storage.html?tab=Docker#full-example-using-the-consolidated-form-and-amazon-s3
#
# https://gitlab.com/gitlab-org/gitlab-workhorse/-/issues/347
# https://github.com/go-gitea/gitea/issues/17311

NAME=infra-gitlab
WD=/data/docker-vms/infra/gitlab

HTTP_PORT=9006
SSH_PORT=9007
EXT_URL=http://localhost:10080

read -r -d '' OMNIBUS_CONFIG << EOF
external_url '${EXT_URL}'
nginx['listen_port'] = 80;
gitlab_rails['gitlab_shell_ssh_port'] = ${SSH_PORT}

# LFS 大文件超时
gitlab_rails['git_timeout'] = 600
gitlab_rails['git_max_request_duration'] = 600

# LFS
gitlab_rails['lfs_enabled'] = true
gitlab_rails['lfs_chunked_encoding'] = true # 使用 Ceph RadosGW 作为 LFS 后端可能需要禁用该选项
# gitlab_rails['lfs_storage_path'] = "/var/opt/gitlab/gitlab-rails/shared/lfs-objects"
EOF

gitlab_home="$WD/data"

sudo docker run -d --restart always \
  --name $NAME \
  --hostname $NAME \
  --shm-size 256m \
  -e GITLAB_OMNIBUS_CONFIG="${OMNIBUS_CONFIG}" \
  -p $HTTP_PORT:80 \
  -p $SSH_PORT:22 \
  -v $gitlab_home/config:/etc/gitlab \
  -v $gitlab_home/logs:/var/log/gitlab \
  -v $gitlab_home/data:/var/opt/gitlab \
  gitlab/gitlab-ce:17.6.2-ce.0

# 1. 获取初始密码
# docker exec -it $NAME cat /etc/gitlab/initial_root_password

# 2. 修改密码
# [User Settings] -> [Passsword]

# 3. 允许自行注册
# [Admin Area] -> [General] -> [Sign-up restrictions] -> [Require admin approval for new sign-ups] -> [Save]

# Migrate back to local storage (https://docs.gitlab.com/administration/lfs/#migrating-back-to-local-storage)
# 1. sudo docker exec -t <container name> gitlab-rake gitlab:lfs:migrate_to_local
# 2. gitlab_rails['object_store']['objects']['lfs']['enabled'] = false
# 3. sudo docker restart <container name>