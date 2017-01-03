set tw=79 noexpandtab tabstop=4 shiftwidth=0 softtabstop=0
set listchars=tab:\ \ ,trail:·
xnoremap # :call Comment('//')<CR>
nnoremap # ^i// <ESC>

function CstyleComment() range
  if a:firstline == a:lastline
    s:^\(\s*\)\(.*\)$:\1/* \2 */:
  else
    exe ":norm" a:firstline.'G0"by^^'
    let l:col = getcurpos()[4]
    for line in range(a:firstline, a:lastline)
      if getline(line) != ''
        exec ":norm" line."G".l:col."\|i * "
      endif
    endfor
    exe ":norm" a:firstline."GO"
    norm 0D"bpA/*
    exe ":norm" a:lastline+1."Go"
    norm 0D"bpA */
  endif
endfunction
xnoremap * :call CstyleComment()<CR>
