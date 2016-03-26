import sys, os
import re
import subprocess as sp
import easyproc as ep
from importlib import reload as rl
from pyedpiper import sh, pype, fmt, s
from collist import displayhook

py = pype
HOME = os.environ.get('HOME')
sys.displayhook = displayhook
