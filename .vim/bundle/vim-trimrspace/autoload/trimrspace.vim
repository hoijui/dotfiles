let s:save_cpo = &cpo
set cpo&vim

function! trimrspace#exec()
  let ext = expand('%:p:e')
  if s:is_target(ext)
    execute '%s/\s\+$//e'
  endif
endfunction

function! s:is_target(ext)
  let search = a:ext
  let m = g:trimrspace_method
  let t = copy(g:trimrspace_targets)
  if m == 'filetype' || m == 'ignore_filetype'
    let search = &filetype
  endif
  let found = len(filter(t, 'v:val =~# search')) > 0
  if m == 'ignore_exts' || m == 'ignore_filetype'
    return !found
  endif
  return found
endfunction

let &cpo = s:save_cpo
