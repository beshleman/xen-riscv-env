#!/bin/bash


riscv64-unknown-linux-gnu-gdb opensbi/build/platform/qemu/virt/firmware/fw_payload.elf \
	-ex "target remote localhost:1234" \
	-ex "add-symbol-file xen/xen/xen-syms 0x80200000" \
	-ex "hbreak start_xen" \
	-ex "hbreak *0x80200000" \
	-ex "directory xen/xen/" \
	-ex "layout src"
