scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

" setl expandtab ts=2 sw=2
" setl formatoptions-=r,o
setl formatoptions-=r formatoptions-=o
setl iskeyword+=$,-
setl iskeyword-=:

" setl dictionary=~/.vim/dict/javascript.dict
" setl dictionary+=~/.vim/dict/qunit.dict
" setl dictionary+=~/.vim/dict/wsh.dict
" setl tabstop=2 shiftwidth=2 textwidth=0 expandtab

if get(g:vimrc_enabled_plugins, 'smartchr', 0)
  inoremap <buffer> <expr> \  synchat#isnt_src()?'\':smartchr#one_of('\', 'function(', '\\')
  inoremap <buffer><expr> @ synchat#isnt_src()?'@':smartchr#one_of('@', 'this.', '@@')
  nmap <silent> [!comment-doc] <Plug>(jsdoc)
endif

" for vim-syntax-js
" if has('conceal')
"   setl conceallevel=2 concealcursor=nc
" endif

let &cpo = s:save_cpo
