#!/usr/bin/env bash

#################
# link pathogen #
#################

failwith() {
  echo "$1"
  exit "$2"
}

mkdir dotfiles/vim/{autoload,backups,bundle}
curl -LSso dotfiles/vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim ||
  failwith "could not download pathogen" "$?"

###############################
# link config files and ~/bin #
###############################

pushd dotfiles
for file in *;do
  rm "$HOME/.$file"
  ln -s "$PWD/$file" "$HOME/.$file"
done
rm "$HOME/.config/nvim"
ln -s "$PWD/vim" "$HOME/.config/nvim"
rm "$PWD/vim/init.vim"
ln -s "$PWD/vimrc" "$PWD/vim/init.vim"
popd

rm "$HOME/bin"
ln -s "$PWD/bin" "$HOME/bin"

#####################################
# localize ~/.zshenv and ~/.profile #
#####################################

echo "generating shell profiles..."

cat > $HOME/.zshenv << EOF
export EDITOR="vim"
export DOT="$PWD"
export PYTHONSTARTUP="\$DOT/pystart.py"
export PYTHONPATH="\$PYTHONPATH"
#export HIGHLIGHT="\$DOT/sub/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
#export COMPL="\$DOT/sub/zsh-autosuggestions/zsh-autosuggestions.zsh"
EOF

echo 'export PATH="$HOME/bin:$HOME/.local/bin:$PATH"' \
  >> ~/.zprofile

cp $HOME/.zshenv $HOME/.profile
echo 'export PATH="$HOME/bin:$HOME/.local/bin:$PATH"' \
  >> ~/.profile
echo "source ~/.aliases" >> $HOME/.bashrc

python3 -m ensurepip --user -U
pip3 install --user -U pip dirlog libaaron requests
