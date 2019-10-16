#!/bin/bash

gdb $(which qemu-system-riscv64) -ex "b get_physical_address if addr == 0x40000000" \
    -ex "r -s -S -machine virt -cpu rv64,x-h=true -M virt -m 512M -display none -serial stdio -kernel opensbi/build/platform/qemu/virt/firmware/fw_jump.elf -device loader,file=xen/xen/xen,addr=0x80200000"
