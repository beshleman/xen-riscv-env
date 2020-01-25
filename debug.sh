#!/bin/env bash

set -e

docker run --ip 172.19.0.3 \
	--publish 1234 \
	--network my-net \
	-v $(readlink -e .):/home/ \
	-it xen-riscv bash
