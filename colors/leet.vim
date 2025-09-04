set background=dark


" whitespaces
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
highlight ExtraWhitespace ctermbg=cyan guibg=cyan
autocmd InsertLeave * redraw!
match ExtraWhitespace /\s\+$\| \+\ze\t/
autocmd BufWritePre * :%s/\s\+$//e
" for autoread to auto load
au focusgained,bufenter * :silent! !
au focuslost,winleave * :silent! w
set autoread
set conceallevel=2
set concealcursor=vin
set nocursorline
" cursorline
au WinLeave * set nocursorline
au WinEnter * set cursorline
set cursorline
let g:indentLine_char='|'



hi clear
if exists("syntax_on")
    syntax reset
endif
set notermguicolors
let g:colors_name="leet"

highlight Normal       term=none cterm=none ctermfg=gray           ctermbg=black
highlight NonText      term=none cterm=none ctermfg=darkred        ctermbg=black
highlight Function     term=none cterm=none ctermfg=darkcyan       ctermbg=black
highlight Statement    term=bold cterm=bold ctermfg=darkblue       ctermbg=black
highlight Special      term=none cterm=none ctermfg=red            ctermbg=black
highlight SpecialChar  term=none cterm=none ctermfg=cyan           ctermbg=black
highlight Constant     term=none cterm=none ctermfg=yellow         ctermbg=black
highlight Comment      term=none cterm=none ctermfg=darkgray       ctermbg=black
highlight Preproc      term=none cterm=none ctermfg=darkgreen      ctermbg=black
highlight Type         term=none cterm=none ctermfg=darkmagenta    ctermbg=black
highlight Identifier   term=none cterm=none ctermfg=cyan           ctermbg=black
highlight Visual       term=none cterm=none ctermfg=white          ctermbg=blue
highlight Search       term=none cterm=none ctermbg=yellow         ctermfg=darkblue
highlight Directory    term=none cterm=none ctermfg=green          ctermbg=black
highlight WarningMsg   term=none cterm=none ctermfg=blue           ctermbg=yellow
highlight Error        term=none cterm=none ctermfg=red            ctermbg=black
highlight Cursor       term=none cterm=none ctermfg=cyan           ctermbg=cyan
highlight LineNr       term=none cterm=none ctermfg=red            ctermbg=black
highlight StatusLine   term=none cterm=none ctermfg=black          ctermbg=8
highlight StatusLineNC term=none cterm=none ctermfg=black          ctermbg=8
highlight VertSplit    term=none cterm=none ctermfg=black          ctermbg=8
highlight CursorLine   term=none cterm=none ctermfg=none           ctermbg=235


hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="leet2"

highlight Normal       term=none cterm=none ctermfg=gray           ctermbg=none
highlight NonText      term=none cterm=none ctermfg=61             ctermbg=none
highlight Function     term=none cterm=none ctermfg=darkcyan       ctermbg=none
highlight Statement    term=bold cterm=bold ctermfg=darkblue       ctermbg=none
highlight Special      term=none cterm=none ctermfg=red            ctermbg=none
highlight SpecialChar  term=none cterm=none ctermfg=darkcyan       ctermbg=none
highlight Constant     term=none cterm=none ctermfg=yellow         ctermbg=none
highlight Comment      term=none cterm=none ctermfg=240            ctermbg=none
highlight Preproc      term=none cterm=none ctermfg=darkgreen      ctermbg=none
highlight Type         term=none cterm=none ctermfg=darkmagenta    ctermbg=none
highlight Identifier   term=none cterm=none ctermfg=darkcyan       ctermbg=none
highlight Visual       term=none cterm=none ctermfg=white          ctermbg=blue
highlight Search       term=none cterm=none ctermbg=yellow         ctermfg=darkblue
highlight Directory    term=none cterm=none ctermfg=green          ctermbg=none
highlight WarningMsg   term=none cterm=none ctermfg=blue           ctermbg=yellow
highlight Error        term=none cterm=none ctermfg=red            ctermbg=none
highlight Cursor       term=none cterm=none ctermfg=darkcyan       ctermbg=darkcyan
highlight LineNr       term=none cterm=none ctermfg=61             ctermbg=none
highlight StatusLine   term=none cterm=none ctermfg=grey           ctermbg=235
highlight StatusLineNC term=none cterm=none ctermfg=grey           ctermbg=235
highlight VertSplit    term=none cterm=none ctermfg=grey           ctermbg=235
highlight CursorLine   term=none cterm=none ctermfg=none           ctermbg=235
highlight ColorColumn  term=none cterm=none ctermfg=grey           ctermbg=61
highlight Pmenu        term=none cterm=none ctermfg=15             ctermbg=235
highlight PmenuSel     term=none cterm=none ctermfg=8              ctermbg=black
highlight PmenuSbar    term=none cterm=none ctermfg=8              ctermbg=15

highlight StatusLine ctermfg=white ctermbg=black guifg=white guibg=black
highlight SignColumn ctermbg=none
highlight DiffAdd ctermfg=22 ctermbg=NONE
highlight DiffDelete ctermfg=1 ctermbg=NONE
highlight DiffChange ctermfg=24 ctermbg=NONE
highlight DiffText ctermfg=17 ctermbg=NONE
