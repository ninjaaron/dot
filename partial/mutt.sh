#!/usr/bin/env bash
rm $HOME/.mutt
mkdir $HOME/.mutt
cd mutt
for file in *; do
    rm "$HOME/.mutt/$file" 2> /dev/null
    ln -s "$PWD/$file" "$HOME/.mutt/$file"
done
