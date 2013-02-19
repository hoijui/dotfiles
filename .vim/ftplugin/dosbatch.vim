"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setl dictionary=~/.vim/dict/dosbatch.dict
setl noexpandtab

if &modifiable && &fileformat == 'dos'
  setl ff=dos fenc=cp932
endif

let &cpo = s:save_cpo
