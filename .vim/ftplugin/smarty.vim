"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal comments=s1:{*,ex:*}
if search('<\(div\|body\|html\|head\|script\|span\|p\|ul\|ol\|li\)', 'cnw')
  setlocal commentstring={*<!--%s-->*}
else
  setlocal commentstring={*%s*}
endif

let &cpo = s:save_cpo
