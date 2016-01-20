#!/usr/bin/env python3

from subprocess import call, getoutput

while True:

    query = input('Enter module and reference (or q): ')

    if query == 'q':
        break

    query = query.split()
    module = query[0].upper()
    key = " ".join(query[1:])

    result = getoutput("diatheke -b %s -o cva -k %s"  % (module, key))
    print(result)
    call('xclip -i <<< "%s"' % result, shell="/bin/bash" )
