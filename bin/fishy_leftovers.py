#!/usr/bin/env python3
import pathlib
import libaaron
HOME = pathlib.Path.home()


def main():
    funcs = {p.stem for p in
             (HOME/'.config'/'fish'/'functions').iterdir()}
    aliases = {line.split()[1].partition('=')[0]
               for line in libaaron.w(open(HOME/'.aliases'))
               if line.startswith('alias')}
    print(*(funcs-aliases), sep='\n')


if __name__ == '__main__':
    main()
