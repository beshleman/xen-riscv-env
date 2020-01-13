#!/bin/env bash

set -e

has_network=$(docker network ls | grep my-net)

if [[ "x$has_network" == "x" ]];
then
	docker network create my-net --subnet 172.19.0.0/24
fi

docker run --ip 172.19.0.2 \
	--publish 1234 \
	--network my-net \
	-v $(readlink -e .):/home/ \
	-it xen-riscv bash
