#!/usr/bin/env bash
base_dir="$HOME/.config/sway"
rm "$base_dir"
mkdir "$base_dir"
cd sway
for file in *; do
    rm "$base_dir/$file" 2> /dev/null
    ln -s "$PWD/$file" "$base_dir/$file"
done
bash ./theme
