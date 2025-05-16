#!/bin/bash

VM_NAME_RE='^vm-[0-9a-zA-Z]{24}$'

list_all=n

function print_help {
  echo "Usage: ./vm_ls.sh [-a]" >&2
  echo "Eg: ./vm_ls.sh" >&2
}
while getopts a flag
do
    case "${flag}" in
        a) list_all=y;;
        ?) print_help; exit 0;;
        *) print_help; exit 1;;
    esac
done


printf "\n\n\n"
echo "虚拟机显卡占用情况："
printf "\n"
vms=$(sudo virsh list --all | awk '{if(NR>1) print $2}')
for vm in $vms
do
  if [ $list_all == "n" ] && ! [[ $vm =~ $VM_NAME_RE ]]; then
    continue
  fi
  gpus=$(sudo virsh dumpxml "${vm}" | grep -A 4 '<hostdev' | grep '<address ' | awk -F'"' '{print $4":"$6":"$8"."$10}')
  if [ -n "$gpus" ]; then
    echo "${vm}: ${gpus}"
  fi
done

printf "\n\n\n"
echo "虚拟机IP占用情况："
printf "\n"
for vm in $vms
do
  if [ $list_all == "n" ] && ! [[ $vm =~ $VM_NAME_RE ]]; then
    continue
  fi
  mac=$(sudo virsh dumpxml "$vm" | grep "mac address" | awk -F"'" '{print $2}')
  ip=$(arp -n | grep "$mac" | awk '{print $1}')
  echo "${vm}: ${ip}"
done