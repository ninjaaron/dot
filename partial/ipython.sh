#!/usr/bin/env bash

cd ipython
for file in *; do
    rm "$HOME/.ipython/profile_default/$file" 2> /dev/null
    ln -s "$PWD/$file" "$HOME/.ipython/profile_default/$file"
done
