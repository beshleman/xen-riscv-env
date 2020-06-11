#!/usr/bin/env python

import sys

ENTRY = 0x80200000
PAGE_OFFSET = 12
PAGE_SIZE = (1<<PAGE_OFFSET)
PAGE_MASK = (PAGE_SIZE - 1)

def round_page(addr):
    return (addr & ~PAGE_MASK) + PAGE_SIZE

if __name__ == '__main__':
    xenend = int(sys.argv[1], base=16) + PAGE_SIZE + ENTRY
    print("0x%x" % round_page(xenend))
