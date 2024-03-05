## SSH 免密登陆

```shell
ssh-keygen -t rsa
ssh-copy-id -p remote_port username@remote_host
```

## SSH跳板登陆及传输

```shell
ssh -J jump_host_username@jump_host:jump_host_port username@remote_host
scp -r -J jump_host_username@jump_host:jump_host_port local_directory username@remote_host:/dest_directory
```
