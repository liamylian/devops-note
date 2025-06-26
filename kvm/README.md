## 安装虚拟机软件

```shell
# 0. 检查虚拟化是否支持（大于零即可），若未开启，检查 BIOS 的 VT-d (Intel) 或 AMD IOMMU (AMD) 已正常设置.
egrep -c '(vmx|svm)' /proc/cpuinfo

# 1. 检查 KVM 虚拟化是否启用
sudo apt update
sudo apt install cpu-checker
kvm-ok

# 2. 安装 KVM
sudo apt install -y qemu-kvm libvirt-daemon-system virtinst libvirt-clients bridge-utils cloud-image-utils
sudo systemctl enable --now libvirtd

# 3. 可选，给当前用户管理 KVM 权限
sudo usermod -aG kvm $USER
sudo usermod -aG libvirt $USER
```