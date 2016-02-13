setlocal foldmethod=marker tw=72

inoremap \|=<TAB> // {{{<CR>// }}}O\|===yypO\|
inoremap h= yypVr=
inoremap {{{ // {{{<CR>// }}}O
nnoremap <leader>a :w<cr>:!asciidoctor %<cr><cr>
xnoremap <leader>h di[heb]#"#
xnoremap <leader>r di[rtl]#"#
