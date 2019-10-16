import gdb
import random

load_addr_start = None
load_addr_end = None
linker_addr_start = None
linker_addr_end = None


def setup():
    global load_addr_start
    global load_addr_end
    global linker_addr_start
    global linker_addr_end

    cmds = [
        "target remote localhost:1234",
        "add-symbol-file xen/xen/xen-syms 0x80200000",
        "file xen/xen/xen-syms",
        "hbreak *0x80200000",
        "directory xen/xen/arch/riscv/",
        "continue",
        "layout src",
        "delete",
        "b _setup_initial_pagetables",
        "c",
    ]

    for cmd in cmds:
        gdb.execute(cmd)

    frame = gdb.newest_frame()
    load_addr_start, _ = gdb.lookup_symbol('load_addr_start')
    load_addr_start = load_addr_start.value(frame)

    load_addr_end, _ = gdb.lookup_symbol('load_addr_end')
    load_addr_end = load_addr_end.value(frame)

    linker_addr_start, _ = gdb.lookup_symbol('linker_addr_start')
    linker_addr_start = linker_addr_start.value(frame)

    linker_addr_end, _ = gdb.lookup_symbol('linker_addr_end')
    linker_addr_end = linker_addr_end.value(frame)

    print('load_addr_start 0x%x' % load_addr_start)
    print('load_addr_end 0x%x' % load_addr_end)
    print('linker_addr_start 0x%x' % linker_addr_start)
    print('linker_addr_end 0x%x' % linker_addr_end)

setup()

def test_identity_map():
    '''Passes if a random sampling of load-time and link-time addresses are all equal'''

    # By the time we get to start_xen() the boot map should be in place.  The boot map includes the identity map.
    gdb.execute('b start_xen')
