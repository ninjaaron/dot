#!/usr/bin/env python3
import os, sys
import subprocess as sp

if os.environ['USER'] == 'root':
    print("%F{yellow}%m%f:%F{red}%~%f# ")
    sys.exit()

# prepare git stuff.
branch_proc = sp.Popen(['git', 'branch'], stdout=sp.PIPE,
                       stderr=sp.DEVNULL, universal_newlines=True)
status_proc = sp.Popen(['git', 'status', '-s'], stdout=sp.PIPE,
                       stderr=sp.DEVNULL, universal_newlines=True)

# truncate the directory
dir = os.getcwd().replace(os.environ['HOME'], '~').split('/')
if len(dir) > 1:
    short_dir = os.path.join(*(dir[:1]+[
        d[0] if d[0] != '.' else d[:2] for d in dir[1:-1]]+dir[-1:]))
else:
    short_dir = dir[0]

prompt = ['%F{{blue}}{}%f> '.format(short_dir)]

# print the host name over ssh
if os.environ.get('SSH_TTY'):
    prompt.append('%F{green}%m%f:')

# parse the git status info
try:
    branch = [i for i in branch_proc.stdout if i.startswith('*')][0][2:-1]
    color = 'red' if status_proc.stdout.read() else 'green'
    prompt.append('%F{{{}}}{}%f|'.format(color, branch))
except IndexError:
    pass

# check about updates
try:
    updates = open(os.environ['HOME']+'/.updates', 'rb').read().hex()
except FileNotFoundError:
    pass
else:
    if updates != '00':
        prompt.append('%F{{yellow}}{}%f|'.format(updates.lstrip()))

# virtualenv stuff
venv = os.environ.get('VIRTUAL_ENV')
if venv:
    prompt.append('{}|'.format(os.path.basename(venv)))


print(''.join(prompt[::-1]))
