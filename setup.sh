#!/usr/bin/env bash

#################
# link pathogen #
#################

mkdir dotfiles/vim/{autoload,backups}
ln sub/vim-pathogen/autoload/pathogen.vim dotfiles/vim/autoload/

###############################
# link config files and ~/bin #
###############################

for file in dotfiles/*;do
  ln -s "$PWD/$file" "$HOME/.$file"
done

ln -s "$PWD/bin" "$HOME/bin"

#####################################
# localize ~/.zshenv and ~/.profile #
#####################################

echo "generating shell profiles..."

cat > $HOME/.zshenv << EOF
export PATH="\$PATH:\$HOME/bin"
export EDITOR="vim"
export DOT="$PWD"
export PYTHONSTARTUP="\$DOT/pystart.py"
EOF
cp $HOME/.zshenv $HOME/.profile
echo "source ~/.aliases" >> $HOME/.bashrc
