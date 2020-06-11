#!/bin/bash

XEN_START_ADDRESS=0x80200000

riscv64-gdb \
	-ex "target remote localhost:1234" \
	-ex "add-symbol-file xen/xen/xen-syms ${XEN_START_ADDRESS}" \
	-ex "hb *${XEN_START_ADDRESS}" \
	-ex "file xen/xen/xen-syms" \
        -ex "dir xen/xen/arch/riscv" \
	-ex "c"
