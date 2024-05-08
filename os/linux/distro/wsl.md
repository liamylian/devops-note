## WSL 磁盘占用过大

```
wsl --shutdown
optimize-vhd -Path .\ext4.vhdx -Mode full
```

如果没有 `optimize-vhd`，使用如下命令：

```
wsl --shutdown
diskpart
# open window Diskpart
select vdisk file=".\ext4.vhdx"
attach vdisk readonly
compact vdisk
detach vdisk
exit
```

其中 `./ext4.vhdx` 需使用绝对路径，如 `C:\Users\liamylian\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu22.04LTS_79rhkp1fndgsc\LocalState\ext4.vhdx`
