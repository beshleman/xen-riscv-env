hb *0x80200000
c
d
add-symbol-file xen/xen/xen-syms 0x80200000
b _setup_initial_pagetables
c
finish
b start_xen
c
d
