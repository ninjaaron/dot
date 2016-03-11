#!/usr/bin/env python3
'''
Functions to make using shell commands easier than it is with the
subprocess module, but no less safe, and still fairly "pythonic."

Basically, all the functions run shlex.split() on your commands, and
they use unicode instead of bytes (which subprocess doesn't do in
python3 because why?). Of course, these functions are no substitute for
the full power of the Popen interface, though it will pass additional
kwargs to subprocess.run().
'''
import subprocess as sp
import shlex


def run(cmd, **kwargs):
    '''
    runs the command string as interpreted by shlex and sets
    universal_newlines to True (i.e. unicode streams). Passes additional
    key-word parameters to subprocess.run(). Returns a CompletedProcess
    object Refer to the official subprocess module documentation for more
    info.
    '''
    return sp.run(shlex.split(cmd), universal_newlines=True, **kwargs)


def grab(cmd, split=True, **kwargs):
    '''
    similar to the run() function, but returns the output of the
    command. By default, it returns the output as a list of lines (good
    for iterating). Use split=False to return a string.
    '''
    out = run(cmd, stdout=sp.PIPE, **kwargs).stdout
    if split:
        return out.splitlines()
    else:
        return out


def pipe(*args, split=True, input=None, stdin=None, stderr=None, **kwargs):
    '''
    like the grab() function, but will take a list of commands and pipe
    them into each other, one after another. If pressent, the 'stderr'
    parameter will be passed to all commands. 'input' and 'stdin' will
    be passed to the initial command all other **kwargs will be passed
    to the final command.
    '''
    out = grab(args[0], split=False, input=input, stdin=stdin, stderr=stderr)
    for cmd in args[1:-1]:
        out = grab(cmd, input=out, split=False, stderr=stderr)
    return grab(args[-1], split=split, input=out, stderr=stderr, **kwargs)
