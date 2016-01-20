" keymaps and commands
mapclear | mapclear!
let mapleader=","
command Va VoomToggle asciidoc
noremap <C-N> :NERDTreeToggle<CR>
command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
      \ | wincmd p | diffthis

" settings
for [ key, setting ] in [
      \['W', 'wrap!'], ['n', 'nu!'], ['sp', 'spell!'], ['1', 'list!']]
  exe "noremap <Leader>".key ":set" setting."<cr>"
endfor
noremap <Leader>tw :set tw=0
noremap <Leader>/ :noh<cr>

" syntax toggling
function! ToggleSyntax()
  if exists("g:syntax_on") | syntax off
  else | syntax enable | endif
endfunction
nnoremap <silent> <Leader>sx :call ToggleSyntax()<CR>

" hebrew mode toggle
function! ToggleHebrew()
  if &l:rightleft == 0
    set rightleft keymap=hebrew
  else
    set norightleft keymap=
  endif
endfunction
noremap <Leader>i :call ToggleHebrew()<cr>

" other hebrew  mode toggle
function! OtherHebrew()
  if &l:keymap != hebrew
    set keymap=hebrew
  else
    set keymap=
  endif
endfunction
noremap <Leader>h :call OtherHebrew()<cr>

" reformat
noremap <Leader>r mvgq}`v

" word count
noremap <Leader>c g
noremap <Leader>C :set ic!<CR>

vnoremap # :s/^/#/<CR>:noh<cr>

" saving and quitting
for key in ['w', 'q', 'x']
  exe "noremap <Leader>".key ":".key."<CR>" | endfor

" filetypes
for [ key, ft ] in [
      \['a', 'asciidoc'], ['p', 'python'], ['s', 'sh'], ['v', 'vim'],
      \['js', 'javascript']]
  exe "noremap <Leader>f".key ":set filetype=".ft "<CR>"
endfor

" Window management
for key in [ "h", "j", "k", "l", "H", "J", "K", "L" ]
  exe "noremap <Leader>".key "".key | endfor

function! Vs()
  vs
  exe "vertical resize" (&textwidth + 5)
  winc l
endfunction
noremap <Leader>vs :call Vs()<CR>

noremap j gj
noremap k gk

" get ya some output from shell commands
nnoremap <Leader>sh :.!sh<CR>
vnoremap <Leader>sh dmvo<Esc>p:.!sh<CR>0d$`vPjdd`v
nnoremap <Leader>py :.!python<CR>
vnoremap <Leader>py :!python<CR>

" function GB(verse)
"   exe "r! diatheke -b 2TGreek -o a -k" a:verse
" endfunction

command -nargs=* GB r!diatheke -b 2TGreek -o a -k <args>
inoremap <leader>gb <space><Esc>"ad2Bmv:GB <C-R>a<CR>dd0d$`vi<C-R>"

command -nargs=* HB r!diatheke -b OSMHB -o cv -k <args>
inoremap <leader>hb <space><Esc>"ad2Bmv:HB <C-R>a<CR>dd0d$`vi<C-R>"

" close brackets, braces and parentheses when the opening character is followed
" by a new line.
for [opener, closer] in [['[', ']'], ['{', '}'], ['(', ')']]
  exec "inoremap" opener."" opener."".closer."O"
endfor
