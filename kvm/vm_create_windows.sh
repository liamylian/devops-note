#!/bin/bash
set -e

#-------------------------------
# 配置部分，可根据需要修改
#  virt-install --osinfo list
#-------------------------------

VM_ROOT=/data/vms
VM_OS=windows
VM_OS_VARIANT=win10
VM_IMAGE=/data/vms/isos/Win10_gold.qcow2

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
    ${0} \
       -n {name} \
       -c {vcpu num} -m {memory size in GB} \
       -s {system disk size in GB} -d {data disk size in GB} \
       -w {network}
Eg
    ${0} -n win10-00 -c 4 -m 4 -s 100 -p 123456 -P 5900
    ${0} -n win10-00 -c 4 -m 4 -s 100 -d 100 -w bridge:virbr0 -p 123456 -P 5900

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
cpu_cores=
memory_size_gb=
disk_size_gb=
data_disk_size_gb=0
vnc_port=5900
vnc_pass=

while getopts n:w:c:m:s:d:p:P:h flag
do
    case "${flag}" in
        n) vm_name=$OPTARG;;
        w) vm_network=$OPTARG;;
        c) cpu_cores=$OPTARG;;
        m) memory_size_gb=$OPTARG;;
        s) disk_size_gb=$OPTARG;;
        d) data_disk_size_gb=$OPTARG;;
        p) vnc_pass=$OPTARG;;
        P) vnc_port=$OPTARG;;
        h) usage;;
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
check_num "${vnc_port}" "bad vnc port"

echo "vm config:"
echo "  name:        ${vm_name}"
echo "  cpus:        ${cpu_cores}"
echo "  memory:      ${memory_size_gb} GB"
echo "  system disk: ${disk_size_gb} GB"
echo "  data disk:   ${data_disk_size_gb} GB"
echo "  network:     ${vm_network}"
confirm

vm_path=${VM_ROOT}/${vm_name}
vm_disk_path=${vm_path}/system.qcow2
vm_data_disk_path=${vm_path}/data.qcow2
vm_data_disk=

if [ $data_disk_size_gb -gt 0 ]; then
  vm_data_disk='--disk path="'${vm_data_disk_path}',size='${data_disk_size_gb}'"'
fi


#
# 2. 执行操作
#

sudo mkdir -p "$vm_path"
sudo cp $VM_IMAGE $vm_disk_path
current_size=$(qemu-img info $vm_disk_path | grep "virtual size" | awk '{print $3}')
if [[ $(echo "$disk_size_gb > ${current_size%G}" | bc) -eq 1 ]]; then
  sudo qemu-img resize $vm_disk_path ${disk_size_gb} # 仍需在虚拟机中扩容
else
    yellow "跳过修改磁盘大小"
fi

memory_size_mb=$(awk "BEGIN {print int($memory_size_gb * 1024)}")
sudo virt-install --connect qemu:///system \
  --virt-type kvm \
  --name "$vm_name" \
  --memory "$memory_size_mb" \
  --vcpus "$cpu_cores" \
  --os-type $VM_OS \
  --os-variant $VM_OS_VARIANT \
  --disk path="${vm_disk_path}" --import \
  ${vm_data_disk} \
  --network "$vm_network" \
  --graphics "vnc,port=${vnc_port},listen=0.0.0.0,password=${vnc_pass}"
