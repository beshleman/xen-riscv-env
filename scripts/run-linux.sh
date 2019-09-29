#!/bin/bash
/usr/bin/qemu-system-riscv64 -nographic -machine virt \
      -kernel riscv-pk/build/bbl -append "root=/dev/vda ro console=ttyS0" \
      -drive file=busybear-linux/busybear.bin,format=raw,id=hd0 \
      -device virtio-blk-device,drive=hd0
