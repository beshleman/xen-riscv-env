#!/bin/bash

set -e
set -x

kernel=linux/arch/riscv/boot/Image.gz
kernel_size=$(cat ${kernel} | wc -c)
opensbi=opensbi/build/platform/generic/firmware/fw_jump.elf
xen=xen/xen/xen
dtb=dtbs/riscv64-guest.dtb

page_up() {
    local out
    local alignment=0x1000
    let mask=$((${alignment} - 1))
    let mask=$((~${mask}))
    let out=$(($1 + ${alignment} * 2))
    let out=$((${out} & ${mask}))
    printf "0x%02lx" ${out}
}

kernel_start=0x80400000
kernel_end=$((${kernel_start} + ${kernel_size}))
dtb_start=$(page_up ${kernel_end})
dtb_size=$(cat ${dtb} | wc -c)
dtb_end=$((${dtb_start} + ${dtb_size}))

printf "\nLaunching qemu-system-riscv64 with Boot Modules:\n"
printf "\tKernel: 0x%02x -> 0x%02x\n" ${DOM0_KERNEL} ${kernel_end}
printf "\tDTB:    0x%02x -> 0x%02x\n" ${dtb_start} ${dtb_end}

qemu-system-riscv64 \
	-cpu rv64,x-h=true \
	-M virt -m 1G -display none \
    -smp 1 \
	-serial stdio \
    -monitor telnet::45454,server,nowait  \
	-device loader,file=$(readlink -e ${kernel}),addr=${kernel_start} \
	-device loader,file=$(readlink -e ${dtb}),addr=${dtb_start} \
	-device loader,file=$(readlink -e ${xen}),addr=0x80200000 \
	-bios "$(readlink -e ${opensbi})" \
    -d in_asm -D qemu_log.txt -s -S # -machine dumpdtb=riscv64-qemu-virt.dtb
