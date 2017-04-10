function faz
  for i in (grep "^alias" ~/.aliases)
    set name (echo "$i" | perl -pe 's/alias ([\w-]*).*/\1/')
    eval "$i"
    funcsave $name
  end
end
