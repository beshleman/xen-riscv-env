DOCKER_IMAGE_TAG := xen-riscv-env:latest

vol_mnt    = -v $(1):$(1)
vol_mnt_ro = $(call vol_mnt,$(1)):ro
map        = $(foreach f,$(2),$(call $(1),$(f)))

DOCKER_ARGS = -t --rm -w $(CURDIR) $(call vol_mnt,$(CURDIR))
DOCKER_ARGS += $(call map,vol_mnt_ro,/etc/passwd /etc/group /etc/shadow)
ifeq ($(ROOT),)
    DOCKER_ARGS += -u $(shell id -u):$(shell id -g)
    DOCKER_ARGS += $(call vol_mnt_ro,$(HOME)/.ssh)
else
    DOCKER_ARGS += -v $(HOME)/.ssh:/root/.ssh
endif
DOCKER_ARGS += $(DOCKER_IMAGE_TAG)

OPENSBI_REV := 6ffe1bed09be1cb2db8755b30c0258849184400b
CLONED_DEPS := xen/.cloned opensbi/.cloned linux/.cloned

.PHONY: all
all: $(CLONED_DEPS) linux/vmlinux
	XEN_CONFIG_EXPERT=y XEN_TARGET_ARCH=riscv64 CROSS_COMPILE=riscv64-unknown-linux-gnu- $(MAKE) -C xen/xen riscv64_defconfig
	XEN_CONFIG_EXPERT=y XEN_TARGET_ARCH=riscv64 CROSS_COMPILE=riscv64-unknown-linux-gnu- $(MAKE) -C xen/xen build -j8
	$(MAKE) -C opensbi CROSS_COMPILE=riscv64-unknown-linux-gnu- PLATFORM=qemu/virt FW_PAYLOAD_PATH=../xen/xen/xen -j$$(nproc)

linux/vmlinux:
	$(MAKE) -C linux ARCH=riscv defconfig
	$(MAKE) -C linux CROSS_COMPILE=riscv64-unknown-linux-gnu- ARCH=riscv -j$$(nproc)

.PHONY: run
run:
	scripts/run_docker_net.sh 172.19.0.2 scripts/run_qemu.sh "$(DOCKER_IMAGE_TAG)"

.PHONY: fetch
fetch: $(CLONED_DEPS)

.PHONY: clean
clean:
	$(if $(wildcard xen/xen),$(MAKE) -C xen/xen clean -j$$(nproc))
	$(if $(wildcard opensbi),$(MAKE) -C opensbi clean -j$$(nproc))

.PHONY: cleanall
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

linux/.cloned:
	wget https://git.kernel.org/torvalds/t/linux-5.7-rc5.tar.gz
	tar xvf linux-5.7-rc5.tar.gz
	mv linux-5.7-rc5.tar.gz linux
	touch $@

.PHONY: docker-shell
docker-shell:
	scripts/run_docker_net.sh 172.19.0.2  /bin/bash $(DOCKER_IMAGE_TAG)

.PHONY: docker-build
docker-build:
	docker build . --tag $(DOCKER_IMAGE_TAG)

.PHONY: docker-publish
docker-publish:
	docker push $(DOCKER_IMAGE_TAG)

docker-%: Dockerfile
	docker run $(DOCKER_ARGS) $(notdir $(MAKE)) $* $(MAKEFLAGS)

print-%:
	@:$(info $($*))
