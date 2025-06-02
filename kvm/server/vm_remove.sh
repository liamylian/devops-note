#!/bin/bash

#-------------------------------
# 配置部分，可根据需要修改
#-------------------------------

SCRIPT_DIR=/data/kvm
VM_NAME_RE='^vm-[0-9a-zA-Z]{24}$'

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
function print_help {
  echo "Usage: ./vm_remove.sh -n {name}" >&2
  echo "Eg: ./vm_remove.sh -n vm-00" >&2
}

#-------------------------------
# Main
#-------------------------------

#
# 1. 参数解析
#

force=n
while getopts v:n:f flag
do
    case "${flag}" in
        n) vm_name=$OPTARG;;
        f) force=y;;
        ?) print_help; exit 0;;
        *) print_help; exit 1;;
    esac
done

vm_wd="${SCRIPT_DIR}/${vm_name}"

if [ -z "$vm_name" ]; then
  print_help; exit 0;
fi
if [ $force = "n" ] && ! [[ $vm_name =~ $VM_NAME_RE ]]; then
  echo "虚机名称不合法，请使用 -f 选项强制删除"
  exit 0
fi

echo "待删除的虚机:"
echo "  名称: ${vm_name}"
confirm

#
# 2. 执行操作
#

sudo virsh shutdown "${vm_name}"
sudo virsh undefine "${vm_name}"

#
# 3. 输出结果
#

printf "\n\n"
green "虚拟机已删除"
printf "\n"
yellow "请手动删除用户数据卷:"
echo "  sudo rm -ri ${vm_wd}"