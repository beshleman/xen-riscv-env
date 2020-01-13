#!/bin/bash

set -e

CROSS_COMPILE=riscv64-linux-gnu- 

pushd xen/xen
XEN_TARGET_ARCH=riscv64 CROSS_COMPILE=$CROSS_COMPILE make build -j$(nproc)
popd

FLAGS=" -machine virt -cpu rv64,x-h=true -M virt -m 512M -display none -serial stdio -monitor telnet::45454,server,nowait"

FLAGS="-s -S ${FLAGS}"
qemu-system-riscv64 ${FLAGS} -kernel opensbi/build/platform/qemu/virt/firmware/fw_jump.elf -device loader,file=xen/xen/xen,addr=0x80200000

		
