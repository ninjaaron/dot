import sys, os, re
from pprint import pprint
from timeit import timeit
try:
    import libaaron
    env = libaaron.DotDict(os.environ)
except ImportError as e:
    print(e)

local_mods = ('from collist import displayhook;sys.displayhook = displayhook',)
for mod in local_mods:
    try:
        exec(mod)
    except ImportError as e:
        print(e)

try:
    from importlib import reload as rl
except ImportError:
    rl = reload
# class Exit:
#     def __repr__(self):
#         __builtins__.exit()


# exit = Exit()




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
