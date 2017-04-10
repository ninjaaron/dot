#!/usr/bin/env bash

cd moc
for file in *; do
    rm "$HOME/.moc/$file" 2> /dev/null
    ln -s "$PWD/$file" "$HOME/.moc/$file"
done
