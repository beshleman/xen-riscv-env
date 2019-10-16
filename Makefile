.PHONY: all clean opensbi qemu

XEN_BIN=$(PWD)/xen/xen/xen
CROSS_COMPILE=riscv64-unknown-linux-gnu-

all: opensbi qemu

opensbi:
	CROSS_COMPILE=$(CROSS_COMPILE) make PLATFORM=qemu/virt FW_PAYLOAD_PATH=$(XEN_BIN) -C $(PWD)/opensbi

qemu:
	scripts/build-qemu.sh

clean:
	make clean -C $(PWD)/opensbi

build:
scripts/opensbi-jump.sh build

run:
scripts/opensbi-jump.sh

