DOCKER_IMAGE_TAG := registry.gitlab.com/bobbyeshleman/xen/archlinux:riscv

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
CLONED_DEPS := xen/.cloned opensbi/.cloned

export CC=gcc
export XEN_TARGET_ARCH=riscv64

.PHONY: all
all: $(CLONED_DEPS)
	cd xen && automation/scripts/build
	$(MAKE) -C opensbi CROSS_COMPILE=riscv64-unknown-linux-gnu- PLATFORM=qemu/virt FW_PAYLOAD_PATH=../xen/xen/xen -j$$(nproc)

.PHONY: run
run:
	scripts/run_docker_net.sh 172.19.0.2 scripts/run_qemu.sh "$(DOCKER_IMAGE_TAG)"

.PHONY: fetch
fetch: $(CLONED_DEPS)

.PHONY: clean
clean:
	$(if $(wildcard xen/xen),$(MAKE) -C xen/xen clean)
	$(if $(wildcard opensbi),$(MAKE) -C opensbi clean)

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
