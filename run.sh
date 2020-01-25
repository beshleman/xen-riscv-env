#!/bin/bash

set -eu

./scripts/run_docker_net.sh 172.19.0.2 ./scripts/run_qemu.sh
