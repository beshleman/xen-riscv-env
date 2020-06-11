# The Container Environment for Xen on RISC-V Development

## Setup

1. Fetch Dependencies

```
$ make fetch
```

2. Build Docker Image

```
# First build the "upstream" image
$ make docker-build-upstream

# Then build the "downstream" image
$ make docker-build
```

## Build

```
$ make docker-all
```

## Run

```
$ make run
```
