#!/bin/bash
set -e
#
# H800 GPU 默认带有 NV-SWITCH，但对于没有挂载 NV-SWITCH 的虚拟机，需要禁用 NV-LINK，才能避免 CUDA 不可用。
# 禁用 NV-LINK，可使用 nvlink.disable=1, 或 NVreg_NvLinkDisable=1 参数。
# 启用用 NV-LINK，也需要将相应的 NV-SWITCH，以及组中的其他设备进行挂载。目前对于 8 卡 H800，只能创建一个带NV-SWITCH 的虚拟机（4个 NV-SWITCH 需一起挂载，导致其他虚机不能挂载）。
#
# 虚拟机中可能需要进行配置，若不配置，有些型号的 GPU （支持 NVLINK 的型号）可能无法使用 CUDA。
#
#   Linux 手动在虚拟机中执行如下命令：
#     echo "options nvidia NVreg_NvLinkDisable=1" | sudo tee /etc/modprobe.d/nvidia.conf
#     sudo update-initramfs -u
#     sudo reboot
#
#   Windows 修改注册表：
#     1. 按下 Win + R， 输入 regedit 并回车
#     2. 导航至 HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\nvlddmkm
#     3. 在右侧窗口空白处右键单击，选择 新建 > DWORD (32 位) 值，并命名为 NVLinkDisable，设置值为 1（表示禁用）
#     4. 保存并退出注册表，重启计算机使其生效
#
#   确认 CUDA 已正常运行：
#     python3 -c "import torch; print(torch.cuda.is_available())"
#
# 排查 GPU 问题：
#   modinfo nvidia
#   sudo lsmod | grep nvidia
#
# 镜像下载：
#   https://cloud-images.ubuntu.com/releases/22.04/release-20240808/ubuntu-22.04-server-cloudimg-amd64-disk-kvm.img
#   https://www.microsoft.com/zh-cn/evalcenter/download-windows-server-2019
#
# 参考：
#
#   https://docs.digitalocean.com/products/paperspace/machines/how-to/disable-nvlink/
#   https://forums.developer.nvidia.com/t/need-example-to-disable-nvlink/70818
#   https://docs.nvidia.com/vgpu/15.0/grid-vgpu-user-guide/index.html#using-gpu-pass-through
#   https://www.linuxtechi.com/create-manage-kvm-virtual-machine-cli/
#   https://github.com/virt-manager/virt-manager/blob/main/man/virt-install.rst#installation-options
#   https://help.ubuntu.com/community/SerialConsoleHowto
#   https://gist.github.com/mikejoh/c0c9be0275a1b4867c15994b52a98237
#   https://medium.com/@art.vasilyev/use-ubuntu-cloud-image-with-kvm-1f28c19f82f8
#   https://cloud.tencent.com/developer/article/2168910
#   https://www.ibm.com/docs/en/linux-on-systems?topic=choices-using-macvtap-driver

#-------------------------------
# 配置部分，可根据需要修改
#-------------------------------

VM_ROOT=/data/kvm
VM_OS=ubuntu22.04
VM_IMAGE=/data/iso/ubuntu-22.04-server-cloudimg-amd64-disk-kvm.img

#-------------------------------
# 工具函数
#-------------------------------

bold() { echo -e "\e[1m$@\e[0m" ; }
red() { echo -e "\e[31m$@\e[0m" ; }
green() { echo -e "\e[32m$@\e[0m" ; }
yellow() { echo -e "\e[33m$@\e[0m" ; }
confirm() {
  read -p "${1:-继续}? (y/n): " yn
  case ${yn,,} in
    y|yes ) ;;
    n|no ) echo "操作已取消"; exit 0;;
    *) echo "输入错误，退出"; exit 1;;
  esac
}
function check_nonempty () {
  if [ -z "$1" ]; then
    echo "${2:-参数不能为空}" >&2
    exit 1
  fi
}
function check_num () {
  if ! [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "${2:-无效的数字}" >&2
    exit 1
  fi
}
function check_float () {
  if ! [[ "$1" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    echo "${2:-无效的数字}" >&2
    exit 1
  fi
}
check_last_command() {
  if [ $? -ne 0 ]; then
    red "命令执行失败，退出..."
    exit 1
  fi
}
function usage () {
  cat << EOF
Usage
    ./vm_create.sh \
       -n {name} \
       -u {user} -p {password} \
       -g {gpu devices} -c {vcpu num} -m {memory size in GB} \
       -s {system disk size in GB} -d {data disk size in GB} \
       -w {network} -i {ip} \
       -o {extra commands}
Eg
    ./vm_create.sh -n vm-00 -p 123456 -g "01:00.0 01:00.1" -c 2 -m 1 -s 10 -d 20 -w bridge:virbr0 -i 192.168.122.100/24
    ./vm_create.sh -n vm-00 -p 123456 -g "01:00.0 01:00.1" -c 2 -m 1 -s 10 -d 20 -w 'type=direct,source=eth0,source_mode=bridge,model=virtio' -i 192.168.122.100/24

EOF
  exit 0
}


#-----------------------------------
# Main
#-----------------------------------

#
# 1. 参数解析
#

vm_name=
vm_network=bridge:virbr0
vm_user=ubuntu
vm_password=
vm_ip=
cpu_cores=
memory_size_gb=
disk_size_gb=
data_disk_size_gb=0
gpu_devices=
extra_commands=

while getopts n:w:u:p:i:c:m:s:d:g:o: flag
do
    case "${flag}" in
        n) vm_name=$OPTARG;;
        w) vm_network=$OPTARG;;
        u) vm_user=$OPTARG;;
        p) vm_password=$OPTARG;;
        i) vm_ip=$OPTARG;;
        c) cpu_cores=$OPTARG;;
        m) memory_size_gb=$OPTARG;;
        s) disk_size_gb=$OPTARG;;
        d) data_disk_size_gb=$OPTARG;;
        g) gpu_devices=$OPTARG;;
        o) extra_commands=$OPTARG;;
        ?) usage;;
        *) usage;;
    esac
done

check_nonempty "${vm_name}" "empty vm name"
check_num "${cpu_cores}" "bad cpu cores"
check_float "${memory_size_gb}" "bad memory size"
check_num "${disk_size_gb}" "bad disk size"
check_num "${data_disk_size_gb}" "bad data disk size"
check_nonempty "${vm_network}" "empty vm network"
check_nonempty "${vm_ip}" "empty ip"
check_nonempty "${vm_user}" "empty vm user"
check_nonempty "${vm_password}" "empty password"

echo "vm config:"
echo "  name:           ${vm_name}"
echo "  gpus:           ${gpu_devices}"
echo "  cpus:           ${cpu_cores}"
echo "  memory:         ${memory_size_gb} GB"
echo "  system disk:    ${disk_size_gb} GB"
echo "  data disk:      ${data_disk_size_gb} GB"
echo "  network:        ${vm_network}"
echo "  ip:             ${vm_ip}"
echo "  user:           ${vm_user}"
echo "  password:       ${vm_password}"
echo "  extra commands: ${extra_commands}"
confirm

vm_path=${VM_ROOT}/${vm_name}
vm_disk_path=${vm_path}/system.qcow2
vm_data_disk_path=${vm_path}/data.qcow2
vm_seed_path=${vm_path}/seed.iso

vm_host_devices=
if [ -n "${gpu_devices}" ]; then
  for dev in ${gpu_devices}
  do
    vm_host_devices+=" --host-device ${dev} "
  done
fi

#
# 2. 执行操作
#

sudo mkdir -p "$vm_path"

if [ -e "$vm_disk_path" ]; then
  yellow "系统盘已存在，退出..."
  exit 0
fi
if [ -e "$vm_data_disk_path" ]; then
  yellow "数据盘已存在，退出..."
  exit 0
fi

yellow "创建系统盘..."
sudo qemu-img create -f qcow2 -F qcow2 -b $VM_IMAGE "$vm_disk_path" "${disk_size_gb}G"
check_last_command

vm_data_disk_device=
if [ "$data_disk_size_gb" -gt 0 ]; then
  yellow "创建数据盘..."
  sudo qemu-img create -f qcow2 "$vm_data_disk_path" "${data_disk_size_gb}G"
  check_last_command
  vm_data_disk_device="--disk ${vm_data_disk_path}"
fi

vm_meta_conf_path=meta-data
vm_user_conf_path=user-data
vm_net_conf_path=network-config

sudo touch $vm_meta_conf_path
sudo tee $vm_user_conf_path > /dev/null <<EOF
#cloud-config

hostname: $vm_name
resize_rootfs: true
ssh_pwauth: true

system_info:
  default_user:
    name: ${vm_user}

chpasswd:
  list: |
    ${vm_user}:${vm_password}
  expire: false
EOF
sudo tee $vm_net_conf_path > /dev/null <<EOF
network:
  version: 2
  ethernets:
    enp1s0:
      dhcp4: false
      addresses:
        - ${vm_ip}
      nameservers:
        addresses:
          - 114.114.114.114
          - 8.8.8.8
EOF

sudo genisoimage -output "$vm_seed_path" -volid cidata -joliet -rock $vm_meta_conf_path $vm_user_conf_path $vm_net_conf_path
check_last_command
sudo rm $vm_user_conf_path $vm_meta_conf_path $vm_net_conf_path

memory_size_mb=$(awk "BEGIN {print int($memory_size_gb * 1024)}")
sudo virt-install --connect qemu:///system \
  --virt-type kvm \
  --import \
  --name "$vm_name" \
  ${vm_host_devices} \
  --memory "$memory_size_mb" \
  --vcpus "$cpu_cores" \
  --os-type linux \
  --os-variant $VM_OS \
  --network "$vm_network" \
  --disk "$vm_disk_path" \
  ${vm_data_disk_device} \
  ${extra_commands} \
  --disk "$vm_seed_path" \
  --graphics none \
  --console pty,target_type=serial
  # --chardev "socket,id=ga0,path=/var/run/kvm_guest_${vm_name}.sock,server,nowait" \
  # --device virtio-serial-pci \
  # --device virtserialport,chardev=ga0,name=org.guest-agent.0 \
