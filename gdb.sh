#!/bin/bash

top=$(pwd)
riscv64-unknown-linux-gnu-gdb $(cat ${top}/.last_kernel) -x scripts/gdb/xen.gdb
