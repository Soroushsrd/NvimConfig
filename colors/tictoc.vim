" Vim color scheme
" Name: tictoc.vim
" Author: Andrew Donaldson <andrew@desto.net>
 
" Based on the tictoc theme for TextMate
" Distributable under the same terms as Vim itself (see :help license)
" Header thieved from tpope's 'vim-vividchalk'
" Theme considerably less complete, but works for me!

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name="tictoc"

hi	Normal	guifg=#F8F8F8	guibg=#0C1021
hi	Cursor	guifg=#F8F8F8	guibg=#465374
hi	Visual	guifg=#FFFFFF	guibg=#AA0000
hi	VertSplit	guifg=#465374
hi	StatusLine	guifg=#F8F8F8	guibg=#465374
hi	ModeMsg	guifg=#F8F8F8	guibg=#465374
hi	MBENormal	guifg=#aeaeae	guibg=#465374
hi	MBEChanged	guifg=#ff6400	guibg=#465374
hi	MBEVisibleNormal	guifg=#ffffff	guibg=#0C1021
hi	MBEVisibleChanged	guifg=#ff6400	guibg=#0C1021
hi	Folded	guifg=#ffffff guibg=#354263
hi	WildMenu	guifg=#000000 guibg=#ffffff
hi	Comment	guifg=#AEAEAE
hi	Type	guifg=#FF6400
hi	Identifier	guifg=#FF6400
hi	Error	guifg=#F8F8F8	guibg=#9D1E15
hi	Constant	guifg=#FCB439
hi	Keyword	guifg=#FBDE2D
hi	StorageClass	guifg=#FBDE2D
hi	Statement	guifg=#FBDE2D
hi	Define	guifg=#FBDE2D
hi	Include	guifg=#FBDE2D
hi	rubyDefine	guifg=#FBDE2D
hi	rubyConditional	guifg=#FBDE2D
hi	Conditional	guifg=#FBDE2D
hi	rubyRepeat	guifg=#FBDE2D
hi	String	guifg=#00C1E4
hi  Search  guifg=#ffffff guibg=#242739
hi  MatchParen guifg=#ffffff guibg=#242739

" Invisible character colours
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59
