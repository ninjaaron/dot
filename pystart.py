import sys, os
import re
import subprocess as sp
from pprint import pprint
from timeit import timeit
import inspect
import json

local_mods = ('from collist import displayhook;sys.displayhook = displayhook',
              'import easyproc as ep', 'import requests', 'import dirlog')
for mod in local_mods:
    try:
        exec(mod)
    except ImportError as e:
        print(e)

try:
    from importlib import reload as rl
except ImportError:
    rl = reload


class _Pipe:
    def __init__(self, func):
        self.func = func

    def __or__(self, other):
        return self.func(other)

    def __ror__(self, other):
        return self.func(other)

    def __mul__(self, other):
        return self.func(other)

    def __getattr__(self, name):
        return self.func(name)


f = _Pipe(lambda s: s.format(**inspect.stack()[2][0].f_locals))
c = _Pipe(lambda hint: os.chdir(dirlog.get_and_update(hint)))
sh = _Pipe(lambda c: ep.grab(c))

if 'ep' in globals():
    ep.ProcStream.__repr__ = lambda self: self.str


class LazyDict(dict):
    "dict for people who are too lazy to type brackets and quotation marks"
    __getattr__ = dict.__getitem__
    __setattr__ = dict.__setitem__
    __delattr__ = dict.__getitem__
    def __dir__(self): return list(self)

env = LazyDict(os.environ)


class Prompt:
    def __init__(self):
        colors = ('\x1b[%dm' % (30 + i) for i in range(8))
        cnames = ('bk', 'rd', 'gr', 'yl', 'bl', 'mg', 'cy', 'wh')
        self.colors = dict(zip(cnames, colors))
        self.colors['nr'] = '\x1b[0m'

    def __str__(self):
        self.colors['cwd'] = os.getcwd().replace(env.HOME, '~')
        return '{bl}{cwd}{gr}>{nr} '.format(**self.colors)


class Prompt2(Prompt):
    def __str__(self):
        return '.' * (len(str(sys.ps1))-15) + ' '

sys.ps1 = Prompt()
sys.ps2 = Prompt2()
