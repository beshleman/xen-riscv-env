#!/bin/bash

set -e

SETUP_FILE=xen/xen/arch/riscv/setup.c

DOM0_KERNEL=linux/arch/riscv/boot/Image
OPENSBI=opensbi/build/platform/qemu/virt/firmware/fw_payload.elf

XEN_OPENSBI_SZ=0x$(printf "%x" $(wc -c ${OPENSBI} | cut -d ' ' -f 1))
DOM0_KERNEL_LOAD_ADDR=$(scripts/round_page.py ${XEN_OPENSBI_SZ})
XEN_EXPECTED_DOM0_LOAD_ADDR=$(cat -n ${SETUP_FILE} | grep DOM0_KERNEL\ 0x)

[[ ! "${XEN_EXPECTED_DOM0_LOAD_ADDR}" =~ "${DOM0_KERNEL_LOAD_ADDR}" ]] && {
	echo "The DOM0 kernel load address has changed!" >&2
	echo "It is ${DOM0_KERNEL_LOAD_ADDR}" >&2
	echo "Line in ${SETUP_FILE} containing Xen definition:" >&2
	echo "${XEN_EXPECTED_DOM0_LOAD_ADDR}" >&2
	echo "Please modify xen (riscv/setup.c) to reflect the change." >&2
	echo "It will break otherwise!" >&2
	exit 1
}

echo "QEMU will place kernel @ addr: ${DOM0_KERNEL_LOAD_ADDR}"

qemu-system-riscv64 \
	-cpu rv64,x-h=true \
	-M virt -m 512M -display none \
	-serial stdio \
	-device loader,file=$(readlink -e ${DOM0_KERNEL}),addr=${DOM0_KERNEL_LOAD_ADDR} \
	-kernel "$(readlink -e ${OPENSBI})" -s -S #-machine dumpdtb=riscv64-qemu-virt.dtb
