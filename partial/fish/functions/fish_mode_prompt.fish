function fish_mode_prompt --description 'Displays the current mode'
	# Do nothing if not in vi mode
  if set -q __fish_vi_mode
    switch $fish_bind_mode
      case default
        set_color blue
        echo '()'
      case insert
        set_color yellow
        echo '()'
      case visual
        set_color magenta
        echo '()'
    end
    set_color normal
    echo -n ''
  end
end
