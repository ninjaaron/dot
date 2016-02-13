" Vim color file

hi clear
if exists("syntax_on")
  syntax reset
endif

let colors_name = "cterm"

" Colors for syntax highlighting
" Black
hi NonText ctermfg=0
hi ColorColumn ctermbg=0
" Dark Grey
hi Comment ctermfg=8

" Red
hi Error ctermfg=1 ctermbg=None cterm=underline
hi Type ctermfg=1
hi Function ctermfg=1
"alt

" Green
hi Constant ctermfg=2
" alt

" Yellow
hi String ctermfg=11
"alt
hi Statement ctermfg=3

" Blue
hi Delimiter ctermfg=4
hi Repeat ctermfg=4
"alt
hi Conditional ctermfg=12


" Magenta
hi PreProc ctermfg=5
"alt
hi Include ctermfg=13

" Cyan
hi Identifier ctermfg=6 cterm=none
hi pythonFunction ctermfg=6
hi Title ctermfg=6
"alt
hi Special ctermfg=14


" Light Grey
hi Ignore ctermfg=7 cterm=bold
" White
hi asciidocQuotedEmphasized2 ctermfg=15 cterm=italic


" Interface
hi StatusLine ctermfg=3 ctermbg=none cterm=underline
hi StatusLineNC ctermfg=8 cterm=underline
hi VertSplit ctermfg=8 ctermbg=none cterm=none
hi Folded ctermfg=4 ctermbg=none

hi Pmenu ctermfg=8 ctermbg=0
hi PmenuSel ctermfg=6 ctermbg=0

hi DiffAdd ctermfg=4 ctermbg=none cterm=underline
hi DiffChange ctermfg=5 ctermbg=none cterm=underline
hi DiffDelete ctermfg=12 ctermbg=none cterm=underline
hi DiffText ctermfg=9 ctermbg=none cterm=reverse

hi Visual ctermbg=none cterm=reverse
hi spellBad ctermfg=1 ctermbg=None  cterm=underline
hi spellCap ctermfg=17 ctermbg=None cterm=underline

hi LineNr ctermfg=8
hi CursorLine cterm=none
hi CursorLineNr ctermfg=15 ctermbg=none
hi Search ctermbg=None ctermfg=None cterm=reverse
hi MatchParen ctermfg=0 ctermbg=12

if filereadable('/home/ninjaaron/.vim/extra.vim')
  source $HOME/.vim/extra.vim
endif
