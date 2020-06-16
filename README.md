# The Container Environment for Xen on RISC-V Development

## Setup

1. Fetch Dependencies

```bash
$ make fetch
```

2. Pull Docker image

```bash
$ make docker-pull
```


## Build

```bash
$ make docker-all
```

## Run

```bash
$ make run
```

## Debug

Call `make run` in one terminal session.

In another window:

```bash
$ make debug
```

## Build Docker Image

```
# First build the "upstream" image
$ make docker-build-upstream

# Then build the "downstream" image
$ make docker-build
```
