#!/usr/bin/env python

import sys

ENTRY = 0x80000000
PAGE_SIZE = (4<<10)

def round_page(addr):
    pages = addr // PAGE_SIZE
    return (pages + 1) * PAGE_SIZE

if __name__ == '__main__':
    xenend = int(sys.argv[1], base=16) + PAGE_SIZE + ENTRY
    print("0x%x" % round_page(xenend))
