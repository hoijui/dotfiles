scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

" setl expandtab ts=2 sw=2
" setl formatoptions-=ro
setl iskeyword+=$

" setl dictionary=~/.vim/dict/javascript.dict
" setl dictionary+=~/.vim/dict/qunit.dict
" setl dictionary+=~/.vim/dict/wsh.dict
" setl tabstop=2 shiftwidth=2 textwidth=0 expandtab

inoremap <buffer> <expr> \  smartchr#one_of('\', 'function(', '\\')
nnoremap <silent> [comment-doc] :<C-u>call JsDoc()<CR>

" for vim-syntax-js
" if has('conceal')
"   setl conceallevel=2 concealcursor=nc
" endif

let &cpo = s:save_cpo
