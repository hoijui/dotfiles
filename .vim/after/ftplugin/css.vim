scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim


setl dictionary=~/.vim/dict/css.dict
setl iskeyword+=-:

let &cpo = s:save_cpo

