fish_vi_key_bindings

function act
    set venv $argv[1]
    source $venv/bin/activate.fish
end
