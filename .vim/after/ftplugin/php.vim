scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

" setl formatoptions-=ro
setl formatoptions-=o
" http://hail2u.net/blog/software/only-one-line-life-changing-vimrc-setting.html
setl includeexpr=substitute(v:fname,'^\\/','','')
setl path+=;/
setl iskeyword-=$,\-,:
" setl noexpandtab

if neobundle#is_installed('php-doc')
  nnoremap <buffer> <silent> [comment-doc] :call PhpDocSingle()<CR>
  " inoremap <buffer> <silent> [comment-doc] <Esc>:call PhpDocSingle()<CR>i
  vnoremap <buffer> <silent> [comment-doc] :call PhpDocSingle()<CR>
elseif neobundle#is_installed('PIV')
  nnoremap <buffer> <silent> [comment-doc] :call PhpDocSingle()<CR>
  vnoremap <buffer> <silent> [comment-doc] :call PhpDocRange()<CR>
endif

if exists(':EnableFastPHPFolds')
  function! s:folding()
    exe "EnableFastPHPFolds"
    redraw!
  endfunction
  nnoremap <buffer> <silent> zz :call <SID>folding()<CR>
endif


if neobundle#is_installed('PIV') && neobundle#is_installed('neocomplcache')
  inoremap <buffer><expr><C-h>  neocomplcache#smart_close_popup()."\<C-h>"
endif
inoremap <buffer><expr> [ smartchr#one_of('[', 'array(', '[[')
inoremap <buffer><expr> ] smartchr#one_of(']', ')', ']]')
inoremap <buffer><expr> \ smartchr#one_of('\', 'function', '\\')
inoremap <buffer><expr> @ smartchr#one_of('@', '$this->', 'self::$', '@@')
inoremap <buffer><expr> . smartchr#one_of('.', '->', '..')
inoremap <buffer><expr> > smartchr#one_of('>', '=>', '>>')

let &cpo = s:save_cpo
