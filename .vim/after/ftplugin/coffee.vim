scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

setl formatoptions-=r formatoptions-=o
" setl dictionary=~/.vim/dict/coffee.dict
" setl tabstop=2 shiftwidth=2 textwidth=0 expandtab

if get(g:vimrc_enabled_plugins, 'smartchr', 0)
  inoremap <expr> <buffer> { smartchr#loop('{', '#{', '{{')
  inoremap <buffer><expr> > synchat#isnt_src()?'>':smartchr#one_of('>', '->', '>>')
  inoremap <buffer><expr> - synchat#isnt_src()?'-':smartchr#one_of('-', '->', '--')
  inoremap <buffer><expr> \ synchat#isnt_src()?'\':smartchr#one_of('\', '->', '=>', '\\')
  inoremap <buffer><expr> . synchat#isnt_src()?'.':smartchr#one_of('.', '->', '..')
  inoremap <expr><buffer> #
    \ synchat#is('coffeeString\|coffeeInterporation\|coffeeInterporationDelimiter')
    \ ? smartchr#loop('#', '#{', '##') : '#'
  " inoremap <buffer><expr> ) synchat#isnt_src()?'\':smartchr#one_of(')', ') ->', '))')
endif

let &cpo = s:save_cpo
