#!/bin/bash

riscv64-unknown-linux-gnu-gdb opensbi/build/platform/qemu/virt/firmware/fw_payload.elf \
	-ex "target remote localhost:1234" \
	-ex "hbreak *0x80200000" \
	-ex "add-symbol-file xen/xen/xen-syms 0x80200000" \
	-ex "file xen/xen/xen-syms" \
	-ex "continue" \
	-ex "directory xen/xen/arch/riscv/" \
	-ex "hbreak start_xen" \
	-ex "layout src"
