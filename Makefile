OPENSBI_REV := 6ffe1bed09be1cb2db8755b30c0258849184400b

CLONED_DEPS := xen/.cloned opensbi/.cloned

.PHONY: all
all: $(CLONED_DEPS)
	./build.sh
	./run.sh

.PHONY: fetch
fetch: $(CLONED_DEPS)

cleanall:
	$(RM) -r xen opensbi

xen/.cloned:
	git clone git@github.com:beshleman/xen.git
	cd xen && git checkout port-to-risc-v
	touch $@

opensbi/.cloned:
	git clone https://github.com/riscv/opensbi.git
	cd opensbi && git reset --hard $(OPENSBI_REV)
	touch $@
