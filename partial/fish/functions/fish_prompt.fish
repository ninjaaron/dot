function fish_prompt
  if test "$fish_key_bindings" = "fish_vi_key_bindings" -a "$fish_bind_mode" != "insert"
    set colors brblack brblack brblack brblack brblack
  else
    set colors normal yellow red green blue
  end
  # base
  set nc (set_color $colors[1])
  set div $nc "|"

  # system updates
  set updates (cat ~/.updates 2> /dev/null | b2x)
  if [ $updates -a $updates != 00 ]
    echo -ns (set_color $colors[2]) $updates $div
  end

  # git branches status
  set branch (git branch 2> /dev/null | grep -F '*' | sed 's/\* //')
  if [ "$branch" ]
    set gitstatus (git status -s 2> /dev/null)
    if [ "$gitstatus" ]
      set color (set_color $colors[3])
    else
      set color (set_color $colors[4])
    end
    echo -ns $color $branch $div
  end

  # working directory
  echo -ns (set_color $colors[5]) (prompt_pwd) $nc "> "
end
