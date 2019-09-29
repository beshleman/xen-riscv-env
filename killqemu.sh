#!/bin/bash

kill -s 9 $(ps aux | grep qemu | cut -d ' ' -f 4)
