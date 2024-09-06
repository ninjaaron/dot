fish_vi_key_bindings

function act
    set venv $argv[1]
    source $venv/bin/activate.fish
end

pyenv init - | source

# opam configuration
source /home/ninjaaron/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
