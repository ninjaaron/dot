#!/bin/sh
if [ -z "$PAGER" ]; then
  PAGER=less
fi

entity="$1"
shift

if [ -d "$entity" ]; then
  tree "$entity" | "$PAGER"
elif [ -f "$entity" ]; then
  less "$entity"
else
  command -v "$entity" || pyfil "$entity" 2> /dev/null ||
    { echo "could not show '$entity'" >&2 && exit 1; }
fi
