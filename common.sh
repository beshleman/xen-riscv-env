#!/bin/env bash

export XEN=/home/bobbye/projects/xen-on-riscv/xen
export OPENSBI=/home/bobbye/projects/xen-on-riscv/opensbi

docker network create my-net --subnet 172.19.0.0/24

