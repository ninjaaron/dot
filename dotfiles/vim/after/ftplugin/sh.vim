set tw=80
function! Snippits()
  if g:SnipOn == 1
    unab if
    unab elif
    unab for
    unab while
    unab case
    unmap [[
    unmap ((
    let g:SnipOn = 0
  else
    norea if     if [[@@ ]];thenfi?@@2s
    norea elif   elif [[@@ ]];then?@@2s
    norea for    for@@ in ;dodone?@@2s
    norea while  while [[@@ ]];dodone?@@2s
    norea case   case@@ in*);;esac?@@2s
    inoremap [[     [[]]<Left><Left>
    inoremap ((     (())<Left><Left>
    let g:SnipOn = 1
  endif
endfunction

norea #! #!/usr/bin/env bash


let g:SnipOn = 0
noremap <Leader>sn :call Snippits()<CR>
