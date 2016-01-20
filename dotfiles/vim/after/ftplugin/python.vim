set tabstop=4 shiftwidth=4 tw=79

norea #! #!/usr/bin/env python3

nnoremap <F5> :w<CR>:!python % 2> /tmp/pyerr > /tmp/pyout; cat /tmp/pyerr >> 
              \/tmp/pyout<CR>:10new /tmp/pyout<CR>
vnoremap <F5> :!python 2> /tmp/pyerr > /tmp/pyout; cat /tmp/pyerr >>
              \/tmp/pyout<CR>:10new /tmp/pyout<CR><C-W>ju<C-W>k
