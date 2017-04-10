#!/usr/bin/env bash

cd fish
for file in *; do
    rm "$HOME/.config/fish/$file" 2> /dev/null
    ln -s "$PWD/$file" "$HOME/.config/fish/$file"
done
