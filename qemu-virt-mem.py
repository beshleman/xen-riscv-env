#!/bin/python

mem = [
(0x0010000000,0x00100),
(0x00100000,0x001000),
(0x0010008000,0x001000),
(0x0010007000,0x001000),
(0x0010006000,0x001000),
(0x0010005000,0x001000),
(0x0010004000,0x001000),
(0x0010003000,0x001000),
(0x0010002000,0x001000),
(0x0010001000,0x001000),
(0x0080000000,0x008000000),
(0x0030000000,0x0010000000),
(0x00c000000, 0x004000000),
(0x002000000, 0x0010000)
]



data = dict(min=(1<<50), max=0)
for s, e in mem:
    data['min'] = min(s, data['min'])
    data['max'] = max(s + e, data['max'])

print('0x%x, 0x%x' % (data['min'], data['max']))