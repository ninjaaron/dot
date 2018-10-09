function faz
  for func in $HOME/.config/fish/functions/*
    if test ! -L $func
      set funcs $funcs $func
    end
  end
  rm $funcs

  for i in (grep "^alias" ~/.aliases)
    set name (echo "$i" | perl -pe 's/alias ([\w-]*).*/\1/')
    eval "$i"
    funcsave $name
  end
end
