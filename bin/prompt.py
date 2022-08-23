#!/usr/bin/env python3
import os, sys, pathlib
import asyncio
import asyncio.subprocess as sp

ENV = os.environ


def get_short_dir():
    dir = pathlib.Path(os.getcwd().replace(ENV["HOME"], "~")).parts
    if len(dir) > 1:
        return os.path.join(
            *(dir[:1] + tuple(d[0] if d[0] != "." else d[:2] for d in dir[1:-1]) + dir[-1:])
        )
    else:
        return dir[0]


async def get_git_prompt():
    branch_proc = await sp.create_subprocess_exec(
        "git", "branch", stdout=sp.PIPE, stderr=sp.DEVNULL
    )
    status_proc = await sp.create_subprocess_exec(
        "git", "status", "-s", stdout=sp.PIPE, stderr=sp.DEVNULL
    )
    branch_out = (await branch_proc.communicate())[0].decode().splitlines()
    color = "red" if (await status_proc.communicate())[0] else "green"

    branch = [i for i in branch_out if i.startswith("*")][0][2:]
    return color, branch


async def main():
    if ENV["USER"] == "root":
        print("%F{yellow}%m%f:%F{red}%~%f# ")
        return

    git_prompt_task = asyncio.create_task(get_git_prompt())

    prompt = ["%F{{blue}}{}%f> ".format(get_short_dir())]

    # print the host name over ssh
    if ENV.get("SSH_TTY"):
        prompt.append("%F{green}%m%f:")

    # check about updates
    try:
        updates = open(ENV["HOME"] + "/.updates", "rb").read().hex()
    except FileNotFoundError:
        updates = "00"

    # git status info
    try:
        prompt.append("%F{{{}}}{}%f|".format(*(await git_prompt_task)))
    except IndexError:
        pass

    if updates != "00":
        prompt.append("%F{{yellow}}{}%f|".format(updates.lstrip()))

    # virtualenv stuff
    venv = ENV.get("VIRTUAL_ENV")
    if venv:
        prompt.append("{}|".format(os.path.basename(venv)))

    # print
    print("".join(prompt[::-1]))


asyncio.run(main())
