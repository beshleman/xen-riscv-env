#!/bin/bash

set -x

ENTRY=0x80000000
DOM0_KERNEL=linux/arch/riscv/boot/Image
OPENSBI=opensbi/build/platform/qemu/virt/firmware/fw_payload.elf

XEN_OPENSBI_SZ=0x$(printf "%x" $(wc -c ${OPENSBI} | cut -d ' ' -f 1))
DOM0_KERNEL_LOAD_ADDR=$(scripts/round_page.py ${XEN_OPENSBI_SZ})

echo "QEMU will place kernel @ addr: ${DOM0_KERNEL_LOAD_ADDR}"

qemu-system-riscv64 \
	-s -S -cpu rv64,x-h=true \
	-M virt -m 512M -display none \
	-serial stdio \
	-device loader,file=$(readlink -e ${DOM0_KERNEL}),addr=${DOM0_KERNEL_LOAD_ADDR} \
	-kernel "$(readlink -e ${OPENSBI})"
