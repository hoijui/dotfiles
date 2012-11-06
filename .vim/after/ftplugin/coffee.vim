scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

setl formatoptions-=ro
setl dictionary=~/.vim/dict/coffee.dict

inoremap <expr> <buffer> { smartchr#loop('{', '#{', '{{')
inoremap <buffer><expr> > smartchr#one_of('>', '->', '>>')
inoremap <buffer><expr> - smartchr#one_of('-', '->', '--')
inoremap <buffer><expr> \ smartchr#one_of('\', '->', '=>', '\\')

let &cpo = s:save_cpo
