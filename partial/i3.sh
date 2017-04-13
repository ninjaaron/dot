#!/usr/bin/env bash
rm $HOME/.i3
mkdir $HOME/.i3
cd i3
for file in *; do
    rm "$HOME/.i3/$file" 2> /dev/null
    ln -s "$PWD/$file" "$HOME/.i3/$file"
done
bash ./i3-colorgen.sh
