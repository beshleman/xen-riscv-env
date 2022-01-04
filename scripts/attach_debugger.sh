#!/bin/bash

riscv64-linux-gnu-gdb \
    -ex "set confirm off"   \
	-ex "target extended-remote localhost:1234" \
    -ex "source $1"
