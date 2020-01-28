#!/bin/bash

set -eu

# The IP address doesn't really matter
./scripts/run_docker_net.sh 172.19.0.2 ./scripts/raw_build.sh
