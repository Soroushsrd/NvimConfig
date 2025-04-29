hi clear

if exists("syntax_on")
  syntax reset
endif

" name of colorscheme.
let g:colors_name = "memoonry"

" helper for extracting hex's as variables.
function! s:hi(pairs) abort
  if has_key(a:pairs, 'link')
    let l:format = 'hi link %s %s'
    execute call('printf', [l:format] + a:pairs['link'])
    return
  endif
  if has_key(a:pairs, 'link!')
    let l:format = 'hi! link %s %s'
    execute call('printf', [l:format] + a:pairs['link!'])
    return
  endif
  let l:format = printf('hi %s', a:pairs['hl_group'])
  unlet a:pairs['hl_group']
  for key in keys(a:pairs)
    let l:format = l:format . printf(' %s=%s', key, a:pairs[key])
  endfor
  execute l:format
endfunction

" semantic color palette.
let s:cp = {}
let s:clear = 'NONE'
let s:cp.main_bg = '#151c30' | let s:cp.winbar = '#1b233d'
let s:cp.md_text = '#b3b3b3'
let s:cp.type = '#a3a3cc' | let s:cp.function = '#cccca3'
let s:cp.call_and_index = '#737373'
let s:cp.var_name = '#e6e6e6'
let s:cp.if_else = '#6b7a99'
let s:cp.hl_pair = '#9ef01a'
let s:cp.string = '#d0dbd0'
let s:cp.constant_and_bool = '#ffae57'
let s:cp.comment = '#686858'
let s:cp.visual_mode = '#373f52'
let s:cp.table_field = '#708c8c'
let s:cp.inlay_hint = '#505050'
let s:cp.vim_fn_input = s:cp.type

" buffer.
call s:hi({ 'hl_group': 'Normal', 'guifg': s:cp.md_text, 'guibg': s:cp.main_bg })
call s:hi({ 'hl_group': 'NormalFloat', 'ctermbg': s:clear, 'guibg': s:clear })
call s:hi({ 'hl_group': 'Type', 'guifg': s:cp.type })
call s:hi({ 'link!': [ 'Tag', 'Type' ] })
call s:hi({ 'hl_group': 'Identifier', 'guifg': s:cp.var_name })
call s:hi({ 'hl_group': 'String', 'guifg': s:cp.string })
call s:hi({ 'hl_group': 'Constant', 'guifg': s:cp.constant_and_bool })
call s:hi({ 'link!': [ 'Operator', 'Constant' ] })
call s:hi({ 'link!': [ 'Question', 'Constant' ] })
call s:hi({ 'hl_group': 'Keyword', 'guifg': s:cp.if_else })
call s:hi({ 'link!': [ 'Special', 'Keyword' ] })
call s:hi({ 'link!': [ 'Directory', 'Keyword' ] })
call s:hi({ 'hl_group': 'PreProc', 'guifg': '#7c8692' })
call s:hi({ 'hl_group': 'Include', 'guifg': '#7c8692' })
call s:hi({ 'hl_group': 'Function', 'guifg': s:cp.function })
call s:hi({ 'hl_group': 'Statement', 'guifg': s:cp.if_else })
call s:hi({ 'hl_group': 'Conditional', 'guifg': s:cp.if_else })
call s:hi({ 'hl_group': 'Repeat', 'guifg': s:cp.if_else })
call s:hi({ 'hl_group': 'Delimiter', 'guifg': s:cp.call_and_index })
call s:hi({ 'hl_group': 'MatchParen', 'guifg': s:cp.hl_pair, 'guibg': s:clear })
call s:hi({ 'hl_group': 'Comment', 'guifg': s:cp.comment })
call s:hi({ 'hl_group': 'Comment', 'gui': 'italic' })
call s:hi({ 'hl_group': 'Todo', 'guifg': '#111418' })
call s:hi({ 'hl_group': 'Ignore', 'ctermfg': 'Black', 'guifg': 'bg' })
call s:hi({ 'hl_group': 'Underlined', 'guifg': '657779', 'cterm': 'underline', 'gui': 'underline' })
call s:hi({ 'hl_group': 'Title', 'guifg': '#cfdbd5' })

" editor.
call s:hi({ 'hl_group': 'Cursor', 'guifg': 'bg', 'guibg': 'fg' })
call s:hi({ 'hl_group': 'lCursor', 'guifg': 'bg', 'guibg': 'fg' })
call s:hi({ 'hl_group': 'TermCursor', 'cterm': 'reverse', 'gui': 'reverse' })
call s:hi({ 'hl_group': 'Visual', 'guibg': s:cp.visual_mode })
call s:hi({ 'hl_group': 'Search', 'guifg': 'fg', 'guibg': 'bg' })
call s:hi({ 'hl_group': 'Search', 'gui': 'reverse' })
call s:hi({ 'hl_group': 'IncSearch', 'guifg': 'bg', 'guibg': '#fdffb6' })
call s:hi({ 'hl_group': 'IncSearch', 'gui': s:clear })
call s:hi({ 'hl_group': 'SignColumn', 'guibg': s:clear })
call s:hi({ 'hl_group': 'LineNr', 'guifg': s:cp.comment })
call s:hi({ 'hl_group': 'CursorLineNr', 'guifg': '#303f4e' })
call s:hi({ 'hl_group': 'CursorLine', 'guibg': '#1f252c' })
call s:hi({ 'hl_group': 'ColorColumn', 'guibg': '#2a2d2e' })
call s:hi({ 'hl_group': 'Folded', 'guifg': 'fg', 'guibg': '#003554' })
call s:hi({ 'hl_group': 'Folded', 'cterm': 'italic', 'gui': 'italic' })
call s:hi({ 'hl_group': 'Conceal', 'guifg': '#657779' })
call s:hi({ 'hl_group': 'DiffAdd', 'guibg': '#00182e', 'cterm': 'reverse' })
call s:hi({ 'hl_group': 'DiffChange', 'guifg': '#271302', 'cterm': 'reverse' })
call s:hi({ 'hl_group': 'DiffDelete', 'guifg': 'fg', 'guibg': '#2e0300', 'cterm': 'reverse' })
call s:hi({ 'hl_group': 'DiffText', 'guifg': 'fg', 'guibg': '#401f03', 'cterm': 'reverse' })
call s:hi({ 'hl_group': 'EndOfBuffer', 'guifg': '#403d39' })
call s:hi({ 'hl_group': 'ModeMsg', 'cterm': 'bold', 'gui': 'bold' })
call s:hi({ 'hl_group': 'StatusLine', 'guifg': '#2d3540' })
call s:hi({ 'hl_group': 'StatusLineNC', 'guifg': '#2d3540' })
call s:hi({ 'hl_group': 'Pmenu', 'guifg': '#808080', 'guibg': '#2d3540' })
call s:hi({ 'hl_group': 'PmenuSel', 'guifg': '#2d3540', 'guibg': '#657779' })
call s:hi({ 'hl_group': 'PmenuSel', 'cterm': 'bold', 'gui': 'bold' })
call s:hi({ 'hl_group': 'PmenuSbar', 'guibg': '#2d3540' })
call s:hi({ 'hl_group': 'PmenuThumb', 'guibg': '#4a5768' })
call s:hi({ 'hl_group': 'WildMenu', 'guifg': '#657779', 'guibg': '#2d3540' })
call s:hi({ 'hl_group': 'WildMenu', 'cterm': 'bold', 'gui': 'bold' })
call s:hi({ 'hl_group': 'TabLine', 'guifg': '#75797a' })
call s:hi({ 'hl_group': 'TabLineSel', 'guifg': '#cfdbd5', 'guibg': 'bg' })
call s:hi({ 'hl_group': 'TabLineFill', 'guifg': '#4a5768' })
call s:hi({ 'hl_group': 'WinBar', 'guifg': 'White', 'guibg': s:cp.winbar })
call s:hi({ 'hl_group': 'WinSeparator', 'guifg': '#3c4654' })
call s:hi({ 'hl_group': 'FloatBorder', 'guifg': '#989898' })
call s:hi({ 'hl_group': 'FloatShadow', 'guibg': 'Black' })
call s:hi({ 'hl_group': 'FloatShadow', 'blend': '65' })
call s:hi({ 'hl_group': 'FloatShadowThrough', 'guibg': 'Black' })
call s:hi({ 'hl_group': 'FloatShadowThrough', 'blend': '100' })
call s:hi({ 'hl_group': 'MoreMsg', 'guifg': '#303f4e' })
call s:hi({ 'hl_group': 'WarningMsg', 'guifg': '#fc735d' })
call s:hi({ 'hl_group': 'DiagnosticInfo', 'guifg': s:cp.vim_fn_input })

" treesitter (lsp fallback).
call s:hi({ 'hl_group': '@property', 'guifg': s:cp.table_field })
call s:hi({ 'hl_group': '@text.strong', 'cterm': 'bold', 'gui': 'bold' })
call s:hi({ 'hl_group': '@text.emphasis', 'cterm': 'italic', 'gui': 'italic' })

" lsp specials.
call s:hi({ 'hl_group': 'LspInlayHint', 'guifg': s:cp.inlay_hint, 'guibg': s:clear })
