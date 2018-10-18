function fish_mode_prompt --description 'Displays the current mode'
	# Do nothing if not in vi mode
  if false
  # if test "$fish_key_bindings" = "fish_vi_key_bindings"
      or test "$fish_key_bindings" = "fish_hybrid_key_bindings"
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
