OPENSBI_REV := 6ffe1bed09be1cb2db8755b30c0258849184400b

.PHONY: all
all:
	./build.sh
	./run.sh

.PHONY: fetch
fetch:
	git clone git@github.com:beshleman/xen.git
	cd xen && git checkout port-to-risc-v
	git clone https://github.com/riscv/opensbi.git
	cd opensbi && git reset --hard $(OPENSBI_REV)
