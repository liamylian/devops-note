#!/bin/bash
set -e

# 镜像下载：
#   https://www.microsoft.com/zh-cn/evalcenter/download-windows-server-2019
#   https://cloud-images.ubuntu.com/releases/22.04/release-20240808/ubuntu-22.04-server-cloudimg-amd64-disk-kvm.img
# 驱动下载：
#   https://developer.nvidia.com/cuda-12-2-0-download-archive?target_os=Windows#
# 参考：
#   https://gist.github.com/mikejoh/c0c9be0275a1b4867c15994b52a98237
#   https://medium.com/@art.vasilyev/use-ubuntu-cloud-image-with-kvm-1f28c19f82f8
#   https://cloud.tencent.com/developer/article/2168910

#-------------------------------
# 配置部分，可根据需要修改
#  virt-install --osinfo list
#-------------------------------

VM_ROOT=/data/kvm
VM_OS=windows
VM_OS_VARIANT=win10
VM_IMAGE=/data/iso/Win10_22H2_Chinese_Simplified_x64v1.iso

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
       -g {gpu devices} -c {vcpu num} -m {memory size in GB} \
       -s {system disk size in GB} -d {data disk size in GB} \
       -w {network} \
       -p {vnc port}
Eg
    ./vm_create_windows.sh -n vm-00 -g "01:00.0 01:00.1" -c 2 -m 1 -s 10 -d 20 -w bridge:virbr0 -p 5901

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
vm_vnc_port=
cpu_cores=
memory_size_gb=
disk_size_gb=
data_disk_size_gb=
gpu_devices=

while getopts n:w:u:p:c:m:s:d:g: flag
do
    case "${flag}" in
        n) vm_name=$OPTARG;;
        w) vm_network=$OPTARG;;
        p) vm_vnc_port=$OPTARG;;
        c) cpu_cores=$OPTARG;;
        m) memory_size_gb=$OPTARG;;
        s) disk_size_gb=$OPTARG;;
        d) data_disk_size_gb=$OPTARG;;
        g) gpu_devices=$OPTARG;;
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
check_num "${vm_vnc_port}" "bad vnc port"

echo "vm config:"
echo "  name:        ${vm_name}"
echo "  gpus:        ${gpu_devices}"
echo "  cpus:        ${cpu_cores}"
echo "  memory:      ${memory_size_gb} GB"
echo "  system disk: ${disk_size_gb} GB"
echo "  data disk:   ${data_disk_size_gb} GB"
echo "  network:     ${vm_network}"
echo "  vnc port:    ${vm_vnc_port}"
confirm

vm_path=${VM_ROOT}/${vm_name}
vm_disk_path=${vm_path}/system.qcow2
vm_data_disk_path=${vm_path}/data.qcow2
vm_data_disk=

vm_host_devices=
if [ -n "${gpu_devices}" ]; then
  for dev in ${gpu_devices}
  do
    vm_host_devices+=" --host-device ${dev} "
  done
fi

if [ $data_disk_size_gb -gt 0 ]; then
  vm_data_disk='--disk path="'${vm_data_disk_path}',size='${data_disk_size_gb}'"'
fi


#
# 2. 执行操作
#

sudo mkdir -p "$vm_path"

memory_size_mb=$(awk "BEGIN {print int($memory_size_gb * 1024)}")
sudo virt-install --connect qemu:///system \
  --virt-type kvm \
  --name "$vm_name" \
  ${vm_host_devices} \
  --memory "$memory_size_mb" \
  --vcpus "$cpu_cores" \
  --os-type $VM_OS \
  --os-variant $VM_OS_VARIANT \
  --cdrom $VM_IMAGE \
  --disk path="${vm_disk_path},size=${disk_size_gb}" \
  ${vm_data_disk} \
  --network "$vm_network" \
  --graphics "vnc,port=${vm_vnc_port},listen=0.0.0.0"
