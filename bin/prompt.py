#!/usr/bin/env python3
import os, sys, pathlib
import subprocess as sp

ENV = os.environ

def get_short_dir():
    dir = pathlib.Path(os.getcwd().replace(ENV["HOME"], "~")).parts
    if len(dir) > 1:
        return os.path.join(
            *(dir[:1] + tuple(d[0] if d[0] != "." else d[:2] for d in dir[1:-1]) + dir[-1:])
        )
    else:
        return dir[0]


def get_git_prompt_later():
    branch_proc = sp.Popen(
        ["git", "branch"], stdout=sp.PIPE, stderr=sp.DEVNULL, universal_newlines=True
    )
    status_proc = sp.Popen(
        ["git", "status", "-s"], stdout=sp.PIPE, stderr=sp.DEVNULL, universal_newlines=True
    )

    def get_git_prompt():
        branch = [i for i in branch_proc.stdout if i.startswith("*")][0][2:-1]
        color = "red" if status_proc.stdout.read() else "green"
        return color, branch

    return get_git_prompt



def main():
    if ENV["USER"] == "root":
        print("%F{yellow}%m%f:%F{red}%~%f# ")
        sys.exit()

    get_git_prompt = get_git_prompt_later()

    prompt = ["%F{{blue}}{}%f> ".format(get_short_dir())]

    # print the host name over ssh
    if ENV.get("SSH_TTY"):
        prompt.append("%F{green}%m%f:")

    # git status info
    try:
        prompt.append("%F{{{}}}{}%f|".format(*get_git_prompt()))
    except IndexError:
        pass

    # check about updates
    try:
        updates = open(ENV["HOME"] + "/.updates", "rb").read().hex()
    except FileNotFoundError:
        pass
    else:
        if updates != "00":
            prompt.append("%F{{yellow}}{}%f|".format(updates.lstrip()))

    # virtualenv stuff
    venv = ENV.get("VIRTUAL_ENV")
    if venv:
        prompt.append("{}|".format(os.path.basename(venv)))

    # print
    print("".join(prompt[::-1]))


main()
