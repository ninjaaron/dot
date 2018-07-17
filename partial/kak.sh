#!/usr/bin/env bash
top_dir="$HOME/.config/kak"
rm -r "$top_dir"
cd kak
for dir in "autoload" "colors"; do
  mkdir -p "$top_dir/$dir"
  [ "$dir" = "autoload" ] && ln -s /usr/share/kak/autoload/ "$top_dir/$dir"
  pushd "$dir"
  for file in *.kak; do
    find "$top_dir/$dir" -name "$file" -exec rm {} \;
    ln -s "$PWD/$file" "$top_dir/$dir/$file"
  done
  popd
done

[ -e kakrc ] && ln -sr kakrc "$top_dir"
