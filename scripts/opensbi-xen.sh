#!/bin/bash

xen_bin=xen/xen/xen
#qemu-system-riscv64 -nographic -s -S -machine virt -cpu rv64,x-h=true 	\
#		-serial mon:stdio -serial null -m 4G			\
#		-monitor telnet::45454,server,nowait			\
#		-device loader,file=${xen_bin},addr=0x80200000		\
#		-kernel opensbi/build/platform/qemu/virt/firmware/fw_jump.elf
#


qemu-system-riscv64 -s -S -cpu rv64,x-h=true -M virt -m 512M \
		-display none -serial stdio -bios opensbi/build/platform/qemu/virt/firmware/fw_jump.bin \
		-kernel ./xen/xen/xen
