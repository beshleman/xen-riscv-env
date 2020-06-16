#!/bin/bash

set -eu

DOCKER_IMAGE_TAG=$1

./scripts/run_docker_net.sh 172.19.0.3 ./scripts/remote_debug.sh ${DOCKER_IMAGE_TAG}
