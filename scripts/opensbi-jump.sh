#!/bin/bash

set -e

if [[ "x$1" == "xbuild" ]]; then
    pushd xen/xen
    XEN_TARGET_ARCH=riscv64 CROSS_COMPILE=riscv64-unknown-linux-gnu- make build -j8
    popd
fi

echo "+++++++++++++++++++++++++"
echo "Succesful build, spinning up QEMU...."
echo "+++++++++++++++++++++++++"

qemu-system-riscv64 -s -S -machine virt -cpu rv64,x-h=true -M virt -m 512M -display none -serial stdio -kernel opensbi/build/platform/qemu/virt/firmware/fw_jump.elf -device loader,file=xen/xen/xen,addr=0x80200000 -D /tmp/qemu.log   \
		-monitor telnet::45454,server,nowait
