#!/usr/bin/env bash

###############################
# link config files and ~/bin #
###############################
(
cd shell
for file in *;do
  [[ $file != "bin" ]] && [[ $file != "config.fish" ]] &&
      ln -s "$PWD/$file" "$HOME/.$file"
done

ln -s "$PWD/bin" "$HOME/bin"
ln -s $PWD/config.fish "$HOME/.config/fish/config.fish"

#################################
# Pull down plugins from github #
#################################

echo "gitting zsh highlighting..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git 2> /dev/null

echo "adding vim plugins..."
mkdir vim/autoload vim/bundle
# much nicer to change directories in a subshell
(cd vim/autoload
wget https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim ||
  echo "failed to get pathogen!"
cd ../bundle
git clone https://github.com/ervandew/supertab.git
git clone https://github.com/scrooloose/nerdtree
git clone https://github.com/vim-scripts/VOoM.git
) 2> /dev/null
)

#####################################
# localize ~/.zshenv and ~/.profile #
#####################################

echo "generating shell profiles..."

cat > $HOME/.zshenv << EOF
export PATH="\$PATH:\$HOME/bin"
export EDITOR="vim"
export DOT="$PWD"
export HIGHLIGHT="\$DOT/shell/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
export PYTHONSTARTUP="\$DOT/pystart.py"
EOF
cp $HOME/.zshenv $HOME/.profile
echo "source ~/.aliases" >> $HOME/.bashrc
