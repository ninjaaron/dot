#!/usr/bin/env python3
import os, sys
import subprocess as sp

if os.environ['USER'] == 'root':
    print("%F{yellow}%m%f:%F{red}%~%f# ")
    sys.exit()

branch_proc = sp.Popen(['git', 'branch'], stdout=sp.PIPE,
                       stderr=sp.DEVNULL, universal_newlines=True)
status_proc = sp.Popen(['git', 'status', '-s'], stdout=sp.PIPE,
                       stderr=sp.DEVNULL, universal_newlines=True)

dir = os.getcwd().replace(os.environ['HOME'], '~').split('/')
if len(dir) > 1:
    short_dir = '/'.join(dir[:1]+[d[0] for d in dir[1:-1]]+dir[-1:])
else:
    short_dir = dir[0]

prompt = '%F{{blue}}{}%f> '.format(short_dir)

if os.environ.get('SSH_TTY'):
    prompt = '%F{{green}}%m%f:' + prompt

try:
    branch = [i for i in branch_proc.stdout if i.startswith('*')][0][2:-1]
    color = 'red' if status_proc.stdout.read() else 'green'
    prompt = '%F{{{}}}{}%f|'.format(color, branch) + prompt
except IndexError:
    pass

try:
    updates = open(os.environ['HOME']+'/.updates', 'rb').read().hex()
except FileNotFoundError:
    pass
else:
    if updates != '00':
        prompt = '%F{{yellow}}{}%f|'.format(updates.lstrip()) + prompt

print(prompt)
