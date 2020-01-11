#!/bin/env bash

source common.sh

set -o


docker run --ip 172.19.0.2 \
	--publish 1234 \
	--network my-net \
	-v $XEN:/srv/git/xen \
	-v $OPENSBI:/srv/git/opensbi \
	-it xen-riscv bash
