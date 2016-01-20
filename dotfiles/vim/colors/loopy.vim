" Vim color file

hi clear
if exists("syntax_on")
  syntax reset
endif

let colors_name = "default"

" Colors for syntax highlighting

let s:none =    [ "none", [ "Normal",  "Visual" ],    [ "Pmenu", "VertSplit", "Visual", "StatusLine", "Folded" ]]
let s:black =       [ 0,  [ "LineNr", "VertSplit" ],  [ "CursorLineNr", "Visual", "PmenuSel" ]]
let s:red =         [ 1,  [ "Error", "Type", "Delimiter" ]]
let s:green =       [ 2,  [ "Constant" ]]
let s:yellow  =     [ 3,  [ "Statement", "StatusLine" ]]
let s:blue =        [ 4,  [ "Conditional", "Folded" ]]
let s:magenta =     [ 5,  [ "PreProc" ]]
let s:cyan =        [ 6,  [ "Identifier", "Title", "PmenuSel" ]]
let s:lightGrey =   [ 7,  [ "Ignore", "asciidocQuotedEmphasized2" ]]
let s:darkGrey =    [ 8,  [ "Comment", "StatusLineNC" ]]
let s:white =       [ 15, [ "Special", "CursorLineNr", "Pmenu" ]]

for s:color in [ s:none, s:black, s:red, s:green, s:yellow, s:blue, s:magenta, s:cyan, s:lightGrey, s:darkGrey, s:white ]
  for s:type in s:color[1]
    exe "hi" s:type "ctermfg=".s:color[0]
  endfor
  if exists( 's:color[2]' )
    for s:type in s:color[2]
      exe "hi" s:type "ctermbg=".s:color[0]
    endfor
  endif
endfor


hi Error ctermbg=52

hi spellBad ctermbg=52 
hi spellCap ctermbg=17 

hi Ignore cterm=bold
hi Visual cterm=reverse
"hi Vertsplit cterm=none
hi asciidocQuotedEmphasized2 cterm=italic
hi CursorLine cterm=none
hi StatusLine cterm=underline
hi StatusLineNC cterm=underline
hi Search ctermbg=232 ctermfg=255 cterm=bold
