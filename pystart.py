import sys, os, re, shlex, inspect, json
import subprocess as sp
from pprint import pprint
from timeit import timeit
from glob import glob

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


class Trigger:
    def __init__(self, func):
        self.func = func

    def __repr__(self):
        self.func()
        return ''

    def __truediv__(self, other):
        return self.func(other)

    def __getattr__(self, name):
        return self.func(name)

    def __getitem__(self, name):
        return self.func(name)


class Cmd:
    def __init__(self, cmd, mode=None):
        self.cmd = shlex.split(cmd) if isinstance(cmd, str) else cmd
        self.mode = mode

    def __pos__(self):
        return ep.grab(self.cmd)

    def __neg__(self):
        ep.run(self.cmd)

    def __repr__(self):
        -self
        return ''

    def __getitem__(self, value):
        if isinstance(value, (int, slice)):
            return (+self)[value]
        return Cmd(self.cmd+glob(os.path.expanduser(value)))

    def __getattr__(self, name):
        if name.startswith('_'):
            return Cmd(self.cmd+['-'+name[1:]])
        return self[name]

    def __call__(self, *args, **kwargs):
        return ep.grab(self.cmd, *args, **kwargs)

    def __iter__(self):
        return iter(+self)

    def __sub__(self, flag):
        return self.F/flag

    def __truediv__(self, value):
        return self[value]

    def __or__(self, func):
        return tuple(map(func, +self))

    def __dir__(self):
        return ep.grab('ls').tuple


# class Exit:
#     def __repr__(self):
#         __builtins__.exit()


# exit = Exit()


def funky_junk():

    @Trigger
    def c(hint=None):
        os.chdir(dirlog.get_and_update(hint))
        -(sh/'ls --color=auto')

    @Trigger
    def vs(cmd):
        if inspect.ismodule(cmd):
            -(sh/env.PAGER/cmd.__file__)
            return
        what = +sh.which[cmd]
        if what.len > 1:
            ep.run([env.PAGER, '-c', 'set ft=sh'], stdin=what)
        else:
            sh/env.PAGER/what

    f = Trigger(lambda s: s.format(**inspect.stack()[2][0].f_locals))
    h = Trigger(lambda func=None: help() if func is None else help(func))
    sh = Trigger(lambda c: Cmd(c))
    ls, e, clear, view = sh/'ls --color=auto', sh.permedit, sh.clear, sh.vimpager
    ll, la, lla = ls._l, ls._a, ls._la
    rm = sh.rm._r
    globals().update(locals())



class DotDict(dict):
    "dict for people who are too lazy to type brackets and quotation marks"
    __getattr__ = dict.__getitem__
    __setattr__ = dict.__setitem__
    __delattr__ = dict.__delitem__
    def __dir__(self): return list(self)


env = DotDict(os.environ)


# class Prompt:
#     def __init__(self):
#         colors = ('\x1b[%dm' % (30 + i) for i in range(8))
#         cnames = ('bk', 'rd', 'gr', 'yl', 'bl', 'mg', 'cy', 'wh')
#         self.colors = dict(zip(cnames, colors))
#         self.colors['nr'] = '\x1b[0m'

#     def __str__(self):
#         self.colors['cwd'] = os.getcwd().replace(env.HOME, '~')
#         return '{bl}{cwd}{gr}>{nr} '.format(**self.colors)


# class Prompt2(Prompt):
#     def __str__(self):
#         return '.' * (len(str(sys.ps1))-15) + ' '

# if not 'bpython' in sys.argv[0]:
#     sys.ps1 = Prompt()
#     sys.ps2 = Prompt2()
