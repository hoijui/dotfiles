" scriptencoding utf-8
" vim:fdm=marker sw=2 ts=2 ft=vim expandtab:
let s:save_cpo = &cpo
set cpo&vim

setlocal comments=:;
setlocal commentstring=;%s

let &cpo = s:save_cpo
