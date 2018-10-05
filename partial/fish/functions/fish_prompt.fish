function fish_prompt
  # base
  set nc (set_color normal)
  set div $nc "|"

  # system updates
  set updates (b2x < ~/.updates ^ /dev/null)
  if [ "$updates" != 00 ]
    echo -ns (set_color yellow) $updates $div
  end

  # git branches status
  set branch (git branch ^ /dev/null | fgrep '*' | sed 's/\* //')
  if [ "$branch" ]
    set gitstatus (git status -s ^ /dev/null)
    if [ "$gitstatus" ]
      set color (set_color red)
    else
      set color (set_color green)
    end
    echo -ns $color $branch $div
  end

  # working directory
  echo -ns (set_color blue) (prompt_pwd) $nc "> "
end
