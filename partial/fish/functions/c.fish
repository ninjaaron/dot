function c
  set dir (dirlog-cd $argv)
  if [ "$dir" != "" ]
    cd "$dir"; and ls
  end
end
