#!/usr/bin/env bash

riscv64-unknown-linux-gnu-gdb \
	-ex "target remote 172.19.0.2:1234" \
	-ex "add-symbol-file xen/xen/xen-syms 0x80200000" \
	-ex "hb *0x80200000" \
	-ex "file xen/xen/xen-syms" \
	-ex "c"
