#!/bin/bash

set -eu

if ! docker network ls | grep -q my-net; then
	docker network create my-net --subnet 172.19.0.0/24
fi

docker run --ip 172.19.0.3 \
	--publish 1234 \
	--network my-net \
	-v $(readlink -e .):/home/ \
	-it petebob/riscv:$(make --no-print-directory -C container version) \
		./scripts/remote_debug.sh
