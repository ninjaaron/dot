import sys, os
import re
import subprocess as sp
import easyproc as ep
from importlib import reload as rl
from pyedpiper import Stream, fmt, s, m
from collist import displayhook

pype = Stream(interpolate=True)
py = pype
sh = py.sh
HOME = os.environ.get('HOME')
sys.displayhook = displayhook
