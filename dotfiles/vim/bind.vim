" keymaps and commands
mapclear | mapclear!
let mapleader=" "
command Va VoomToggle asciidoc
noremap <C-N> :NERDTreeToggle<CR>
command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
      \ | wincmd p | diffthis

function! DvorakSwap()
  nnoremap t l
  nnoremap l t
endfunction
" settings
for [ key, setting ] in [
      \['W', 'wrap!'], ['n', 'nu!'], ['sp', 'spell!'], ['1', 'list!']]
  exe "nnoremap <leader>".key ":set" setting."<cr>"
endfor
nnoremap <leader>tw :set tw=0
nnoremap <leader>/ :noh<cr>

" syntax toggling
function! ToggleSyntax()
  if exists("g:syntax_on") | syntax off
  else | syntax enable | endif
endfunction
nnoremap <silent> <leader>sx :call ToggleSyntax()<CR>

" hebrew mode toggle
function! ToggleHebrew()
  if &l:rightleft == 0
    set rightleft keymap=hebrew
  else
    set norightleft keymap=
  endif
endfunction
nnoremap <leader>i :call ToggleHebrew()<cr>

" comment out blocks.
function! Comment(char) range
  exe ":norm" a:firstline."G^"
  let col = getcurpos()[4]
  for line in range(a:firstline, a:lastline)
    if getline(line) != ''
      exec ":norm" line."G".col."\|i".a:char." "
    endif
  endfor
endfunction

xnoremap + "+y
nnoremap + "+p
xnoremap # :call Comment('#')<CR>
nnoremap # ^i# <ESC>

" reformat
nnoremap <leader>r mvgq}`v

" word count
nnoremap <leader>c g
nnoremap <leader>C :set ic!<CR>
nnoremap <leader><leader> :


" saving and quitting
for key in ['w', 'q', 'x']
  exe "nnoremap <leader>".key ":".key."<CR>" | endfor

" filetypes
for [ key, ft ] in [
      \['a', 'asciidoc'], ['p', 'python'], ['s', 'sh'], ['v', 'vim'],
      \['js', 'javascript']]
  exe "nnoremap <leader>f".key ":set filetype=".ft "<CR>"
endfor

" Window management
for key in [ "h", "j", "k", "l", "H", "J", "K", "L" ]
  exe "noremap <leader>".key "".key | endfor

function! Vs()
  vs
  exe "vertical resize" (&textwidth + 5)
  winc l
endfunction
nnoremap <leader>vs :call Vs()<CR>

noremap j gj
noremap k gk

" get ya some output from shell commands
nnoremap <leader>sh :.!sh<CR>
xnoremap <leader>sh dmvo<Esc>p:.!sh<CR>0d$`vPjdd`v
nnoremap <leader>py :.!python<CR>
xnoremap <leader>py :!python<CR>
inoremap ,p <C-R>"
nnoremap <backspace> <C-u>

" integration with my pastbin
command Pb exe "!pb" &ft "%"
xnoremap <leader>b :<C-U>exe "'<,'>w !pb" &ft <CR>

function! BibleGen(mod, key)
    exe 'command -nargs=+' a:mod "let @h=system('diatheke -b" a:mod
                \"-o acv -k <args> | grep -v" a:mod "')"
    exe "inoremap ,".a:key '<space><Esc>"hd2B:'.a:mod '<C-R>h<CR>i<C-r>h'
    exe "xnoremap ,".a:key '"hd:'.a:mod '<C-R>h<CR>i<C-R>h<Esc>'
endfunction

call BibleGen('MorphGNT', 'gb')
call BibleGen('OSHB', 'hb')

" close brackets, braces and parentheses when the opening character is followed
" by a new line.
for [opener, closer] in [['[', ']'], ['{', '}'], ['(', ')']]
  exec "inoremap" opener."" opener."".closer."O"
endfor
