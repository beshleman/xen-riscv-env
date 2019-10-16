#!/bin/bash

riscv64-unknown-linux-gnu-gdb \
	-ex "target remote localhost:1234" \
	-ex "add-symbol-file xen/xen/xen-syms 0x80200000" \
	-ex "file xen/xen/xen-syms" \
	-ex "hbreak *0x80200000" \
	-ex "continue" \
        -ex "delete"    \
	-ex "directory xen/xen/arch/riscv/" \
	-ex "set logging file /tmp/gdb.txt" \
	-ex "set logging on" \
	-ex "layout src"      
