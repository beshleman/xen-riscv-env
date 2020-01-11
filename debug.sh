#!/bin/env bash

source common.sh

set -o

docker run \
	--ip 172.19.0.3 \
	-v $XEN:/srv/git/xen \
	-v $OPENSBI:/srv/git/opensbi \
	-v $(readlink -e .):/home/ \
	-it xen-riscv bash
