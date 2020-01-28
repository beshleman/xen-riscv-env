# Build Notes

## KConfig: Minimal Build

A minimal build consists of:
	CONFIG_GRANT_TABLE=n

Building with `CONFIG_GRANT_TABLE=n` requires the use of the
`XEN_CONFIG_EXPERT=y` environment variable being set. 

The riscv defconfigs are the "minimal" build by default.

# Debugging

To run OpenSBI and Xen with QEMU:

```bash
$ ./run.sh
```

This halts waiting for GDB to connect.  To connect gdb:

```bash
$ ./debug.sh
```
