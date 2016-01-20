" Vim color file
"
" Author: Tomas Restrepo <tomas@winterdom.com>
"
" Note: Based on the monokai theme for textmate
" by Wimer Hazenberg and its darker variant 
" by Hamish Stuart Macpherson
"

hi clear

" Support for 256-color terminal
"
if &t_Co > 255
   hi Boolean         ctermfg=5
   hi Character       ctermfg=15
   hi Number          ctermfg=5
   hi String          ctermfg=15
   hi Conditional     ctermfg=1                 cterm=bold
   hi Constant        ctermfg=5               cterm=bold
   hi Cursor          ctermfg=16  ctermbg=253
   hi Debug           ctermfg=225               cterm=bold
   hi Define          ctermfg=6
   hi Delimiter       ctermfg=241

   hi DiffAdd                     ctermbg=24
   hi DiffChange      ctermfg=16  ctermbg=7
   hi DiffDelete      ctermfg=162 ctermbg=53
   hi DiffText                    ctermbg=102 cterm=bold

   hi Directory       ctermfg=2               cterm=bold
   hi Error           ctermfg=125 ctermbg=233
   hi ErrorMsg        ctermfg=199 ctermbg=16    cterm=bold
   hi Exception       ctermfg=2               cterm=bold
   hi Float           ctermfg=5
   hi FoldColumn      ctermfg=67  ctermbg=16
   hi Folded          ctermfg=67  ctermbg=16
   hi Function        ctermfg=2
   hi Identifier      ctermfg=3
   hi Ignore          ctermfg=244 ctermbg=232
   hi IncSearch       ctermfg=193 ctermbg=16

   hi Keyword         ctermfg=1               cterm=bold
   hi Label           ctermfg=229               cterm=none
   hi Macro           ctermfg=193
   hi SpecialKey      ctermfg=6

   hi MatchParen      ctermfg=16  ctermbg=3 cterm=bold
   hi ModeMsg         ctermfg=229
   hi MoreMsg         ctermfg=229
   hi Operator        ctermfg=1

   " complete menu
   hi Pmenu           ctermfg=6   ctermbg=16
   hi PmenuSel                    ctermbg=244
   hi PmenuSbar                   ctermbg=232
   hi PmenuThumb      ctermfg=6

   hi PreCondit       ctermfg=2               cterm=bold
   hi PreProc         ctermfg=2
   hi Question        ctermfg=6
   hi Repeat          ctermfg=1               cterm=bold
   hi Search          ctermfg=253 ctermbg=66

   " marks column
   hi SignColumn      ctermfg=2 ctermbg=8
   hi SpecialChar     ctermfg=1               cterm=bold
   hi SpecialComment  ctermfg=245               cterm=bold
   hi Special         ctermfg=6               cterm=italic
   if has("spell")
     hi SpellBad                  ctermbg=52   
     hi SpellCap                  ctermbg=17   
   endif
   hi Statement       ctermfg=1                 cterm=none
   hi StatusLine      ctermfg=253 ctermbg=7     cterm=bold
   hi StatusLineNC    ctermfg=7   ctermbg=8     cterm=none
   hi StorageClass    ctermfg=3
   hi Structure       ctermfg=6
   hi Tag             ctermfg=1
   hi Title           ctermfg=203
   hi Todo            ctermfg=231 ctermbg=232   cterm=bold

   hi Typedef         ctermfg=6
   hi Type            ctermfg=6                cterm=none
   hi Underlined      ctermfg=244               cterm=underline

   hi VertSplit       ctermfg=7   ctermbg=8   cterm=none
   hi VisualNOS                   ctermbg=238
   hi Visual                      ctermbg=238
   hi WarningMsg      ctermfg=231 ctermbg=238   cterm=bold
   hi WildMenu        ctermfg=6   ctermbg=16

   hi Comment         ctermfg=244
   hi cursorline                  ctermbg=none   cterm=none
   hi CursorColumn                ctermbg=8   cterm=none
   hi CursorLineNr    ctermfg=15           
   hi LineNr          ctermfg=7   ctermbg=8
   hi NonText         ctermfg=7
   hi SpecialKey      ctermfg=7
end
