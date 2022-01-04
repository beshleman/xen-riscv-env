source scripts/gdb/breakpoint/guest_entry.gdb
file
d

# the address just before setting satp
hb *0x40200078
hb *0x402000f4
c

# set satp, mmu on
si
si
