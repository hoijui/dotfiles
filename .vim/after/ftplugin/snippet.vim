"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

"setl tabstop=4 tw=0 sw=4 noexpandtab formatoptions-=ro
setl noexpandtab formatoptions-=ro

let &cpo = s:save_cpo
