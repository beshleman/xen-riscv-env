source scripts/gdb/breakpoint/xen_entry.gdb
file
file xen/xen/xen-syms
hb start_xen
c
d
file
file xen/xen/xen-syms
hb return_to_new_vcpu64
c
d
hb *0x40200000
c
d
file
add-symbol-file linux/vmlinux -o -18446743935194759168
