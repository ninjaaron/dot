#!/usr/bin/env bash

mkdir ~/.ptpython/
rm ~/.ptpython/config.py 2> /dev/null
ln -s $PWD/ptpythonconfig.py ~/.ptpython/config.py
