#!/bin/env bash

riscv64-linux-gnu-gdb \
	-ex 'target remote 172.19.0.2:1234'
