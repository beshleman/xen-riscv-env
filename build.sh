#!/bin/bash

set -eu

pushd xen/xen
XEN_CONFIG_EXPERT=y XEN_TARGET_ARCH=riscv64 make defconfig
XEN_CONFIG_EXPERT=y XEN_TARGET_ARCH=riscv64 CROSS_COMPILE=riscv64-unknown-linux-gnu- make build -j8
popd

pushd opensbi
CROSS_COMPILE=riscv64-unknown-linux-gnu- PLATFORM=qemu/virt FW_PAYLOAD_PATH=../xen/xen/xen make -j8
popd

# The IP address doesn't really matter
./scripts/run_docker_net.sh 172.19.0.2 ./scripts/raw_build.sh

