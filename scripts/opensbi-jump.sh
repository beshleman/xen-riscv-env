#!/bin/bash

set -e

CROSS_COMPILE=riscv64-unknown-linux-gnu- 

if [[ "$@" =~ "build" ]]; then
    pushd xen/xen
    XEN_TARGET_ARCH=riscv64 CROSS_COMPILE=riscv64-unknown-linux-gnu- make build -j$(nproc)
    popd
fi

if [[ "$@" =~ "iwyu" ]]; then
    CROSS_COMPILE_OLD=$CROSS_COMPILE
    pushd xen/xen
    set -x
    CROSS_COMPILE=
    XEN_TARGET_ARCH=riscv64 make build -k CC=$(which include-what-you-use)
    set +x
    popd
    CROSS_COMPILE=$CROSS_COMPILE_OLD
fi

if [[ "$@" =~ "run" ]]; then
    FLAGS=" -machine virt -cpu rv64,x-h=true -M virt -m 512M -display none -serial stdio -monitor telnet::45454,server,nowait"

    if [[ "$@" =~ "debug" ]]; then
        FLAGS="-s -S ${FLAGS}"
    fi

    echo "+++++++++++++++++++++++++"
    echo "Succesful build, spinning up QEMU...."
    echo "+++++++++++++++++++++++++"


    qemu-system-riscv64 ${FLAGS} -kernel opensbi/build/platform/qemu/virt/firmware/fw_jump.elf -device loader,file=xen/xen/xen,addr=0x80200000
fi

		
