#!/bin/bash

DOCKER_IMAGE_TAG=registry.gitlab.com/bobbyeshleman/xen/archlinux:riscv

set -eu

./scripts/run_docker_net.sh 172.19.0.3 ./scripts/remote_debug.sh ${DOCKER_IMAGE_TAG}
