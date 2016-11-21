#!/usr/bin/env python3
import sys

c2f = lambda x: x * 9/5 + 32
f2c = lambda x: (x - 32) * 5/9
i2c = lambda x: x * 2.54
c2i = lambda x: x / 2.54

print("%0.1f" % globals()[sys.argv[0].split('/')[-1]](float(sys.argv[1])))
