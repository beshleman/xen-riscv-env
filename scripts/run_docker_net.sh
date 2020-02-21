#!/bin/bash

set -eu

IP=$1
ENTRY=$2
DOCKER_VER=$3

if ! docker network ls | grep -q my-net; then
	docker network create my-net --subnet 172.19.0.0/24
fi

docker run --ip ${IP} \
	--publish 1234 \
	--network my-net \
	-v $(readlink -e .):/home/ \
	-it petebob/riscv:${DOCKER_VER} ${ENTRY}
