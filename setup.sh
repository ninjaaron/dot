#!/usr/bin/env bash

#################
# link pathogen #
#################

mkdir dotfiles/vim/{autoload,backups}
ln sub/vim-pathogen/autoload/pathogen.vim dotfiles/vim/autoload/

###############################
# link config files and ~/bin #
###############################

pushd dotfiles
for file in *;do
  rm "$HOME/.$file"
  ln -s "$PWD/$file" "$HOME/.$file"
done
popd

rm "$HOME/bin"
ln -s "$PWD/bin" "$HOME/bin"

#####################################
# localize ~/.zshenv and ~/.profile #
#####################################

echo "generating shell profiles..."

cat > $HOME/.zshenv << EOF
export PATH="\$HOME/bin:\$HOME/.gem/ruby/2.3.0/bin:\$PATH"
export EDITOR="vim"
export DOT="$PWD"
export PYTHONSTARTUP="\$DOT/pystart.py"
export PYTHONPATH="\$PYTHONPATH"
EOF
cp $HOME/.zshenv $HOME/.profile
echo "source ~/.aliases" >> $HOME/.bashrc