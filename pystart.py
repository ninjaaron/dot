import sys, os
import re
from importlib import reload as rl
import subprocess as sp
import easyproc as ep
from pyedpiper import pype, sh,  f, s, m
from collist import displayhook

HOME = os.environ['HOME']

class Prompt:
    def __init__(self):
        colors = ('\x1b[%dm' % (30 + i) for i in range(8))
        cnames = ('bk', 'rd', 'gr', 'yl', 'bl', 'mg', 'cy', 'wh')
        self.colors = dict(zip(cnames, colors))
        self.colors['nr'] = '\x1b[0m'

    def __str__(self):
        self.colors['cwd'] = os.getcwd().replace(HOME, '~')
        return '{bl}{cwd}{gr}>{nr} '.format(**self.colors)

sys.displayhook = displayhook
py = pype
# sys.ps1 = Prompt()
