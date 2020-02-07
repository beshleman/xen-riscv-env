# Xen Port Tooling

This repo offers Dockerfiles and scripts for building Xen, QEMU, the bootloader, the toolchain, etc...

# Usage

To run OpenSBI and Xen with QEMU:

```bash
$ ./run.sh
```

This halts waiting for GDB to connect.  To connect gdb:

```bash
$ ./debug.sh
```
