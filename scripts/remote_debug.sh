#!/bin/bash

XEN_START_ADDRESS=0x80200000

riscv64-unknown-linux-gnu-gdb \
	-ex "target remote 172.19.0.2:1234" \
	-ex "add-symbol-file xen/xen/xen-syms ${XEN_START_ADDRESS}" \
	-ex "hb *${XEN_START_ADDRESS}" \
	-ex "file xen/xen/xen-syms" \
	-ex "dir xen/xen/arch/riscv" \
	-ex "source mygdbscript.scr"
