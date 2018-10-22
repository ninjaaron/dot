#!/bin/sh
dir="$1"
sudo ~/bin/rsnap2 -k 3 -m "$dir/" "$dir/rootvol" "$dir/snapshots"
sudo pacmatic -Syu
pacman -Qu | wc -l | int2byte > ~/.updates
