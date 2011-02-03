scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setl formatoptions-=ro
let b:match_words = &matchpairs . ',\<if\>:\<fi\>'
let b:match_words += ',\<do\>:\<done\>'
let b:match_words += ',\<case\>:\<esac\>'

let &cpo = s:save_cpo
