#!/bin/bash

gdb qemu/riscv64-softmmu/qemu-system-riscv64 
# r -nographic -machine virt      -kernel xen-on-riscv/riscv-pk/build/bbl -append "root=/dev/vda ro console=ttyS0"      -drive file=xen-on-riscv/busybear-linux/busybear.bin,format=raw,id=hd0      -device virtio-blk-device,drive=hd0

# r -s -S -nographic -machine virt      -kernel xen-on-riscv/riscv-pk/build/bbl -append "root=/dev/vda ro console=ttyS0"      -drive file=xen-on-riscv/busybear-linux/busybear.bin,format=raw,id=hd0      -device virtio-blk-device,drive=hd0


# r -s -S -nographic -machine virt  -kernel xen-on-riscv/opensbi/build/platform/qemu/virt/firmware/fw_jump.elf -append "root=/dev/vda ro console=ttyS0"      -drive file=xen-on-riscv/busybear-linux/busybear.bin,format=raw,id=hd0      -device virtio-blk-device,drive=hd0
