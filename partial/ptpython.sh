#!/usr/bin/env bash

mkdir -p ~/.config/ptpython/
rm ~/.config/ptpython/config.py 2> /dev/null
ln -s $PWD/ptpythonconfig.py ~/.config/ptpython/config.py
