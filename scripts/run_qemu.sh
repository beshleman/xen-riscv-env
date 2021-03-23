#!/bin/bash

set -e

SETUP_FILE=xen/xen/arch/riscv/setup.c

DOM0_KERNEL=bins/Image.gz
DOM0_KERNEL_SIZE=$(cat ${DOM0_KERNEL} | wc -c)
OPENSBI=opensbi/build/platform/qemu/virt/firmware/fw_payload.elf
XEN_OPENSBI_SZ=0x$(printf "%x" $(wc -c ${OPENSBI} | cut -d ' ' -f 1))
DOM0_KERNEL_LOAD_ADDR=$(cat ${SETUP_FILE} | grep DOM0_KERNEL\ 0x | cut -d ' ' -f 3)

echo "QEMU will place kernel @ addr: ${DOM0_KERNEL_LOAD_ADDR}"

#EXPECTED_SIZE=$(cat ${SETUP_FILE} | sed -ne 's/#define DOM0_KERNEL_SIZE \(.*\)/\1/p')
#[[ ! ${EXPECTED_SIZE} -eq ${DOM0_KERNEL_SIZE} ]] && {
##    echo "kernel size in ${SETUP_FILE} (${EXPECTED_SIZE}) != size of ${DOM0_KERNEL} (${DOM0_KERNEL_SIZE})" >&2
#    exit 1
#}

qemu-system-riscv64 \
	-cpu rv64,x-h=true \
	-M virt -m 1G -display none \
    -smp 1 \
	-serial stdio \
    -monitor telnet::45454,server,nowait  \
	-device loader,file=$(readlink -e ${DOM0_KERNEL}),addr=${DOM0_KERNEL_LOAD_ADDR} \
	-kernel "$(readlink -e ${OPENSBI})" -s -S # -machine dumpdtb=riscv64-qemu-virt.dtb
