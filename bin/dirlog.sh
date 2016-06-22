c() {
  local dir="$@"
  local log=~/.cache/dirlog.db
  if [[ ! -e $log ]]; then
    sqlite3 $log 'CREATE TABLE dirs(path TEXT, name TEXT, time TEXT);'
  fi

  if [[ -n $dir ]] && [[ ${dir#..} == $dir ]]; then
    local target=$(sqlite3 $log "SELECT path FROM dirs WHERE name LIKE '$dir%'
                                 ORDER BY time DESC LIMIT 1")
  fi

  if cd $dir 2> /dev/null; then
    ls
    sqlite3 $log "DELETE FROM dirs WHERE path = '$PWD';
    INSERT INTO dirs VALUES('$PWD', '$(basename $PWD)', datetime('now'))"
  elif [[ -n $target ]]; then
    sqlite3 $log "UPDATE dirs SET time = datetime('now') WHERE path = '$target'"
    cd "$target" 2> /dev/null
    ls
  else
    echo "didn't find $dir"
  fi
}
