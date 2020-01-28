#!/bin/bash

set -e

pushd xen/xen
XEN_CONFIG_EXPERT=y XEN_TARGET_ARCH=riscv64 make defconfig
XEN_CONFIG_EXPERT=y XEN_TARGET_ARCH=riscv64 CROSS_COMPILE=riscv64-unknown-linux-gnu- make build -j8
popd

pushd opensbi
CROSS_COMPILE=riscv64-unknown-linux-gnu- PLATFORM=qemu/virt FW_PAYLOAD_PATH=../xen/xen/xen make -j8
popd
