#!/usr/bin/env fish

cd fish
set fishdir $HOME/.config/fish
mkdir $fishdir 2> /dev/null

for name in config.fish functions
    rm -r $fishdir/$name 2> /dev/null
end

ln -s $PWD/config.fish $fishdir

mkdir $fishdir/functions
for func in $PWD/functions/*
    ln -s $func $fishdir/functions
end
fish $fishdir/functions/faz.fish
