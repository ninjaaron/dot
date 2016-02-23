set tw=80
function! Snippits()
  if g:SnipOn == 1
    unab if
    unab for
    unab while
    unab fun!
    let g:SnipOn = 0
  else
    norea if if@@endif?@@2s
    norea for for@@ inendfor?@@2s
    norea while while@@endwhile?@@2s
    norea fun! function!@@()endfunction?@@2s
    let g:SnipOn = 1
  endif
endfunction

let g:SnipOn = 0
noremap <Leader>sn :call Snippits()<CR>
