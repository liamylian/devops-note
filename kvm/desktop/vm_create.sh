#!/bin/bash
set -e
#
# 镜像下载：
#   https://cloud-images.ubuntu.com/releases/22.04/release-20240808/ubuntu-22.04-server-cloudimg-amd64-disk-kvm.img
#   https://www.microsoft.com/zh-cn/evalcenter/download-windows-server-2019
#

#-------------------------------
# 配置部分，可根据需要修改
#-------------------------------

VM_ROOT=/home/liam/VMs
VM_OS=ubuntu22.04
VM_IMAGE=/home/liam/VMs/isos/ubuntu-22.04-server-cloudimg-amd64-disk-kvm.img

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
       -s {system disk size in GB} -d {data disk size in GB} \
       -w {network} -i {ip} \
       -x {extra commands}
Eg
    ./vm_create.sh -n vm-00 -p 123456 -c 2 -m 1 -s 10 -d 20 -w bridge:virbr0 -i 192.168.122.100/24
    ./vm_create.sh -n vm-00 -p 123456 -c 2 -m 1 -s 10 -d 20 -w 'type=direct,source=eth0,source_mode=bridge,model=virtio' -i 192.168.122.100/24

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

while getopts n:w:u:p:i:c:m:s:d:g:x: flag
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
        x) extra_commands=$OPTARG;;
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
