"                                 ___           ___           ___
"      ___            ___        /  /\         /  /\         /  /\
"     /  /\          /__/\      /  /::|       /  /::\       /  /::\
"    /  /:/          \__\:\    /  /:|:|      /  /:/\:\     /  /:/\:\
"   /  /:/           /  /::\  /  /:/|:|__   /  /::\ \:\   /  /:/  \:\
"  /__/:/  ___    __/  /:/\/ /__/:/_|::::\ /__/:/\:\_\:\ /__/:/ \  \:\
"  |  |:| /  /\  /__/\/:/~~  \__\/  /~~/:/ \__\/~|::\/:/ \  \:\  \__\/
"  |  |:|/  /:/  \  \::/           /  /:/     |  |:|::/   \  \:\
"  |__|:|__/:/    \  \:\          /  /:/      |  |:|\/     \  \:\
"   \__\::::/      \__\/         /__/:/       |__|:|~       \  \:\
"       ~~~~                     \__\/         \__\|         \__\/
" init setup {{{1
let $VIM_CACHE = $HOME . '/.cache'

" defun macros {{{2
augroup vimrc-myautocmd
  autocmd!
augroup END
command! -bang -nargs=* MyAutoCmd autocmd<bang> vimrc-myautocmd <args>
command! -nargs=* Lazy autocmd vimrc-myautocmd VimEnter * <args>


if v:version > 703 || (v:version == 703 && has('patch970'))
  " Lazy set regexpengine=0
  command! -nargs=0 RegexpEngineNFA set regexpengine=0
  command! -nargs=0 RegexpEngineOLD set regexpengine=1
endif

" platform detection {{{2
let s:is_win = has('win16') || has('win32') || has('win64')
let s:is_mac = has('mac') || has('macunix') || has('gui_mac') || has('gui_macvim')
" || (executable('uname') && system('uname') =~? '^darwin')
let s:type_s = type('')
let s:type_a = type([])
let s:type_h = type({})

function! s:nop(...) "{{{3
endfunction

function! s:SID() "{{{3
    return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction

function! s:path_push(...) "{{{3
  let sep = s:is_win && !has('cygwin') ? ';' : ':'
  let pathes = s:is_win ? map(copy(a:000), 'substitute(v:val, "/", "\\", "g")') : a:000
  let $PATH .= sep . join(pathes, sep)
endfunction

function! s:mkdir(path) "{{{3
  if !isdirectory(a:path)
    call mkdir(a:path, "p")
  endif
endfunction

function! s:mkvars(names, val) "{{{3
  let val = type(a:val) == s:type_s ? string(a:val) : a:val
  let names = type(a:names) == s:type_a ? a:names : [a:names]
  for name in a:names
    if !exists(name)
      silent execute 'let' name '=' val
    endif
  endfor
endfunction


if !has('vim_starting')
  let s:restore_setlocal=join(['setlocal sw=', &sw, ' tw=', &tw, ' sts=', &sts, (&et ? '' : 'no').'expandtab'], ' ')
endif

" reset settings & restore runtimepath {{{2
" let s:configured_runtimepath = &runtimepath
set all&

set runtimepath^=$HOME/.vim
set runtimepath+=$HOME/.vim/after

" reset os env {{{2
if s:is_win
  if !exists('$VCVARSALL')
    let s:save_ssl = &shellslash
    set noshellslash
    if exists('$VS120COMNTOOLS')
      let $VCVARSALL = shellescape($VS120COMNTOOLS . '..\..\VC\vcvarsall.bat')
    elseif exists('$VS110COMNTOOLS')
      let $VCVARSALL = shellescape($VS110COMNTOOLS . '..\..\VC\vcvarsall.bat')
    elseif exists('$VS100COMNTOOLS')
      let $VCVARSALL = shellescape($VS100COMNTOOLS . '..\..\VC\vcvarsall.bat')
    elseif exists('$VS90COMNTOOLS')
      let $VCVARSALL = shellescape($VS90COMNTOOLS  . '..\..\VC\vcvarsall.bat')
    elseif exists('$VS80COMNTOOLS')
      let $VCVARSALL = shellescape($VS80COMNTOOLS  . '..\..\VC\vcvarsall.bat')
    endif
  let &shellslash = s:save_ssl
  unlet s:save_ssl
  endif
  let $HOME=substitute($HOME, '\\', '/', 'ge')
  function! s:cmd_init()
    set shell=$COMSPEC
    set shellcmdflag=/c
    set shellpipe=>%s\ 2>&1
    set shellxquote=\"
  endfunction
  command! -nargs=0 CmdEnable call s:cmd_init()

  function! s:nyacus_init()
    " Use NYAOS.
    set shell=nyacus.exe
    set shellcmdflag=-e
    if executable('tee') | set shellpipe=\|&\ tee | endif
    set shellredir=>%s\ 2>&1
    set shellxquote=\"
  endfunction
  command! -nargs=0 NyacusEnable call s:nyacus_init()

  function! s:sh_init()
    set shell=bash.exe
    set shellcmdflag=--login\ -c
    if executable('tee') | set shellpipe=\|&\ tee | endif
    set shellredir=>%s\ 2>&1
    set shellxquote=\"
  endfunction
  command! -nargs=0 ShEnable call s:sh_init()

  " if !empty($MSYSTEM)
  " if executable('nyacus')
  call s:cmd_init()
else
  let $PAGER='less'
  " if s:is_mac && has('macvim')
  "   let $RUBY_DLL = "/usr/local/lib/libruby.1.8.dylib"
  "   let $PYTHON_DLL = "/usr/local/lib/libpython2.7.dylib"
  "   if executable('/usr/local/Frameworks/Python.framework/Versions/3.3/Python')
  "     let $PYTHON3_DLL='/usr/local/Frameworks/Python.framework/Versions/3.3/Python'
  "   endif
  " endif
endif

" basic settings {{{1
" 文字コード周り {{{2
if s:is_win && (!has('win32unix'))
  set encoding=cp932
  set termencoding=cp932
else
  set encoding=utf-8
  set termencoding=utf-8
endif
scriptencoding utf-8
set fileencoding=utf-8
set fileformat=unix
set fileencodings=ucs-bom,utf-8,iso-2022-jp,euc-jp,cp932
set fileformats=unix,dos,mac
set synmaxcol=1500


set display=lastline
set clipboard=unnamed
if has('unnamedplus')
  set clipboard+=unnamedplus
endif

set nospell
if v:version > 704 || (v:version == 704 && has('patch088'))
  set spelllang=en_us,cjk
else
  set spelllang=en_us
endif
set spellfile=~/.vim/spell/spellfile.utf-8.add
set noautochdir
set shellslash
set directory=$VIM_CACHE,/var/tmp,/tmp
set viminfo& viminfo+=!
set viminfo+=n$VIM_CACHE/viminfo.txt
call s:mkdir($VIM_CACHE)

" IME の設定 {{{2
if has('kaoriya') | set iminsert=0 imsearch=0 | endif

MyAutoCmd BufEnter,BufRead * call <SID>autochdir()
if !exists('g:my_lcd_autochdir')
  let g:my_lcd_autochdir = 1
endif

function! s:find_proj_dir() "{{{3
  if isdirectory(expand('%:p')) | return '' | endif
  let cdir = expand('%:p:h')
  let pjdir = ''
  if cdir == '' || !isdirectory(cdir) | return '' | endif
  "if stridx(cdir, '/.vim/') > 0 | return cdir | endif
  for d in ['.git', '.bzr', '.hg']
    let d = finddir(d, cdir . ';')
    if d != ''
      let pjdir = fnamemodify(d, ':p:h:h')
      break
    endif
  endfor
  if pjdir == ''
    for f in ['build.xml', 'pom.xml', 'prj.el',
          \ '.project', '.settings',
          \ 'Gruntfile.js', 'Jakefile', 'Cakefile',
          \ 'tiapp.xml', 'NAnt.build',
          \ 'Makefile', 'Rakefile',
          \ 'Gemfile', 'cpanfile',
          \ 'configure', 'tags', 'gtags',
          \ ]
      let f = findfile(f, cdir . ';')
      if f != ''
        let pjdir = fnamemodify(f, ':p:h')
        break
      endif
    endfor
  endif
  if pjdir == ''
    for d in ['src', 'lib', 'vendor', 'app']
      let d = finddir(d, cdir . ';')
      if d != ''
        let pjdir = fnamemodify(d, ':p:h:h')
        break
      endif
    endfor
  endif

  if pjdir != '' && isdirectory(pjdir)
    return pjdir
  endif
  return cdir
endfunction

function! s:autochdir() "{{{3
  if expand('%') == '' && &buftype =~ 'nofile'
  " if (&filetype == "vimfiler" || &filetype == "unite" || &filetype == "vimshell"
  "       \ || &filetype == "quickrun" )
    return
  elseif g:my_lcd_autochdir
    if !exists('b:my_lcd_current_or_prj_dir')
      let b:my_lcd_current_or_prj_dir = s:find_proj_dir()
    endif
    if b:my_lcd_current_or_prj_dir != '' && isdirectory(b:my_lcd_current_or_prj_dir)
      execute 'lcd' fnameescape(b:my_lcd_current_or_prj_dir)
    endif
  endif
endfunction

" diff {{{2
set diffopt& diffopt-=filler diffopt+=iwhite

" 表示周り {{{2
set lazyredraw ttyfast
set scrolloff=10000000         " 中央に表示
set sidescrolloff=999
set number                     " 行番号の表示
set ruler

set mouse=nch                  " use mouse normal/command/help
" set mouse=a
" set mouse=nv
set nomousefocus
set mousehide
set timeoutlen=1000
set ttimeoutlen=50

set showmatch                  " 対応する括弧の表示
set showcmd                    " 入力中のコマンドを表示
set showfulltag
set backspace=indent,eol,start " BSでなんでも削除
set nolinebreak
set textwidth=1000
set formatoptions& formatoptions+=mM
set whichwrap=b,s,h,l,<,>,[,]  " 行頭・行末間移動を可能に
if exists('&colorcolumn') | set colorcolumn=+1 | endif
set splitbelow                 " 横分割は下に
set splitright                 " 縦分割は右に
set switchbuf=useopen          " 再利用
set title

set hidden                     " 編集中でも他のファイルを開けるように
set sidescroll=5
if s:is_mac
  set visualbell
else
  set novisualbell
endif
set noerrorbells

set guioptions& guioptions+=T guioptions-=m guioptions-=M
if !s:is_mac
  let did_install_default_menus = 1
endif
let did_install_syntax_menu = 1
set noequalalways
set langmenu=none
set helplang=ja,en
set keywordprg=":help"
set foldmethod=marker
" http://d.hatena.ne.jp/thinca/20110523/1306080318
augroup vimrc-foldmethod-expr
  autocmd!
  autocmd InsertEnter * if &l:foldmethod ==# 'expr'
  \ |   let b:foldinfo = [&l:foldmethod, &l:foldexpr]
  \ |   setlocal foldmethod=manual foldexpr=0
  \ | endif
  autocmd InsertLeave * if exists('b:foldinfo')
  \ |   let [&l:foldmethod, &l:foldexpr] = b:foldinfo
  \ |   unlet b:foldinfo
  \ | endif
augroup END

" タブ文字の設定 {{{2
set autoindent smartindent cindent  " インデント設定
set list
if s:is_mac
  set showbreak=↪
else
  " set showbreak=↓
  let &showbreak='+++ '
endif
set listchars=tab:^\ ,trail:~,nbsp:%,extends:>,precedes:<
set smarttab             " インテリジェンスなタブ入力
set noexpandtab
"set softtabstop=4 tabstop=4 shiftwidth=4
set softtabstop=0 tabstop=4 shiftwidth=4

if exists('&ambiwidth')
  set ambiwidth=double
endif " }}}

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

"set wm=2
set nowrap     " 折り返しなし
set nrformats-=octal
set updatetime=200
if has('winaltkeys')
  set winaltkeys=no
endif
set modeline
set modelines=10

" 検索周り {{{2
set ignorecase smartcase       " 賢い検索
set incsearch                  " インクメンタル
set wrapscan                   " 検索で最初にもどる
set hlsearch                   " 検索で色
set virtualedit+=block         " 矩形の virtualedit 許可

" バックアップ {{{2
set nobackup               " バックアップとか自分で
"set backup
set noswapfile
set nowritebackup
set autoread                   " 更新があったファイルを自動で読み直し
set backupcopy=yes
set backupskip=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*.tmp,crontab.*
set backupdir=$VIM_CACHE/vim-backups
set viewdir=$VIM_CACHE/vim-views
call s:mkdir(&backupdir)
call s:mkdir(&viewdir)
if has('persistent_undo')
  set undodir=$VIM_CACHE/vim-undo
  call s:mkdir(&undodir)
  set undofile
endif


" 補完 {{{2
set wildmenu                                 " 補完候補を表示する
set wildmode=list:longest,list:full          " zsh like complete
set wildchar=<tab>
set wildignore+=*.o,*.obj,.git,*.rbc,.class,.svn
set wildignore+=*DS_Store*,*.png,*.jpg,*.gif
set wildignore+=*.so,*.swp,*.pdf,*.dmg
set wildignore+=*.luac,*.jar,*.pyc,*.stats
set completeopt=menuone
set complete=.,w,b,u,t,i,k

" for migemo {{{2
if has('kaoriya') && has('migemo')
  set migemo
  if filereadable('/usr/local/share/migemo/utf-8/migemo-dict')
    set migemodict=/usr/local/share/migemo/utf-8/migemo-dict
  endif
elseif executable('cmigemo')
  nnoremap <silent> g/ :Mi<CR>
endif

" color settings "{{{1
"set t_Co=256
set background=dark

function! s:highlights_add() "{{{2
  " for unite.vim
  " highlight StatusLine gui=none guifg=black guibg=lightgreen cterm=none ctermfg=black ctermbg=lightgreen

  highlight MatchParen ctermbg=cyan ctermfg=darkred guibg=cyan guifg=darkred

  highlight NonText term=underline ctermfg=darkgray guifg=darkgray
  highlight SpecialKey term=underline ctermfg=darkgray guifg=darkgray
  " highlight link IdeographicSpace Error
  highlight IdeographicSpace term=underline ctermbg=darkgreen guibg=darkgreen
  " highlight link TrailingSpaces Error
  highlight TrailingSpaces ctermbg=darkgray guibg=#222222
  " highlight clear CursorLine
  " highlight CursorLine gui=underline term=underline cterm=underline
  " highlight CursorLine ctermbg=black guibg=black
  highlight link VimShellError WarningMsg
  highlight qf_error_ucurl term=underline cterm=underline ctermfg=darkred ctermbg=none gui=undercurl guisp=red
  " http://qiita.com/kenjiskywalker/items/6ccaf6fb8f1f139230e6
  if has('gui_running') && (has('multi_byte_ime') || has('xim'))
    " highlight Cursor guifg=NONE guibg=White
    highlight CursorIM guifg=NONE guibg=DarkRed
  endif
endfunction

function! s:syntaxes_add() "{{{2
  syntax match IdeographicSpace /　/ display containedin=ALL
  syntax match TrailingSpaces /\s\+$/ display containedin=ALL
endfunction

function! s:gui_colorscheme_init()
  " colorscheme vividchalk
  call s:syntaxes_add()
  call s:highlights_add()
endfunction

augroup vimrc-color-init "{{{2
  autocmd!

  autocmd ColorScheme * call s:highlights_add()
  autocmd Syntax * call s:syntaxes_add()
  autocmd Syntax eruby highlight link erubyRubyDelim Label

  " カーソル行 http://d.hatena.ne.jp/thinca/20090530/1243615055
  autocmd CursorMoved,CursorMovedI * call s:auto_cursorline('CursorMoved')
  autocmd CursorHold,CursorHoldI * call s:auto_cursorline('CursorHold')
  autocmd WinEnter * call s:auto_cursorline('WinEnter')
  autocmd WinLeave * call s:auto_cursorline('WinLeave')

  let s:cursorline_lock = 0
  function! s:auto_cursorline(event) "{{{3
    if a:event ==# 'WinEnter'
      setlocal cursorline
      let s:cursorline_lock = 2
    elseif a:event ==# 'WinLeave'
      setlocal nocursorline
    elseif a:event ==# 'CursorMoved'
      if s:cursorline_lock
        if 1 < s:cursorline_lock
          let s:cursorline_lock = 1
        else
          setlocal nocursorline
          let s:cursorline_lock = 0
        endif
      endif
    elseif a:event ==# 'CursorHold'
      setlocal cursorline
      let s:cursorline_lock = 1
    endif
  endfunction "}}}3

augroup END


if has('gui_running') "{{{2
  autocmd vimrc-color-init GUIEnter * call <SID>gui_colorscheme_init()
  colorscheme vividchalk
elseif &t_Co == 256 || s:is_win
  colorscheme vividchalk
else
  " colorscheme wombat
  colorscheme desert
endif

" preexec for runtimepath {{{1
" set nocompatible
filetype off

" vundle {{{1
" load {{{2
if has('vim_starting')
  " pathogen
  " call pathogen#infect()
  set runtimepath+=~/.vim/neobundle.vim

  " http://blog.supermomonga.com/articles/vim/neobundle-sugoibenri.html {{{2
  let s:bundle = {'uninstalled':{}}
  function! s:bundle.tap(bundle) " {{{
    let self.tapped = neobundle#get(a:bundle)
    return self.is_installed(a:bundle)
  endfunction " }}}

  function! s:bundle.get(bundle) "{{{
    return neobundle#get(a:bundle)
  endfunction

  function! s:bundle.config(config, ...) " {{{
    if a:0 >= 2
      call neobundle#config(a:config, a:1)
      return
    endif
    if exists("self.tapped") && self.tapped != {}
      call neobundle#config(self.tapped.name, a:config)
    endif
  endfunction " }}}

  function! s:bundle.untap() " {{{
    if exists('self.tapped')
      unlet s:bundle.tapped
    endif
  endfunction " }}}

  function! s:bundle.is_sourced(name) "{{{
    return neobundle#is_sourced(a:name)
  endfunction "}}}

  function! s:bundle.is_installed(name) "{{{
    let ret = neobundle#is_installed(a:name)
    if !ret
      let self.uninstalled[a:name] = 1
    endif
    return ret
  endfunction "}}}

  function! s:bundle.install_lazy_on(on, modes, source) "{{{
    if a:on =~? "filetype"
      let opt = {
            \ 'autoload' : {
            \   'filetypes' : split(a:modes, ','),
            \ }}
      execute printf('NeoBundleLazy %s,%s', a:source, string(opt))
    endif
  endfunction " }}}

  function! s:bundle.summary_report() "{{{
    let bundles = neobundle#config#get_neobundles()
    let msgs = [
          \ printf("Installed   : %d", len(bundles)),
          \ printf("Enabled     : %d", len(filter(copy(bundles), '!v:val.lazy'))),
          \ printf("Lazy        : %d", len(filter(copy(bundles), 'v:val.lazy'))),
          \ printf("Not Sourced : %d", len(filter(copy(bundles), '!v:val.sourced'))),
          \ printf("Sourced     : %d", len(filter(copy(bundles), 'v:val.sourced'))),
          \ printf("### Sourced plugins\n%s", join(map(
          \   filter(copy(bundles), 'v:val.lazy && v:val.sourced'),
          \   'v:val.name'), "\n")),
          \ printf("### Uninstalled plugins\n%s", join(keys(self.uninstalled), "\n")),
          \ ]
    echo join(msgs, "\n")
  endfunction " }}}

  function! s:bundle.validate_report() "{{{
    let bundles = neobundle#config#get_neobundles()
    let lazies = filter(copy(bundles), 'v:val.lazy && v:val.sourced')
    let plugins = []
    for item in lazies
      if isdirectory(item.path . '/plugin')
        continue
      endif
      call add(plugins, item)
    endfor
    if !empty(plugins)
      echo printf("Following plugins looks good should not be delayed\n%s",
            \ join(map(plugins, 'v:val.name'), "\n"))
    endif
  endfunction " }}}

  command! -nargs=+ NeoBundleLazyOn call s:bundle.install_lazy_on(<f-args>)
  command! NeoBundleSummary call s:bundle.summary_report()
  command! NeoBundleValidate call s:bundle.validate_report()
endif

call neobundle#rc(expand("~/.vim/neobundle"))
NeoBundleLocal ~/.vim/bundle

" vundles {{{2
" statusline {{{3
NeoBundle 'itchyny/lightline.vim'

" colorscheme {{{3
NeoBundle 'tpope/vim-vividchalk'
NeoBundle 'tomasr/molokai'
NeoBundleLazy 'mrkn/mrkn256.vim', {'autoload': {'unite_sources':['colorscheme']}}
NeoBundleLazy 'depuracao/vim-darkdevel', {'autoload': {'unite_sources':['colorscheme']}}
NeoBundleLazy 'goatslacker/mango.vim', {'autoload': {'unite_sources':['colorscheme']}}
NeoBundleLazy 'jpo/vim-railscasts-theme', {'autoload': {'unite_sources':['colorscheme']}}
NeoBundle 'fmoralesc/vim-vitamins'
NeoBundleLazy 'jnurmine/Zenburn', {'autoload': {'unite_sources':['colorscheme']}}
NeoBundleLazy 'gregsexton/Atom', {'autoload': {'unite_sources':['colorscheme']}}
NeoBundleLazy 'vim-scripts/rdark', {'autoload': {'unite_sources':['colorscheme']}}
NeoBundleLazy 'vim-scripts/Lucius', {'autoload': {'unite_sources':['colorscheme']}}
NeoBundleLazy 'altercation/vim-colors-solarized', {'autoload': {'unite_sources':['colorscheme']}}
NeoBundleLazy 'nanotech/jellybeans.vim', {'autoload': {'unite_sources':['colorscheme']}}
NeoBundleLazy 'trapd00r/neverland-vim-theme', {'autoload': {'unite_sources':['colorscheme']}}
NeoBundleLazy 'StanAngeloff/vim-zend55', {'autoload': {'unite_sources':['colorscheme']}}
NeoBundleLazy 'w0ng/vim-hybrid', {'autoload': {'unite_sources':['colorscheme']}}
NeoBundleLazy 'veloce/vim-aldmeris', {'autoload': {'unite_sources':['colorscheme']}}
NeoBundleLazy 'Pychimp/vim-luna', {'autoload': {'unite_sources':['colorscheme']}}
NeoBundleLazy 'croaker/mustang-vim', {'autoload': {'unite_sources':['colorscheme']}}
NeoBundleLazy 'jaromero/vim-monokai-refined', {'autoload': {'unite_sources':['colorscheme']}}
NeoBundleLazy 'git://gist.github.com/187578.git', {
      \ 'autoload': {'unite_sources':['colorscheme'],},
      \ 'directory': 'h2u_black',
      \ }

" common {{{3
" NeoBundle 'git://gist.github.com/5457352.git', {
"       \ 'directory' : 'ginger',
"       \ 'script_type' : 'plugin',
"       \ }
NeoBundleLazy 'mklabs/vim-fetch', { 'autoload' : {
      \ 'commands' : [
      \   {'name': 'Fetch', 'complete':'customlist,s:Completion'},
      \   'FetchManage',
      \ ], }}
NeoBundle 'osyo-manga/vim-reanimate', {'autoload': {
      \ 'commands': [
      \ 'ReanimateSave', 'ReanimateSaveCursorHold', 'ReanimateSaveInput',
      \ 'ReanimateLoadInput', 'ReanimateLoadLatest',
      \ 'ReanimateEditVimrcUnload',
      \ {'name': 'ReanimateLoad', 'complete': 'customlist,s:save_point_completelist'},
      \ {'name': 'ReanimateSwitch', 'complete': 'customlist,s:save_point_completelist'},
      \ {'name': 'ReanimateEditVimrcLocal', 'complete': 'customlist,s:save_point_completelist'},
      \ ]
      \ }}
NeoBundleLazy 'osyo-manga/vim-jplus', {'autoload':{
      \ 'mappings' : [['nv',
      \   '<Plug>(jplus-getchar)', '<Plug>(jplus-getchar-with-space)',
      \   '<Plug>(jplus-input)', '<Plug>(jplus-input-with-space)',
      \ ]]}}
NeoBundleLazy 'osyo-manga/vim-over', {'autoload':{
      \ 'commands': ['OverCommandLine'],
      \ 'insert': 1,
      \ }}
NeoBundleLazy 'mattn/benchvimrc-vim'
NeoBundle 'Shougo/context_filetype.vim'
NeoBundleLazy 'Shougo/vimfiler.vim', {
      \ 'depends': 'Shougo/unite.vim', 'autoload' : {
      \ 'commands' : [
      \ { 'name' : 'VimFiler', 'complete' : 'customlist,vimfiler#complete' },
      \ { 'name' : 'VimFilerExplorer', 'complete' : 'customlist,vimfiler#complete' },
      \ { 'name' : 'Edit', 'complete' : 'customlist,vimfiler#complete' },
      \ { 'name' : 'Write', 'complete' : 'customlist,vimfiler#complete' },
      \ 'Read', 'Source'],
      \ 'mappings' : ['<Plug>(vimfiler'],
      \ 'explorer' : 1,
      \ }}
NeoBundle "osyo-manga/unite-filters-collection"
NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \ 'windows' : $VCVARSALL . ' ' . $PROCESSOR_ARCHITECTURE . ' & ' .
      \ 'nmake -f Make_msvc.mak nodebug=1',
      \ 'cygwin' : 'make -f make_cygwin.mak',
      \ 'mac'    : 'make -f make_mac.mak',
      \ 'unix'   : 'make -f make_unix.mak',
      \ }
      \ }
NeoBundleLazy 'Shougo/vimshell', {
      \ 'depends': 'Shougo/vimproc.vim', 'autoload' : {
      \ 'commands' : [{ 'name' : 'VimShell',
      \ 'complete' : 'customlist,vimshell#complete'},
      \   'VimShellExecute', 'VimShellInteractive',
      \   'VimShellTerminal', 'VimShellPop'],
      \ 'mappings' : ['<Plug>(vimshell']
      \ }}
NeoBundleLazy 'Shougo/vinarise', { 'autoload': {
      \ 'commands' : [
      \ {'name' : 'Vinarise',
      \  'complete' : 'customlist,vinarise#complete'},
      \ {'name' : 'VinariseDump',
      \  'complete' : 'customlist,vinarise#complete'},
      \ {'name' : 'VinariseScript2Hex',
      \  'complete' : 'customlist,vinarise#complete'}],
      \ 'unite_sources' : 'vinarise/analysis'
      \ },
      \ 'depends' : 'rbtnn/hexript.vim'}
NeoBundleLazy 'Shougo/junkfile.vim', { 'autoload' : {
      \ 'commands' : ['JunkfileOpen'],
      \ 'unite_sources' : ['junkfile', 'junkfile/new'],
      \ }}
NeoBundle 'yomi322/vim-gitcomplete'
NeoBundleLazy 'kana/vim-altr', {'autoload': {
      \ 'mappings': ['<Plug>(altr-',],
      \ }}
NeoBundle 'kana/vim-fakeclip'
NeoBundle 'kana/vim-smartchr', {'autoload': {'insert':1}}
NeoBundle 'kana/vim-submode'
NeoBundleLazy 'kana/vim-niceblock', { 'autoload' : {
      \ 'mappings' : ['<Plug>(niceblock-',]
      \ }}
NeoBundle 'tyru/vim-altercmd'
NeoBundleLazy 'kana/vim-smartinput', {'autoload': {'insert':1}}

NeoBundleLazy 'tyru/stickykey.vim', {
      \ 'autoload' : {
      \ 'mappings' : [['icsl', '<Plug>(stickykey-']]
      \ }}

NeoBundleLazy 'chikatoike/concealedyank.vim', { 'autoload' : {
      \ 'mappings' : [
      \ ['nx', '<Plug>(operator-concealedyank)']]
      \ }}
" NeoBundle 'dannyob/quickfixstatus'
NeoBundleLazy 'pekepeke/quickfixstatus', {'autoload': {
      \ 'commands': ['QuickfixStatusEnable', 'QuickfixStatusDisable'],
      \ }}
" NeoBundle 'jceb/vim-hier'
NeoBundleLazy 'cohama/vim-hier', {'autoload':{
      \ 'commands': ['HierUpdate', 'HierClear', 'HierStart', 'HierStop',],
      \}}
" NeoBundle 'tomtom/quickfixsigns_vim'
NeoBundle 'tpope/vim-repeat'
NeoBundleLazy 'tpope/vim-dispatch', {'autoload': {
      \ 'commands': [
      \ {'name': 'FocusDispatch', 'complete': 'custom,dispatch#command_complete'},
      \ {'name': 'Dispatch', 'complete': 'custom,dispatch#command_complete'},
      \ {'name': 'Start', 'complete': 'custom,dispatch#command_complete'},
      \ {'name': 'Make', 'complete': 'file'},
      \ {'name': 'Copen'},
      \ ],
      \ }}
" NeoBundle 'tpope/vim-surround'
" NeoBundle 't9md/vim-surround_custom_mapping'
NeoBundleLazy 'anyakichi/vim-surround', {'autoload':{
      \ 'mappings': [['n', 'ds', 'cs', 'ys', 'yS', 'yss', 'ygs', 'ygS', 'ygss', 'ygsgs'],
      \ ['x', 's', 'S', 'gs', 'gS'],
      \ ['i', '<C-S>', '<C-G>s', '<C-G>S']],
      \ }}
NeoBundleLazy 'tpope/vim-abolish', {'autoload': {
      \ 'commands': [
      \ {'name': 'Abolish'}, {'name': 'Subvert'},
      \ ],
      \ 'mappings': [['n', '<Plug>Coerce']]
      \ }}
" NeoBundle 'tpope/vim-endwise'
NeoBundle 'rhysd/endwize.vim', {'autoload': {'insert':1}}
NeoBundleLazy 't9md/vim-quickhl', {'autoload': {
      \ 'commands': [
      \ 'QuickhlList', 'QuickhlDump', 'QuickhlReset', 'QuickhlColors',
      \ 'QuickhlReloadColors', 'QuickhlAdd', 'QuickhlDel', 'QuickhlLock',
      \ 'QuickhlUnLock', 'QuickhlMatch', 'QuickhlMatchClear', 'QuickhlMatchAuto',
      \ 'QuickhlMatchNoAuto',
      \ ],
      \ 'mappings': [['n', '<Plug>(quickhl-match)'],
      \ ['nv', '<Plug>(quickhl-toggle)', '<Plug>(quickhl-reset)']],
      \ }}
NeoBundleLazy 't9md/vim-textmanip'
NeoBundleLazy 'bkad/CamelCaseMotion', { 'autoload' : {
      \ 'mappings' : ['<Plug>CamelCaseMotion_w',
      \ '<Plug>CamelCaseMotion_b'],
      \ }}
NeoBundleLazy 'h1mesuke/vim-alignta', {'autoload': {
      \ 'commands': [
      \ {'name': 'Align'},
      \ {'name': 'Alignta'},
      \ ],
      \ 'unite_sources': ['alignta']
      \ }}
" NeoBundle 'vim-scripts/YankRing.vim'
" NeoBundle 'maxbrunsfeld/vim-yankstack'
" NeoBundle 'chrismetcalf/vim-yankring'
" NeoBundle 'the-isz/MinYankRing.vim'

NeoBundleLazy 'AndrewRadev/switch.vim', {'autoload': {
      \ 'commands': ['Switch']
      \ }}
NeoBundle 'tpope/vim-speeddating', {'autoload': {
      \ 'mappings' : [['nv', '<Plug>SpeedDatingUp', '<Plug>SpeedDatingDown'],
      \ ['n', '<Plug>SpeedDatingNowLocal', '<Plug>SpeedDatingNowUTC']],
      \ 'commands' : ['SpeedDatingFormat']
      \ }}
NeoBundleLazy 'AndrewRadev/splitjoin.vim', {'autoload': {
      \ 'commands': ['SplitjoinJoin', 'SplitjoinSplit'],
      \ }}
NeoBundleLazy 'AndrewRadev/inline_edit.vim', {'autoload': {
      \ 'commands': [
      \ {'name': 'InlineEdit'},
      \ ],
      \ }}
NeoBundleLazy 'zef/vim-cycle', {'autoload': {
      \ 'commands': ['CycleNext', 'CyclePrevious'],
      \ 'mappings': ['<Plug>CycleNext', '<Plug>CyclePrevious'],
      \ 'functions': ['AddCycleGroup']
      \ }}
NeoBundle 'mbbill/undotree'
NeoBundleLazy 'rhysd/clever-f.vim', {'autoload': {
      \ 'mappings': [
      \ '<Plug>(clever-f-',
      \ ]}}
NeoBundleLazy 'terryma/vim-expand-region', {'autoload':{
      \ 'mappings': ['<Plug>(expand_region_',]
      \ }}
" NeoBundle 'vim-scripts/ShowMarks7'
NeoBundle 'kshenoy/vim-signature'

if has('python')
  NeoBundleLazy 'editorconfig/editorconfig-vim'
endif
NeoBundleLazy 'kien/ctrlp.vim'
NeoBundleLazy 'glidenote/memolist.vim', {'autoload': {
      \ 'commands': ['MemoNew', 'MemoGrep', 'MemoList']
      \ }}
NeoBundleLazy 'LeafCage/nebula.vim', {'autoload': {
      \ 'commands': ['NebulaPutLazy', 'NebulaPutConfig', 'NebulaYankOptions', 'NebulaPutFromClipboard'],
      \ }}
NeoBundleLazy 'deris/vim-rengbang', {'autoload':{
      \ 'commands': ['RengBang'],
      \ 'mappings': [['nvx', '<Plug>(operator-rengbang-']],
      \ }}

NeoBundle 'pekepeke/vim-trimr'
NeoBundleLazy 'othree/eregex.vim', { 'autoload': {
      \ 'commands': ['E2v', 'M', 'S', 'G', 'V'],
      \ }}
NeoBundle 'sjl/gundo.vim'
NeoBundleLazy 'kana/vim-smartword', { 'autoload' : {
      \ 'mappings' : [['nv',
      \ '<Plug>(smartword-',
      \ ]]}}
" NeoBundle 'pekepeke/golden-ratio'
" NeoBundle 'scrooloose/nerdtree'
NeoBundle 'thinca/vim-qfreplace'
NeoBundle 'thinca/vim-localrc'
NeoBundleLazy 'thinca/vim-prettyprint', { 'autoload': {
      \ 'commands' : [
      \   { 'name' : 'PP', 'complete': 'expression'},
      \   { 'name' : 'PrettyPrint', 'complete': 'expression'},
      \ ]}}
NeoBundleLazy 'thinca/vim-editvar', {'autoload': {
      \ 'commands': [{'name': 'Editvar', 'complete': 'var'}],
      \ 'unite_sources': ['variable'],
      \ }}

" if has('conceal')
"   NeoBundle 'Yggdroot/indentLine'
" endif
NeoBundle 'nathanaelkane/vim-indent-guides'

NeoBundleLazy 'pekepeke/cascading.vim', {'autoload':{
      \ 'commands': ['Cascading'],
      \ 'mappings': [['n', '<Plug>(cascading)']]
      \ }}
NeoBundleLazy 'mileszs/ack.vim', { 'autoload': {
      \ 'commands': [
      \   {'name': 'Ack', 'complete': 'file'}, {'name': 'AckAdd', 'complete': 'file'},
      \   {'name': 'AckFromSearch', 'complete': 'file'}, {'name': 'LAck', 'complete': 'file'},
      \   {'name': 'LAckAdd', 'complete': 'file'}, {'name': 'AckFile', 'complete': 'file'},
      \   {'name': 'AckHelp', 'complete': 'file'}, {'name': 'LAckHelp', 'complete': 'file'},
      \ ],
      \ }}
NeoBundleLazy 'vim-scripts/MultipleSearch'
" NeoBundle 'terryma/vim-multiple-cursors'
NeoBundle 'vim-scripts/sudo.vim'
" NeoBundle 'chrisbra/SudoEdit.vim'
" if s:is_mac
"   if has('gui_running')
"     NeoBundle 'gmarik/sudo-gui.vim'
"   else
"     NeoBundleLazy 'gmarik/sudo-gui.vim'
"   endif
" endif

" lang {{{3
" basic {{{4
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'osyo-manga/shabadou.vim'
NeoBundle 'osyo-manga/vim-watchdogs'
NeoBundleLazy 'osyo-manga/vim-anzu', {'autoload': {
      \ 'mappings': [['n', '<Plug>(anzu-']],
      \ }}
NeoBundle 'kien/rainbow_parentheses.vim'
" incompatible with smartinput
" NeoBundle 'vim-scripts/Highlight-UnMatched-Brackets'
NeoBundle 'vim-scripts/matchit.zip', {'autoload': {
      \ 'mappings' : [['nx', '%']],
      \ }}
      " \ 'filetypes': ['html', 'xhtml', 'xml', 'ruby', 'python'],
NeoBundle 'vim-scripts/matchparenpp'
" NeoBundle 'vimtaku/hl_matchit.vim'
" if has('python')
"   NeoBundle 'Valloric/MatchTagAlways'
" else
NeoBundle 'gregsexton/MatchTag'
" endif
" NeoBundle 'Raimondi/delimitMate'
" NeoBundle 'acustodioo/vim-enter-indent'

" NeoBundle 'houtsnip/vim-emacscommandline'
NeoBundle 'tpope/vim-unimpaired'
NeoBundleLazy 'vim-scripts/ShowMultiBase', {'autoload':{
      \ 'commands': ['ShowMultiBase'],
      \ }}
" NeoBundle 'tyru/current-func-info.vim'
" NeoBundle 'vim-scripts/taglist.vim'
if s:is_win
  NeoBundleLazy 'majutsushi/tagbar'
else
  NeoBundle 'majutsushi/tagbar'
endif
NeoBundleLazy 'wesleyche/SrcExpl', {'autoload': {
      \ 'commands': ['SrcExpl', 'SrcExplClose', 'SrcExplToggle',],
      \ }}
" NeoBundle 'abudden/TagHighlight'
" NeoBundle 'tomtom/tcomment_vim'
NeoBundleLazy 'tpope/vim-commentary', {'autoload': {
      \ 'mappings': [
      \   ['xn', '<Plug>Commentary'],
      \   ['n', '<Plug>Commentary'],
      \ ],
      \ }}
" NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'thinca/vim-template'
NeoBundleLazy 'mattn/sonictemplate-vim', {'autoload': {
      \ 'commands': [
      \   {'name': 'Template', 'complete': 'complete=customlist,sonictemplate#complete'},
      \   {'name': '', 'complete': 'complete=customlist,sonictemplate#complete'},
      \ ],
      \ 'mappings': [
      \   ['in', '<plug>(sonictemplate)', '<plug>(sonictemplate-intelligent)'],
      \ ],
      \ 'unite_sources': ['sonictemplate'],
      \ }}
NeoBundleLazy 'ciaranm/detectindent', {'autoload': {
      \ 'commands' : ['DetectIndent'],
      \ }}
NeoBundle 'ujihisa/shadow.vim'
if !s:is_win
  NeoBundle 'mhinz/vim-signify'
  " NeoBundle 'airblade/vim-gitgutter'
else
  NeoBundle 'sgur/vim-gitgutter'
endif
" NeoBundle 'motemen/git-vim'
NeoBundle 'tpope/vim-fugitive', {'autoload':{
      \ 'commands': [ "Git", "Gstatus", "Gcommit", "Gedit", "Gwrite", "Ggrep", "Glog", "Gdiff"],
      \ }}
NeoBundle 'tpope/vim-git'
NeoBundle 'int3/vim-extradite'
NeoBundleLazy 'gregsexton/gitv', {
      \   'autoload' : {
      \     'commands' : ['Gitv'],
      \   },
      \ }
NeoBundleLazy 'Shougo/vim-vcs', {'autoload': {
      \ 'functions': ['vcs#info'],
      \ }}
NeoBundleLazy 'sjl/splice.vim', {'autoload': {
      \ 'commands': [
      \   'SpliceInit', 'SpliceGrid', 'SpliceLoupe',
      \   'SpliceCompare', 'SplicePath', 'SpliceOriginal',
      \   'SpliceOne', 'SpliceTwo', 'SpliceResult',
      \   'SpliceDiff', 'SpliceDiffoff', 'SpliceScroll',
      \   'SpliceLayout', 'SpliceNext', 'SplicePrev',
      \   'SpliceUse', 'SpliceUse1', 'SpliceUse2',
      \ ],
      \ }}
NeoBundleLazy 'vim-scripts/DirDiff.vim', {'autoload': {
      \ 'commands' : [
      \   'DirDiffOpen', 'DirDiffNext', 'DirDiffPrev',
      \   'DirDiffUpdate', 'DirDiffQuit',
      \   {'name': 'DirDiff', 'complete': 'dir'},
      \ ],
      \ }}
" NeoBundleLazy 'mbadran/headlights'
NeoBundle 'thinca/vim-ft-diff_fold'
NeoBundleLazy 'AndrewRadev/linediff.vim', {'autoload': {
      \ 'commands': ['Linediff', 'LinediffReset'],
      \ }}
NeoBundle 'vim-scripts/ConflictDetection', {
      \ 'depends': 'vim-scripts/ingo-library',
      \ }
NeoBundleLazy 'yuratomo/dbg.vim', {'autoload':{
      \ 'commands': [
      \ {'name':'Dbg', 'complete':'file'},
      \ {'name':'DbgShell', 'complete':'file'},
      \ ],
      \ }}
NeoBundleLazy 'mattboehm/vim-unstack', {'autoload': {
      \ 'mappings': [['nv', '<Leader>s']],
      \ }}

" help {{{4
NeoBundle 'thinca/vim-ref', { 'autoload' : {
      \ 'commands' : {
      \   'name' : 'Ref',
      \   'complete' : 'customlist,ref#complete',
      \ },
      \ 'unite_sources' : [
      \   'ref/erlang', 'ref/man', 'ref/perldoc',
      \   'ref/phpmanual', 'ref/pydoc', 'ref/redis', 'ref/refe', 'ref/webdict'
      \ ],
      \ 'mappings' : ['n', 'K', '<Plug>(ref-']
      \ }}
NeoBundle 'pekepeke/ref-javadoc', {
      \ 'depends': 'thinca/vim-ref', 'autoload': {
      \ 'unite_sources': [
      \   'ref/javadoc',
      \ ], }}
NeoBundle 'soh335/vim-ref-jquery', {
      \ 'depends': 'thinca/vim-ref', 'autoload': {
      \ 'unite_sources': [
      \   'ref/jquery',
      \ ], }}
NeoBundle 'taka84u9/vim-ref-ri', {
      \ 'depends': 'thinca/vim-ref', 'autoload': {
      \ 'unite_sources': [
      \   'ref/ri',
      \ ], }}

" NeoBundle 'nishigori/vim-ref-phpunit'
" NeoBundle 'eiiches/vim-ref-gtkdoc'
" NeoBundle 'eiiches/vim-ref-info'
" NeoBundle 'mojako/ref-sources.vim'

" vim {{{4
NeoBundle 'kana/vim-vspec'

" vim-help {{{4
NeoBundle 'mattn/learn-vimscript'

" completion {{{4
if has('lua') && (v:version > 703 ||
      \ (v:version == 703&& has('patch885')))
  NeoBundleLazy 'Shougo/neocomplete.vim', {'autoload':{
        \ 'insert':1,
        \ }}
  " NeoBundleLazy 'Shougo/neocomplcache.vim'
  " NeoBundle 'pekepeke/neocomplcache-rsense.vim', 'neocompleteFeature'
  NeoBundle 'supermomonga/neocomplete-rsense.vim'
else
  NeoBundleLazy 'Shougo/neocomplcache.vim', {'autoload':{
        \ 'insert':1,
        \ }}
  " NeoBundleLazy 'Shougo/neocomplete.vim'
  NeoBundle 'Shougo/neocomplcache-rsense.vim'
  NeoBundle 'basyura/csharp_complete'
  NeoBundle 'osyo-manga/neocomplcache-jsx'
endif
NeoBundleLazy 'm2ym/rsense', {
      \ 'rtp' : 'etc',
      \ 'build' : {
      \    'mac': 'ruby etc/config.rb > ~/.rsense',
      \    'unix': 'ruby etc/config.rb > ~/.rsense',
      \ } }
NeoBundleLazy 'Shougo/neosnippet.vim', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \ 'commands' : ['NeoSnippetEdit', 'NeoSnippetSource'],
      \ 'insert' : 1,
      \ 'filetypes' : 'snippet',
      \ 'unite_sources' : ['snippet', 'neosnippet/user', 'neosnippet/runtime'],
      \ }}
NeoBundle 'hrsh7th/vim-neco-calc'

" ruby {{{4
NeoBundle 'vim-ruby/vim-ruby'
" NeoBundle 'vim-scripts/ruby-matchit'
NeoBundle 'semmons99/vim-ruby-matchit'
NeoBundleLazyOn FileType ruby,haml,eruby 'tpope/vim-rails'
" NeoBundleLazyOn FileType ruby 'tpope/vim-rbenv'
NeoBundleLazyOn FileType ruby 'tpope/vim-bundler'
NeoBundle 'hallison/vim-ruby-sinatra'
" NeoBundle 'tpope/vim-rake'
" NeoBundle 'taq/vim-rspec'
" NeoBundleLazy 'skwp/vim-rspec', {'autoload': {
"       \ 'commands' : ['RunSpec', 'RSpecLine', 'RunSpecs', 'RunSpecLine']
"       \ }}
NeoBundleLazy 'alpaca-tc/neorspec.vim', {
      \ 'depends' : ['alpaca-tc/vim-rails', 'tpope/vim-dispatch'],
      \ 'autoload' : {
      \   'commands' : ['RSpec', 'RSpecAll', 'RSpecCurrent', 'RSpecNearest', 'RSpecRetry']
      \ }}
NeoBundleLazyOn FileType ruby 'ecomba/vim-ruby-refactoring'

NeoBundle 'tpope/vim-cucumber'
NeoBundle 'yaymukund/vim-rabl'
NeoBundle 'vim-scripts/eruby.vim'

NeoBundle 'markcornick/vim-vagrant'
" NeoBundle 'robbevan/Vagrantfile.vim'
NeoBundleLazyOn FileType ruby 't9md/vim-chef'
NeoBundle 'rodjek/vim-puppet'
NeoBundleLazyOn FileType ruby 'joker1007/vim-ruby-heredoc-syntax'
NeoBundleLazy 'rhysd/unite-ruby-require.vim', { 'autoload' : {
      \ 'unite_sources' : ['ruby/require'],
      \ }}
NeoBundle 'rhysd/neco-ruby-keyword-args'

NeoBundleLazy 'ujihisa/unite-gem', { 'autoload' : {
      \ 'unite_sources' : ['gem'],
      \ }}
NeoBundleLazy 'ujihisa/unite-rake', { 'autoload' : {
      \ 'unite_sources' : ['rake'],
      \ }}
NeoBundleLazy 'basyura/unite-rails', { 'autoload' : {
      \ 'unite_sources' : [
      \   'rails/bundle', 'rails/bundled_gem', 'rails/config',
      \   'rails/controller', 'rails/db', 'rails/destroy', 'rails/features',
      \   'rails/gem', 'rails/gemfile', 'rails/generate', 'rails/git', 'rails/helper',
      \   'rails/heroku', 'rails/initializer', 'rails/javascript', 'rails/lib', 'rails/log',
      \   'rails/mailer', 'rails/model', 'rails/rake', 'rails/route', 'rails/schema', 'rails/spec',
      \   'rails/stylesheet', 'rails/view'
      \ ],
      \ }}
NeoBundleLazy 'moro/unite-stepdefs', { 'autoload' : {
      \ 'unite_sources': ['stepdefs'],
      \ }}

if has("signs") && has("clientserver") && v:version > 700
  NeoBundleLazyOn FileType ruby 'astashov/vim-ruby-debugger'
else
  NeoBundleLazy 'astashov/vim-ruby-debugger'
endif
if executable('alpaca_complete')
  NeoBundleLazy 'alpaca-tc/alpaca_complete', {
        \ 'depends' : 'tpope/vim-rails',
        \ 'autoload' : { 'filetypes' : 'ruby'},
        \  }
endif

" html {{{4
NeoBundle 'othree/html5.vim'
NeoBundle 'amirh/HTML-AutoCloseTag'
" heavy...
" NeoBundleLazyOn FileType html,php 'vim-scripts/indenthtml.vim'
" NeoBundleLazyOn FileType html,php 'vim-scripts/html-improved-indentation'
NeoBundle 'vim-scripts/html_FileCompletion'
NeoBundle 'tpope/vim-haml'
NeoBundle 'digitaltoad/vim-jade'
" NeoBundle 'mattn/zencoding-vim'
NeoBundleLazyOn FileType html,xhtml,eruby,php,css,scss 'mattn/emmet-vim'
" NeoBundleLazyOn FileType html,eruby,php 'vim-scripts/closetag.vim'
NeoBundle 'juvenn/mustache.vim'
NeoBundleLazy 'https://gist.github.com/6576341', {
      \ 'directory' : 'endtagcomment',
      \ 'script_type' : 'plugin',
      \ 'autoload': {'mappings': [['n', '<Plug>(endtagcomment)']]}
      \ }

" css {{{4
NeoBundleLazyOn FileType html,javascript,css,sass,scss,less,slim,stylus 'Rykka/colorv.vim'

NeoBundle 'ChrisYip/Better-CSS-Syntax-for-Vim'
" NeoBundle 'ap/vim-css-color'
" NeoBundle 'lilydjwg/colorizer'
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'cakebaker/scss-syntax.vim'
NeoBundle 'groenewege/vim-less'
NeoBundle 'wavded/vim-stylus'
NeoBundle 'slim-template/vim-slim'
NeoBundleLazy 'csscomb/csscomb-for-vim', {'autoload': {
      \ 'commands': ['CSSComb'],
      \ }}
NeoBundleLazy 'vim-scripts/cssbaseline.vim', {'autoload': {
      \ 'commands': ['Baseline', 'Baseline1'],
      \ }}
NeoBundleLazy 'bae22/prefixer', {'autoload': {
      \ 'commands': ['Prefixer', 'Prefixer1', 'Prefixer1a',
      \   'Prefixer2', 'Prefixer2a'],
      \ }}

" javascript {{{4
" NeoBundle 'lukaszb/vim-web-indent'
" NeoBundle 'vim-scripts/IndentAnything'
" NeoBundle 'itspriddle/vim-javascript-indent'
NeoBundle 'guileen/simple-javascript-indenter'
" NeoBundle 'jiangmiao/simple-javascript-indenter'
NeoBundle 'pangloss/vim-javascript'
if has('python')
  NeoBundle 'marijnh/tern_for_vim', {
        \   'build' : {
        \    'cygwin': 'npm install',
        \    'windows': 'npm install',
        \    'mac': 'npm install',
        \    'unix': 'npm install',
        \   },
        \ }
        " \   'autoload' : {},
        " \   'rtp' : 'vim',
endif
" NeoBundle 'drslump/vim-syntax-js'
" NeoBundle  'vim-scripts/jQuery'
" NeoBundle 'mmalecki/vim-node.js'
NeoBundle 'moll/vim-node'
NeoBundleLazy 'afshinm/npm.vim', {'autoload': {
      \ 'commands': ['Npm']
      \ }}
NeoBundle 'othree/javascript-libraries-syntax.vim'

" NeoBundle 'teramako/jscomplete-vim'
NeoBundle 'aereal/jscomplete-vim'
NeoBundle 'igetgames/vim-backbone-jscomplete'
NeoBundle 'myhere/vim-nodejs-complete'

NeoBundle 'claco/jasmine.vim'
NeoBundleLazy 'mklabs/grunt.vim', {
      \ 'build': {
      \ 'cygwin': 'npm install',
      \ 'windows': 'npm install',
      \ 'mac': 'npm install',
      \ 'unix': 'npm install',
      \ }, 'autoload': {
      \ 'filetypes': ['javascript', 'coffee'],
      \ }}
NeoBundle 'elzr/vim-json'

NeoBundle 'pekepeke/titanium-vim'
NeoBundle 'pekepeke/ref-jsextra-vim'
NeoBundleLazy 'chikatoike/sourcemap.vim', {'autoload':{
\ 'commands': [
\   {'name' : 'SourceMapAddMap', 'complete':'file'},
\   'SourceMapSwitch', 'SourceMapConvertQuickfixToOriginal',
\   'SourceMapConvertLocListToOriginal', 'SourceMapAddOriginalToQuickfix',
\   'SourceMapAddOriginalToLocList',]
\ }}
NeoBundle 'briancollins/vim-jst'
" NeoBundle 'jeyb/vim-jst'
NeoBundle 'nono/vim-handlebars'

NeoBundle 'vim-scripts/Dart'
NeoBundleLazyOn FileType haxe,hxml,nmml 'jdonaldson/vaxe'
" NeoBundle 'MarcWeber/vim-haxe'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'leafgarland/typescript-vim'
NeoBundleLazy 'clausreinke/typescript-tools', {
      \ 'script_type' : 'plugin',
      \ 'autoload' : { 'filetypes' : 'typescript' },
      \ 'build' : {
      \     'cygwin' : 'npm install',
      \     'windows' : 'npm install',
      \     'mac'    : 'npm install',
      \     'unix'   : 'npm install',
      \   },
      \ }

" python {{{4
" http://rope.sourceforge.net/
NeoBundle 'klen/python-mode'
NeoBundle 'lambdalisue/vim-python-virtualenv'
" NeoBundle 'lambdalisue/vim-django-support'
NeoBundle 'gerardo/vim-django-support'
" NeoBundle 'vim-scripts/python_match.vim'
NeoBundle 'voithos/vim-python-matchit'
NeoBundle 'heavenshell/vim-pydocstring'
NeoBundleLazy 'hachibeeDI/unite-pythonimport', {'autoload':{
      \ 'unite_sources' : ['pythonimport'],
      \ }}

if has('python')
  NeoBundleLazy 'davidhalter/jedi-vim', {
      \   'autoload' : { 'filetypes' : 'python' },
      \ }
else
  NeoBundleLazy 'davidhalter/jedi-vim'
endif
" NeoBundle 'sontek/rope-vim'
" if executable('ipython')
"   NeoBundleLazy 'ivanov/vim-ipython'
" endif

" perl {{{4
" NeoBundle 'petdance/vim-perl'
NeoBundle 'vim-perl/vim-perl'
NeoBundle 'moznion/vim-cpanfile'
NeoBundle 'c9s/perlomni.vim'
NeoBundleLazy 'y-uuki/unite-perl-module.vim', { 'autoload' : {
      \ 'unite_sources' : ['perl/global', 'perl/local'],
      \ }}
NeoBundleLazyOn FileType perl 'y-uuki/perl-local-lib-path.vim'
NeoBundleLazy 'soh335/unite-perl-module', {'autoload' : {
      \ 'unite_sources' : ['perl-module/carton', 'perl-module/cpan'],
      \ }}

" C,CPP {{{4
NeoBundleLazyOn FileType c,cpp 'vim-scripts/DoxygenToolkit.vim'
NeoBundleLazyOn FileType c,cpp,objc 'Rip-Rip/clang_complete'
NeoBundle 'peterhoeg/vim-qml'
"NeoBundleLazyOn FileType cpp 'OmniCppComplete'

" C# {{{4
NeoBundleLazyOn FileType cs 'OrangeT/vim-csharp'
NeoBundleLazy 'nosami/Omnisharp', {
      \   'autoload': {'filetypes': ['cs']},
      \   'build': {
      \     'windows': 'MSBuild.exe server/OmniSharp.sln /p:Platform="Any CPU"',
      \     'mac': 'xbuild server/OmniSharp.sln',
      \     'unix': 'xbuild server/OmniSharp.sln',
      \   }
      \ }
if s:is_win
  NeoBundleLazyOn FileType cs 'yuratomo/ildasm.vim'
endif

" OSX {{{4
NeoBundle 'nanki/vim-objj'
NeoBundleLazyOn FileType objc 'pekepeke/cocoa.vim'
if has('ruby')
  NeoBundleLazyOn FileType objc 'eraserhd/vim-ios'
else
  NeoBundleLazy 'eraserhd/vim-ios'
endif
NeoBundle 'vim-scripts/applescript.vim'

" windows {{{4
NeoBundle 'PProvost/vim-ps1'
NeoBundleLazyOn FileType vbnet 'hachibeeDI/vim-vbnet'

" java, android {{{4
NeoBundleLazyOn FileType java 'mikelue/vim-maven-plugin'
NeoBundleLazy 'KamunagiChiduru/unite-javaimport', {'autoload': {
      \ 'unite_sources': ['javaimport']
      \ }}
" NeoBundle 'vim-scripts/javacomplete', {
NeoBundleLazy 'nwertzberger/javacomplete', {
      \   'build' : {
      \      'windows' : 'javac -source 1.4 autoload/Reflection.java',
      \      'cygwin'  : 'javac -source 1.4 autoload/Reflection.java',
      \      'mac'     : 'javac -source 1.4 autoload/Reflection.java',
      \      'unix'    : 'javac -source 1.4 autoload/Reflection.java',
      \   },
      \   'autoload' : { 'filetypes' : 'java' },
      \ }
NeoBundleLazyOn FileType java 'vim-scripts/jcommenter.vim'
NeoBundle 'vim-scripts/groovyindent'
NeoBundle 'vim-scripts/groovy.vim'
NeoBundleLazy 'thinca/vim-logcat', {'autoload':{
      \ 'commands': ['Logcat', 'LogcatClear'],
      \ }}
NeoBundle 'lepture/vim-velocity'
NeoBundleLazy 'ryotakato/unite-gradle', {'autoload':{
      \ 'unite_sources': ['gradle'],
      \ }}

" scala {{{4
NeoBundleLazyOn FileType scala 'derekwyatt/vim-scala'

" go {{{4
NeoBundleLazyOn FileType go 'uggedal/go-vim'
if executable('gocode')
  NeoBundle 'undx/vim-gocode'
else
  NeoBundleLazy 'undx/vim-gocode'
endif

" as {{{4
" if has('ruby') && executable('sprout-as3')
"   NeoBundleLazyOn FileType actionscript  'endel/flashdevelop.vim'
"   NeoBundle 'tomtom/tlib_vim'
"   NeoBundle 'airblade/vim-rooter'
" endif
" NeoBundleLazyOn FileType actionscript 'yuratomo/flex-api-complete'

" texts {{{4
" NeoBundle 'plasticboy/vim-markdown' " plasticboy mode -> mkd
NeoBundle 'tpope/vim-markdown'
" NeoBundle 'thinca/vim-ft-markdown_fold'
NeoBundle 'nelstrom/vim-markdown-folding'
NeoBundleLazy 'joker1007/vim-markdown-quote-syntax'
NeoBundle 'timcharper/textile.vim'
NeoBundleLazyOn FileType csv 'chrisbra/csv.vim'
" NeoBundleLazyOn FileType yaml 'henrik/vim-yaml-flattener', {'autoload':{
"       \ 'commands': ['YAMLToggleFlatness']
"       \ }}
NeoBundle 'aklt/plantuml-syntax'
NeoBundle 'maxmeyer/vim-taskjuggler'
NeoBundle 'hara/vim-opf'

NeoBundleLazy 'motemen/hatena-vim', {
      \ 'autoload': {
      \   'commands': ['HatenaEdit', 'HatenaUpdate', 'HatenaUpdateTrivial',
      \     {'name' : 'HatenaEnumUsers', 'complete': 'customlist,HatenaEnumUsers'}
      \ ]}}
NeoBundle 'moro/vim-review'
NeoBundle 'nvie/vim-rst-tables'
NeoBundle 'vim-scripts/sequence'
NeoBundleLazy 'vim-scripts/DrawIt', {'depends' : 'vim-scripts/cecutil'}

" haskell {{{4
" NeoBundle 'ehamberg/haskellmode-vim'
NeoBundleLazyOn FileType haskell 'dag/vim2hs'
NeoBundleLazyOn FileType haskell 'ujihisa/ref-hoogle'
NeoBundle 'ujihisa/neco-ghc'
NeoBundleLazyOn FileType haskell "ujihisa/unite-haskellimport"
NeoBundle 'eagletmt/ghcmod-vim'
NeoBundleLazyOn FileType haskell 'eagletmt/unite-haddock'
NeoBundle 'elixir-lang/vim-elixir'

" php {{{4
" NeoBundleLazyOn FileType php 'spf13/PIV'
" NeoBundleLazyOn FileType php 'justinrainbow/php-doc.vim'
NeoBundle 'captbaritone/better-indent-support-for-php-with-html'
NeoBundle '2072/PHP-Indenting-for-VIm'
" NeoBundleLazyOn FileType php 'pekepeke/php.vim-html-enhanced'
NeoBundle 'Gasol/vim-php'
NeoBundle 'StanAngeloff/php.vim'
NeoBundle 'arnaud-lb/vim-php-namespace'
NeoBundle 'pekepeke/phpfolding.vim'
NeoBundle 'vim-scripts/phpcomplete.vim'
" NeoBundle 'vim-scripts/php_localvarcheck.vim'
" NeoBundleLazyOn FileType php 'mikehaertl/pdv-standalone'
NeoBundle 'tokutake/twig-indent'
NeoBundle 'beyondwords/vim-twig'
NeoBundleLazyOn FileType php 'violetyk/cake.vim'
" NeoBundleLazyOn FileType php 'oppara/vim-unite-cake'
" NeoBundleLazy 'heavenshell/unite-zf', { 'autoload' : {
"       \ 'unite_sources' : [
"       \   'zf/app', 'zf/controllers', 'zf/models', 'zf/views',
"       \   'zf/helpers', 'zf/configs', 'zf/layouts', 'zf/modules',
"       \   'zf/tests', 'zf/services',
"       \ ],
"       \ }}
" NeoBundle 'heavenshell/unite-sf2', { 'autoload' : {
"       \ 'unite_sources' : [
"       \   'sf2/', 'sf2/app', 'sf2/app', 'sf2/app/config', 'sf2/app/views',
"       \   'sf2/app/web', 'sf2/bundles',
"       \ ],
"       \ }}

" sql {{{4
NeoBundle 'mattn/vdbi-vim'
NeoBundleLazyOn FileType sql 'vim-scripts/dbext.vim'
NeoBundleLazyOn FileType sql 'vim-scripts/SQLUtilities'
" NeoBundleLazyOn FileType sql 'vim-scripts/SQLComplete.vim'

" etc {{{4
NeoBundle 'honza/dockerfile.vim'
NeoBundleLazyOn FileType lua 'xolox/vim-lua-ftplugin'
NeoBundle 'vim-scripts/syslog-syntax-file'
NeoBundle 'brandonbloom/vim-proto'
NeoBundle 'sophacles/vim-processing'
NeoBundleLazyOn FileType processing 'pekepeke/ref-processing-vim'
NeoBundle 'sjl/strftimedammit.vim'
NeoBundle 'tangledhelix/vim-octopress'
NeoBundle 'jcfaria/Vim-R-plugin'
NeoBundleLazy 'rbtnn/vimconsole.vim', {
      \ 'autoload' : {
      \   'commands': [
      \     'VimConsoleLog', 'VimConsoleOpen', 'VimConsoleWarn', 'VimConsoleError',
      \     'VimConsoleError', 'VimConsoleToggle', 'VimConsoleClear', 'VimConsoleRedraw',
      \   ] }
      \ }
NeoBundleLazy 'basyura/rmine.vim', {'autoload': {
      \ 'commands': [
      \   {'name': 'Rmine', 'complete': 'custom,rmine#complete#project'},
      \   'RmineIssue', 'RmineNewIssue'
      \ ],
      \ 'unite_sources': ['rmine/project', 'rmine/query', 'rmine/selector'],
      \ }}
" NeoBundle 'basyura/unite-yarm'

" if executable('loga')
"   NeoBundle 'tacahiroy/vim-logaling'
" endif

" config {{{4
NeoBundle 'qqshfox/vim-tmux'
NeoBundle 'vim-scripts/nginx.vim'
NeoBundle 'smerrill/vcl-vim-plugin'
NeoBundle 'ksauzz/haproxy.vim'
" NeoBundle 'empanda/vim-varnish.vim'
NeoBundle 'glidenote/keepalived-syntax.vim'
NeoBundle 'Shougo/vim-nyaos'

" unite.vim {{{3
NeoBundle 'Shougo/unite.vim', {
      \   'autoload': { 'commands' : ['Unite', 'UniteBookmarkAdd'] },
      \ }
NeoBundleLazy 'thinca/vim-unite-history', {'autoload':{
      \ 'unite_sources': ['history/command', 'history/search'],
      \ }}
NeoBundleLazy 'Shougo/unite-help', { 'autoload' : {
      \ 'unite_sources' : ['help'],
      \ }}
NeoBundleLazy 'tacroe/unite-mark', { 'autoload' : {
      \ 'unite_sources' : ['mark'],
      \ }}
NeoBundleLazy 'zhaocai/unite-scriptnames', { 'autoload' : {
      \ 'unite_sources' : ['scriptnames'],
      \ }}
NeoBundleLazy 'pasela/unite-webcolorname', { 'autoload' : {
      \ 'unite_sources' : ['webcolorname'],
      \ }}
NeoBundleLazy 'ujihisa/unite-colorscheme', { 'autoload' : {
      \ 'unite_sources' : ['colorscheme'],
      \ }}
NeoBundleLazy 'LeafCage/unite-gvimrgb', {'autoload': {
      \ 'unite_sources': ['gvimrgb'],
      \ }}
" NeoBundle 'ujihisa/unite-font'
" NeoBundle 'tacroe/unite-alias'
" NeoBundle 'hakobe/unite-script'
" NeoBundle 'mattn/unite-remotefile'
" NeoBundle 'pekepeke/unite-fileline'
NeoBundleLazy 'Shougo/unite-build', { 'autoload' : {
      \ 'unite_sources' : ['build'],
      \ }}
" NeoBundle 'h1mesuke/unite-outline'
NeoBundleLazy 'Shougo/unite-outline', { 'autoload' : {
      \ 'unite_sources' : ['outline'],
      \ }}
NeoBundleLazy 'sgur/unite-git_grep', { 'autoload' : {
      \ 'unite_sources' : ['vcs_grep', 'vcs_grep/git', 'vcs_grep/hg'],
      \ }}
NeoBundleLazy 'Kocha/vim-unite-tig', { 'autoload' : {
      \ 'unite_sources' : ['tig'],
      \ }}
NeoBundleLazy 'kmnk/vim-unite-giti', { 'autoload' : {
      \ 'unite_sources' : ['giti', 'giti/branch', 'giti/config',
      \   'giti/log', 'giti/remote', 'giti/status',],
      \ }}
NeoBundleLazy 'kmnk/vim-unite-svn', { 'autoload' : {
      \ 'unite_sources' : ['svn/status', 'svn/diff', 'svn/blame',
      \   ],
      \ }}
" NeoBundle 'sgur/unite-qf'
NeoBundleLazy 'osyo-manga/unite-quickfix', { 'autoload' : {
      \ 'unite_sources' : ['quickfix', 'location_list'],
      \ }}
NeoBundleLazy "osyo-manga/unite-quickrun_config", { 'autoload' : {
      \ 'unite_sources' : ['quickrun_config'],
      \ }}
NeoBundleLazy 'eiiches/unite-tselect', { 'autoload' : {
      \ 'unite_sources' : ['tselect'],
      \ }}
NeoBundleLazy 'tsukkee/unite-tag', { 'autoload' : {
      \ 'unite_sources' : ['tag', 'tag/file', 'tag/include'],
      \ }}
NeoBundleLazy 'hewes/unite-gtags', {'autoload': {
      \ 'unite_sources': [
      \ 'gtags/context' , 'gtags/ref' , 'gtags/def' , 'gtags/grep' , 'gtags/completion',
      \ ],
      \ }}

" NeoBundle 'ujihisa/unite-launch'
NeoBundleLazy 'ujihisa/quicklearn', { 'autoload' : {
      \ 'unite_sources' : ['quicklearn'],
      \ }}
NeoBundleLazy "osyo-manga/unite-fold", {'autoload':{
      \ 'unite_sources' : ['fold'],
      \ }}

if executable('w3m')
  NeoBundleLazy 'ringogirl/unite-w3m', {
        \   'depends' : 'yuratomo/w3m.vim',
        \   'unite_sources' : ['w3m', 'w3m/history'],
        \ }
  NeoBundleLazy 'yuratomo/w3m.vim', {'autoload':{
        \ 'commands':[
        \ {'name': 'W3m', 'complete':'customlist,w3m#search_engine#List'},
        \ {'name': 'W3mTab', 'complete':'customlist,w3m#search_engine#List'},
        \ {'name': 'W3mSplit', 'complete':'customlist,w3m#search_engine#List'},
        \ {'name': 'W3mVSplit', 'complete':'customlist,w3m#search_engine#List'},
        \ {'name': 'W3mLocal', 'complete':'customlist,w3m#search_engine#List'},
        \ 'W3mHistory', 'W3mHistoryClear',
        \ ]}}
endif

" NeoBundle 'pekepeke/vim-unite-sonictemplate'
NeoBundleLazy 'pekepeke/vim-unite-repo-files', { 'autoload' : {
      \ 'unite_sources' : ['repo_files'],
      \ }}
NeoBundleLazy 'pekepeke/vim-unite-z', { 'autoload' : {
      \ 'unite_sources' : ['z'],
      \ }}


if s:is_win
  NeoBundleLazy 'sgur/unite-everything', { 'autoload' : {
      \ 'unite_sources' : ['everything', 'everything/async'],
      \ }}
else
  if s:is_mac
    NeoBundleLazy 'choplin/unite-spotlight', { 'autoload' : {
      \ 'unite_sources' : ['spotlight'],
      \ }}
  else
    NeoBundleLazy 'ujihisa/unite-locate', { 'autoload' : {
      \ 'unite_sources' : ['locate'],
      \ }}
  endif
  NeoBundle 'ujihisa/neco-look'
endif

" web {{{3
NeoBundleLazy 'tyru/open-browser.vim', {'autoload':{
      \ 'functions': ['OpenBrowser', ],
      \ 'function_prefix':'openbrowser',
      \ 'commands': [
      \ {'name': 'OpenBrowser',},
      \ {'name': 'OpenBrowserSearch', 'complete':'customlist,openbrowser#_cmd_complete'},
      \ {'name': 'OpenBrowserSmartSearch', 'complete':'customlist,openbrowser#_cmd_complete'},
      \ ],
      \ 'mappings': [
      \   ['nv', '<Plug>(openbrowser-',]
      \ ],
      \ }}
NeoBundleLazy 'tyru/open-browser-github.vim', {'autoload': {
      \ 'commands': ['OpenGithubFile', 'OpenGithubIssue',
      \   'OpenGithubPullReq']
      \ }}
NeoBundle 'mattn/webapi-vim'
" if executable('python')
"   NeoBundle 'mattn/mkdpreview-vim', {
"       \   'build' : {
"       \     'cygwin' : 'chmod u+x static/mkdpreview.py',
"       \     'mac'    : 'chmod u+x static/mkdpreview.py',
"       \     'unix'   : 'chmod u+x static/mkdpreview.py',
"       \   }
"       \ }
" endif
" NeoBundle 'mattn/googletranslate-vim'
" NeoBundle 'mattn/bingtranslate-vim'
NeoBundleLazy 'mattn/excitetranslate-vim', {'autoload': {
      \ 'commands': ['ExciteTranslate'],
      \ }}
" NeoBundle 'Rykka/trans.vim'
NeoBundle 'thinca/vim-ambicmd'
NeoBundleLazy 'mattn/gist-vim', {'autoload': {
      \ 'commands': ['Gist'],
      \ }}
" NeoBundle 'mattn/vimplenote-vim'
" NeoBundle 'pekepeke/vimplenote-vim'

" gf-user {{{3
NeoBundle 'kana/vim-gf-user'
NeoBundle 'kana/vim-gf-diff'
NeoBundleLazyOn FileType vim 'sgur/vim-gf-autoload'
" does not support gf-user
" NeoBundleLazyOn FileType python 'mkomitee/vim-gf-python'
NeoBundleLazyOn FileType python 'zhaocai/vim-gf-python'
NeoBundleLazyOn FileType ruby 'pekepeke/vim-gf-ruby-require'
NeoBundleLazyOn FileType vim 'pekepeke/vim-gf-vundle'

" operator {{{3
NeoBundle 'kana/vim-operator-user'
NeoBundleLazy 'kana/vim-operator-replace', {
      \ 'depends' : 'vim-operator-user', 'autoload' : {
      \ 'mappings' : [
      \ ['nx', '<Plug>(operator-replace)']]
      \ }}
NeoBundleLazy 'tyru/operator-camelize.vim', {
      \ 'depends' : 'vim-operator-user', 'autoload' : {
      \ 'mappings' : [
      \ ['nx', '<Plug>(operator-camelize', '<Plug>(operator-decamelize)']]
      \ }}
NeoBundleLazy 'tyru/operator-html-escape.vim', {
      \ 'depends' : 'vim-operator-user', 'autoload' : {
      \ 'mappings' : [
      \ ['nx', '<Plug>(operator-html-']]
      \ }}
NeoBundleLazy 'rhysd/vim-operator-surround', {'autoload': {
      \ 'mappings': [['', '<Plug>(operator-surround-']]
      \ }}
NeoBundleLazy 'pekepeke/vim-operator-shuffle', {
      \ 'depends' : 'vim-operator-user', 'autoload' : {
      \ 'mappings' : [
      \ ['nx', '<Plug>(operator-shuffle)']]
      \ }}
NeoBundleLazy 'pekepeke/vim-operator-tabular', {
      \ 'depends': 'pekepeke/vim-csvutil',
      \ 'autoload' : {
      \ 'mappings' : [
      \ ['nx', '<Plug>(operator-tabular-', ]]
      \ }}
NeoBundleLazy 'pekepeke/vim-operator-normalize-utf8mac', {
      \ 'depends' : 'vim-operator-user',
      \ 'autoload' : {
      \ 'mappings' : [['nx', '<Plug>(operator-normalize_utf8mac)']]
      \ }}

" textobj {{{3
NeoBundle 'kana/vim-textobj-user'
NeoBundleLazy 'kana/vim-textobj-datetime', {'autoload': {
      \ 'mappings': [['vo',
      \ 'ada', 'adf', 'add', 'adt', 'adz',
      \ 'ida', 'idf', 'idd', 'idt', 'idz',
      \ ]],
      \ }}
NeoBundleLazy 'kana/vim-textobj-diff', {'autoload': {
      \ 'mappings': [
      \ ['n', '<Leader>dj', '<Leader>dJ', '<Leader>dk', '<Leader>dK',
      \   '<Leader>dfj', '<Leader>dfJ', '<Leader>dfk', '<Leader>dfK', ]
      \ ],
      \ }}
NeoBundleLazy 'kana/vim-textobj-entire', {'autoload':{
      \ 'mappings': [['vo', '<Plug>(textobj-entire-', ]],
      \ }}
      " \ 'mappings': [['vo', 'ie', 'ae']],
NeoBundleLazy 'kana/vim-textobj-fold', {'autoload':{
      \ 'mappings': [['nvx', '<Plug>(textobj-fold-i)', '<Plug>(textobj-fold-a)']],
      \ }}
" NeoBundleLazy 'kana/vim-textobj-jabraces', {'autoload':{
"       \ 'mappings' : [['ov',
"       \ 'ajb', 'aj(', 'aj)', 'ajr', 'aj[', 'aj]', 'ajB', 'aj{', 'aj}', 'aja', 'aj<', 'aj>', 'ajA',
"       \ 'ajk', 'ajK', 'ajy', 'ajY', 'ajt', 'ajs',
"       \ 'ijb', 'ij(', 'ij)', 'ijr', 'ij[', 'ij]', 'ijB', 'ij{', 'ij}', 'ija', 'ij<', 'ij>', 'ijA',
"       \ 'ijk', 'ijK', 'ijy', 'ijY', 'ijt', 'ijs',
"       \ ]],
"       \ }}
NeoBundleLazy 'kana/vim-textobj-lastpat', {'autoload': {
      \ 'mappings' : [['vo', 'a/', 'i/', 'a?', 'i?' ]],
      \ }}
      " \ '<Plug>(textobj-lastpat-n)', '<Plug>(textobj-lastpat-N)',
NeoBundleLazy 'kana/vim-textobj-syntax', {'autoload': {
      \ 'mappings' : [['nvx',
      \ '<Plug>(textobj-syntax-i)', '<Plug>(textobj-syntax-a)',
      \ ]],
      \ }}
NeoBundleLazy 'kana/vim-textobj-line', {'autoload':{
      \ 'mappings': [['vo', '<Plug>(textobj-line-i)', '<Plug>(textobj-line-a)']],
      \ }}
NeoBundleLazy 'kana/vim-textobj-underscore', {'autoload':{
      \ 'mappings': [['nvx', '<Plug>(textobj-quoted-i)', '<Plug>(textobj-quoted-a)']],
     \ }}
NeoBundleLazy 'thinca/vim-textobj-between', {
      \ 'depends' : 'vim-textobj-user',
      \ 'autoload' : {
      \ 'mappings' : [
      \ ['nvx', '<Plug>(textobj-between-i)', '<Plug>(textobj-between-a)']]
      \ }}
" NeoBundle 'thinca/vim-textobj-comment'
NeoBundleLazy 'kana/vim-textobj-function', {
      \ 'depends' : 'vim-textobj-user',
      \ 'autoload' : {
      \ 'mappings' : [
      \ ['nvx', '<Plug>(textobj-function-i)', '<Plug>(textobj-function-a)']]
      \ }}
NeoBundle 'thinca/vim-textobj-function-javascript'
NeoBundle 'thinca/vim-textobj-function-perl'
NeoBundle 't9md/vim-textobj-function-ruby'
NeoBundleLazyOn FileType ruby 'nelstrom/vim-textobj-rubyblock'
NeoBundleLazy 'deris/vim-textobj-enclosedsyntax', {'autoload':{
      \ 'mappings' : [['nvo',
      \ '<Plug>(textobj-enclosedsyntax-i)', '<Plug>(textobj-enclosedsyntax-a)',
      \ ]]}}
NeoBundleLazy "osyo-manga/vim-textobj-multitextobj", {
      \ 'depends' : 'vim-textobj-user',
      \ 'autoload' : {
      \ 'mappings' : [
      \ ['nvo', '<Plug>(textobj-multitextobj-i)', '<Plug>(textobj-multitextobj-a)']]
      \ }}
NeoBundleLazy 'osyo-manga/vim-textobj-multiblock', {
      \ 'depends' : 'vim-textobj-user',
      \ 'autoload' : {
      \ 'mappings' : [
      \ ['nvo', '<Plug>(textobj-multiblock-i)', '<Plug>(textobj-multiblock-a)']]
      \ }}
NeoBundleLazy 'vim-scripts/textobj-indent', {
      \ 'depends' : 'vim-textobj-user',
      \ 'autoload' : {
      \ 'mappings' : [
      \ ['nvo', '<Plug>(textobj-indent-i)', '<Plug>(textobj-indent-a)']]
      \ }}
NeoBundleLazy 'sgur/vim-textobj-parameter', {
      \ 'depends' : 'vim-textobj-user',
      \ 'autoload' : {
      \ 'mappings' : [
      \ ['nvo', '<Plug>(textobj-parameter-i)', '<Plug>(textobj-parameter-a)']]
      \ }}
NeoBundleLazy 'h1mesuke/textobj-wiw', {
      \ 'depends' : 'vim-textobj-user',
      \ 'autoload' : {
      \ 'mappings' : [
      \ ['nvo', '<Plug>(textobj-wiw-i)', '<Plug>(textobj-wiw-a)']]
      \ }}
NeoBundleLazy 'coderifous/textobj-word-column.vim', {'autoload':{
      \ 'mappings' : [['xo', 'ac', 'aC', 'ic', 'iC']]
      \ }}
NeoBundleLazy 'rhysd/vim-textobj-continuous-line', {'autoload':{
      \ 'filetypes': ['vim', 'c', 'cpp', 'sh', 'zsh', 'fish'],
      \ }}
NeoBundleLazy 'osyo-manga/vim-textobj-context', {'autoload':{
      \ 'mappings' : [['nvo',
      \ '<Plug>(textobj-context-i)',
      \ ]]}}
NeoBundleLazy 'akiyan/vim-textobj-xml-attribute', {'autoload':{
      \ 'mappings' : [['nvo',
      \ '<Plug>(textobj-xmlattribute-',
      \ ]]}}
" NeoBundleLazy 'hchbaw/textobj-motionmotion.vim', {'autoload':{
"       \ 'mappings' : [['nvo',
"       \ '<Plug>(textobj-motionmotion-i)', '<Plug>(textobj-motionmotion-a)',
"       \ ]]}}
" NeoBundleLazy 'anyakichi/vim-textobj-xbrackets', {'autoload':{
"       \ 'mappings' : [['vo',
"       \ 'aV(', 'aV)', 'aVb', 'aV{', 'aV}', 'aVB', 'av', 'ax(', 'ax)', 'axb', 'a9', 'a0',
"       \ 'ax<', 'ax[', 'ax{', 'axB', 'axs(', 'axsb', 'axs<', 'axs[', 'axs{', 'axsB',
"       \ 'axs){', 'ay(', 'ayb', 'ay<', 'ay[', 'ay{', 'ayB', 'ays(', 'aysb', 'ays<',
"       \ 'iV(', 'iV)', 'iVb', 'iV{', 'iV}', 'iVB', 'iv', 'ix(', 'ix)', 'ixb', 'i9', 'i0',
"       \ 'ix<', 'ix[', 'ix{', 'ixB', 'ixs(', 'ixsb', 'ixs<', 'ixs[', 'ixs{', 'ixsB',
"       \ 'ixs){', 'iy(', 'iyb', 'iy<', 'iy[', 'iy{', 'iyB', 'iys(', 'iysb', 'iys<',
"       \ 'iys[', 'iys{', 'iysB', 'iys){',
"       \ ]]}}
NeoBundleLazy 'rhysd/vim-textobj-lastinserted', {'autoload':{
      \ 'mappings' : [
      \ ['nvo', '<Plug>(textobj-lastinserted-i)', '<Plug>(textobj-lastinserted-a)']]
      \ }}
NeoBundleLazy 'mattn/vim-textobj-url', {'autoload':{
      \ 'mappings' : [
      \ ['nvo', '<Plug>(textobj-url-i)', '<Plug>(textobj-url-a)']]
      \ }}
NeoBundleLazy 'anyakichi/vim-textobj-ifdef', {'autoload':{
      \ 'mappings' : [
      \ ['nvo', '<Plug>(textobj-ifdef-i)', '<Plug>(textobj-ifdef-a)']]
      \ }}
NeoBundleLazy 'akiyan/vim-textobj-php', {'autoload':{
      \ 'mappings' : [['nvo', '<Plug>(textobj-php-', ]]}}
" NeoBundle 'gorkunov/smartpairs.vim'
" , {'autoload':{
"       \ 'mappings' : [['nx',
"       \ '<Plug>(textobj--i)', '<Plug>(textobj--a)',
"       \ ]]}}
" metarw {{{3
" NeoBundle "mattn/vim-metarw"
" NeoBundle "mattn/vim-metarw-gist"
" NeoBundle "mattn/vim-metarw-git"
" NeoBundle "sorah/metarw-simplenote.vim"

" afterexec for runtimepath {{{1
filetype plugin indent on
if has('syntax')
  syntax enable
endif

" etc settings {{{2
if filereadable(expand('~/.vimrc.personal'))
  execute 'source' expand('~/.vimrc.personal')
endif
if isdirectory(expand('~/.vim/bin/'))
  call s:path_push(expand('~/.vim/bin/'))
endif
if s:is_win
  let dotnets = sort(split(globpath($WINDIR . '/Microsoft.NET/Framework/', 'v*'), "\n"))
  if !empty(dotnets)
    call s:path_push(dotnets[-1])
  endif
  unlet dotnets
endif
" }}}

" statusline {{{1
set laststatus=2  " ステータス表示用変数
let s:status_generator = { 'cfi':s:bundle.is_installed('current-func-info.vim') }
function! s:status_generator.get_line() "{{{3
  let s = ''

  let s .= '%<'
  let s .= '%f ' " filename
  let s .= '%m' " modified flag
  let s .= '%r' " readonly flag
  let s .= '%h' " help flag
  let s .= '%w' " preview flag
  if self.cfi
    let s .= '> %{cfi#format("%s()","")}'
  endif
  let s .= '%='
  let s .= '[%{&l:fenc}]'
  let s .= '[%{&l:ff}] %{&l:ft} '
  let s .= '< L%l:%c%V ' " current line status
  let s .= '%8P'

  return s
endfunction "}}}3
function! MyStatusLine()
  return s:status_generator.get_line()
endfunction
set statusline=%!MyStatusLine()


" for filetypes {{{1
" shebang {{{2
if !s:is_win
  MyAutoCmd BufWritePost *
        \ if getline(1) =~ "^#!"
        \ | exe "silent !chmod +x %"
        \ | endif
  MyAutoCmd BufEnter *
        \ if bufname("") !~ "^\[A-Za-z0-9\]*://"
        \ | silent! exe '!echo -n "k%\\"'
        \ | endif
endif
" auto mkdir {{{2
MyAutoCmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
function! s:auto_mkdir(dir, force)
  if !isdirectory(a:dir) && (a:force ||
        \ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction

" etc hacks {{{2
" http://d.hatena.ne.jp/uasi/20110523/1306079612
" if s:is_mac
"   MyAutoCmd BufWritePost * call <SID>set_utf8_attr(escape(expand("<afile>"), "*[]?{}' "))
"   function! s:set_utf8_attr(file)
"     let is_utf8 = &fileencoding == "utf-8" || (&fileencoding == "" && &encoding == "utf-8")
"     if s:is_mac && is_utf8
"       call system("xattr -w com.apple.TextEncoding 'utf-8;134217984' \"".a:file."\"")
"     endif
"   endfunction
" endif

MyAutoCmd BufReadPost *
\   if &modifiable && !search('[^\x00-\x7F]', 'cnw')
\ |   setlocal fileencoding=
\ | endif

function! s:filetype_check()
  if !empty(&filetype)
    " if !get(g:, 'syntax_on', 0)
    "   call vimconsole#log("syntax enable")
    "   syntax enable
    " endif
    return
  endif
  redir! => fts
  silent filetype
  redir END
  let status = filter(map(split(fts, " "), 'split(v:val, ":")'), '!empty(v:val)')
  call remove(status, 0)
  if len(filter(status, 'v:val[1] == "OFF"')) > 0
    filetype plugin indent on
  endif
endfunction
" MyAutoCmd BufReadPost,BufEnter * call s:filetype_check()
" http://vim-users.jp/2009/10/hack84/
MyAutoCmd BufWritePost * if expand('%') != '' && &buftype !~ 'nofile' | mkview | endif
MyAutoCmd BufRead * if expand('%') != '' && &buftype !~ 'nofile' | silent loadview | endif
set viewoptions=cursor

" setfiletype {{{2
" alias
MyAutoCmd FileType js set filetype=javascript
MyAutoCmd FileType rb set filetype=ruby
MyAutoCmd FileType pl set filetype=perl
MyAutoCmd FileType py set filetype=python
MyAutoCmd FileType md set filetype=markdown
" MySQL
MyAutoCmd BufNewFile,BufRead *.sql set filetype=mysql
" IO
MyAutoCmd BufNewFile,BufRead *.io set filetype=io
" command
MyAutoCmd BufNewFile,BufRead *.command set filetype=sh

MyAutoCmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
      \ | exe "normal! g`\""
      \ | endif

function! s:vimrc_cmdwin_init() "{{{3
  noremap <buffer><nowait> q :q<CR>
  noremap <buffer> <Esc> :q<CR>
  inoremap <buffer><expr> kk col('.') == 1 ? '<Esc>k' : 'kk'
  inoremap <buffer><expr> <BS> col('.') == 1 ? '<Esc>:quit<CR>' : '<BS>'

  if s:bundle.is_installed('vim-ambicmd')
    " imap <expr><buffer> <Space> ambicmd#expand("\<Space>")
    " imap <expr><buffer> <CR> ambicmd#expand("\<CR>")
    imap <expr><buffer> <Space> <SID>ambicmd_expand("\<Space>", 'i', getcmdline())
    imap <expr><buffer> <CR> <SID>ambicmd_expand("\<CR>", 'i', getcmdline())
  endif
  startinsert!
endfunction " }}}
MyAutoCmd CmdwinEnter * call s:vimrc_cmdwin_init()

" vim -b : edit binary using xxd-format! "{{{3
augroup vimrc-binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | silent %!xxd -g 1
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | silent %!xxd -g 1
  au BufWritePost *.bin set nomod | endif
augroup END


" some commands & altercmd {{{1
" some commands {{{2
command! -nargs=? -complete=dir Ctags call s:exec_ctags(<q-args>)
command! -nargs=? -complete=dir Gtags call s:system_with_lcd("gtags", <q-args>)

command! -nargs=0 -bang MyQ
      \ if tabpagenr('$') == 1 && winnr('$') == 1 | enew
      \ | else | quit<bang> | endif

command! -nargs=0 -bang MyWQ write<bang> | MyQ<bang>

function! s:system(cmd) "{{{3
  if s:bundle.is_installed('vimproc.vim')
    call vimproc#system_bg(a:cmd)
  else
    execute "!" a:cmd
  endif
endfunction

function! s:system_with_lcd(cmd, ...) "{{{3
  let dir = empty(a:000) ? "" : a:1

  if empty(dir)
    let dir = input("cd : ", getcwd(), "dir")
  endif
  if empty(dir)
    return
  endif
  let cwd = getcwd()

  execute 'lcd' dir
  call s:system(cmd)
  execute 'lcd' cwd
endfunction

function! s:exec_ctags(path) "{{{3
  let path = a:path
  let options = ' --exclude=".git"'
  if &filetype != 'javascript'
    let options .= ' --exclude="*.js"'
  elseif &filetype != 'coffee'
    let options .= ' --exclude="*.coffee"'
  endif
  let ctags_cmd = "ctags -R"
  if empty(path)
    " let path = input("input base dir : ", expand('%:p:h'))
    let path = input("cd : ", getcwd(), "dir")
  endif
  if empty(path)
    return
  endif
  let cwd = getcwd()
  if !empty(a:path) && isdirectory(a:path)
    execute 'lcd' a:path
  endif
  if s:bundle.is_installed('vimproc.vim')
    call vimproc#system_bg(ctags_cmd)
  else
    execute "!" ctags_cmd
    if s:bundle.is_installed('neocomplcache.vim')
      NeoComplCacheCachingTags
    elseif s:bundle.is_installed('neocomplete.vim')
      NeoCompleteTagMakeCache
    endif
  endif
  if !empty(a:path) && isdirectory(a:path)
    execute 'lcd' cwd
  endif
endfunction

function! s:toggle_option(opt) "{{{3
  exe "setl inv".a:opt
  let sts = eval('&'.a:opt)
  echo printf("set %s : %s", a:opt, sts ? "ON" : "OFF")
endfunction

function! s:initialize_global_dict(prefix, names) "{{{3
  if type(a:prefix) == s:type_a
    let prefix = ""
    let names = a:prefix
  else
    let prefix = a:prefix
    let names = a:names
  endif
  for name in names
    if !exists('g:' . prefix . name)
      let g:[prefix . name] = {}
    endif
  endfor
endfunction

function! s:bulk_dict_variables(defines) "{{{3
  for var in a:defines
    for name in var.names
      let var.dict[name] = var.value
    endfor
  endfor
endfunction

" altercmd "{{{2
if s:bundle.is_installed('vim-altercmd')
  call altercmd#load()

  function! s:alias_lc(...) " {{{3
    for cmd in a:000
      silent exe 'Alias' tolower(cmd) cmd
    endfor
  endfunction

  command! -bar -nargs=+
        \ Alias CAlterCommand <args> | AlterCommand <cmdwin> <args>

  command! -nargs=+ LCAlias call s:alias_lc(<f-args>)
else
  command! -bar -nargs=+ LCAlias call <SID>nop(<f-args>)
  command! -bar -nargs=+ Alias call <SID>nop(<f-args>)
endif

" alias calls {{{2
"Alias q bd
Alias q MyQ
Alias wq MyWQ
Alias Q quit
Alias WQ wq

Alias ve vsplit
Alias se split
Alias n new
Alias v vnew


" mappings {{{1
" define common key-prefixes {{{2
noremap [!space] <Nop>
nnoremap g<Space> <Space>
vnoremap g<Space> <Space>
nmap <Space> [!space]
vmap <Space> [!space]

noremap [!t] <Nop>
nmap t [!t]
nnoremap <silent> [!t]e t

" noremap [!s] <Nop>
" nmap [!s] s

noremap [!prefix] <Nop>
nmap , [!prefix]
vmap , [!prefix]
xmap , [!prefix]

noremap [!edit] <Nop>
nmap <C-e> [!edit]
vmap <C-e> [!edit]

noremap [!comment-doc] <Nop>
map     [!prefix]c     [!comment-doc]

nnoremap q <Nop>
nnoremap q: q:
nnoremap q/ q/
nnoremap q? q?
nnoremap Q q

" 行単位で移動 {{{2
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
xnoremap <expr> j (v:count == 0 && mode() !=# 'V') ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
xnoremap <expr> k (v:count == 0 && mode() !=# 'V') ? 'gk' : 'k'
" nmap gb :ls<CR>:buf

" disable danger keymaps {{{2
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
if $TERM =~ 'screen'
  map <C-z> <Nop>
endif

" useful keybinds {{{2
nnoremap gs :<C-u>setf<Space>
nmap Y y$

" S をつぶしてみる
noremap [!SW] <Nop>
nmap S [!SW]

nnoremap <silent> [!SW]s S
nnoremap <silent> [!SW]S "_dd
nnoremap <silent> [!SW]d "_d
nnoremap <silent> [!SW]D "_D

" nnoremap <silent> x "_x
" nnoremap <silent> X "_X
" " x はたまに使う
" nnoremap <silent> sx x
" nnoremap <silent> sX X

" http://vim-users.jp/2009/10/hack91/
cnoremap <expr> /  getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ?  getcmdtype() == '?' ? '\?' : '?'

" XXX
" nnoremap <silent> o :call <SID>smart_comment_map("o")<CR>
" nnoremap <silent> O :call <SID>smart_comment_map("O")<CR>
"
" function! s:smart_comment_map(key)
"   let line = getline('.')
"   " TODO
"   let mark = "*"
"   let org=&formatoptions
"   if line =~ '^\s*'. substitute(mark, '\([\*\$]\)', '\\\1', 'g')
"     setl formatoptions+=r formatoptions+=o
"   else
"     setl formatoptions-=r formatoptions-=o
"   endif
"   execute 'normal!' a:key
"   let &formatoptions=org
"   startinsert
" endfunction

" indent whole buffer
nnoremap [!space]= call my#ui#indent_whole_buffer()

" tab switch
for i in range(10)
  execute 'nnoremap <silent>' ('[!t]'.i) (((i+10) % 10).'gt')
endfor
unlet i
nnoremap <silent> [!t]n gt
nnoremap <silent> [!t]p gT
nnoremap <silent> [!t]h gT
nnoremap <silent> [!t]l gt
nnoremap <silent> [!t]c :<C-u>tabnew<CR>
nnoremap <silent> [!t]C :<C-u>tabnew %<CR>
nnoremap <silent> [!t]* :<C-u>tabedit %<CR>*
nnoremap <silent> [!t]# :<C-u>tabedit %<CR>#

" redraw map
nmap <silent> sr :redraw!<CR>

" for gui
nnoremap <M-a> ggVG
nnoremap <M-v> P
vnoremap <M-c> y
vnoremap <M-x> x

" winmove & winsize {{{2
nnoremap <silent> <C-Left>  :wincmd h<CR>
nnoremap <silent> <C-Right> :wincmd l<CR>
nnoremap <silent> <C-Up>    :wincmd k<CR>
nnoremap <silent> <C-Down>  :wincmd j<CR>

nnoremap <silent> <S-Left>  :10wincmd ><CR>
nnoremap <silent> <S-Right> :10wincmd <<CR>
nnoremap <silent> <S-Up>    :10wincmd -<CR>
nnoremap <silent> <S-Down>  :10wincmd +<CR>

" win switch
for i in range(10)
  execute 'nnoremap <silent> <C-w>'.i '<C-w>t'.repeat('<C-w>w', (i+9)%10)
endfor
unlet i

" replace & grep {{{2
nnoremap [!space]r :<C-u>%S/
vnoremap [!space]r :S/

" grep
let s:regexp_todo = 'TODO\|FIXME\|REVIEW\|MARK\|NOTE\|!!!\|\\?\\?\\?\|XXX'
function! s:set_grep(...) "{{{3
  let retval = 0
  for type in copy(a:000)
    if type == "jvgrep" && executable(type)
      set grepprg=jvgrep
      set grepformat=%f:%l:%m
      " set grepprg=jvgrep\ -n
      let Grep_Skip_Dirs = 'RCS CVS SCCS .svn .git .hg BIN bin LIB lib Debug debug Release release'
      let Grep_Skip_Files = '*~ *.bak *.v *.o *.d *.deps tags TAGS *.rej *.orig'

      let g:unite_source_grep_command = "jvgrep"
      let g:unite_source_grep_default_opts = '-in --color=never --exclude "\.(git|svn|hg|bzr)"'
      let g:unite_source_grep_recursive_opt = '-R'

      command! Todo silent! exe 'Unite' printf('grep:%s:-n:%s', getcwd(), s:regexp_todo) '-buffer-name=todo' '-no-quit'
      return 1
    elseif type == "ag" && executable(type)
      set grepprg=ag\ -S\ --nocolor\ --nogroup\ --nopager
      set grepformat=%f:%l:%m
      let g:ackprg="ag -S --nocolor --nogroup --column --nopager"

      let g:unite_source_grep_command = 'ag'
      let opts = [
            \ '-S --noheading --nocolor --nogroup --nopager',
            \ '--ignore', '".hg"',
            \ '--ignore', '".git"',
            \ '--ignore', '".bzr"',
            \ '--ignore', '".svn"',
            \ '--ignore', '"node_modules"',
            \ ]
      let g:unite_source_grep_default_opts = join(opts, " ")
      let g:unite_source_grep_recursive_opt = ''

      return 1
    elseif type == "ack" && executable(type)
      set grepprg=ack\ -a\ --nocolor\ --nogroup\ --nopager
      set grepformat=%f:%l:%m

      let g:ackprg="ack -H --nocolor --nogroup --column --nopager"
      let g:unite_source_grep_command = 'ack'
      let g:unite_source_grep_default_opts = '--no-heading --nocolor -a --nogroup --nopager'
      let g:unite_source_grep_recursive_opt = ''
      return 1
    elseif type == "ack-grep"  && executable(type)
      set grepprg=ack-grep\ -a\ --nocolor\ --nogroup\ --nopager
      set grepformat=%f:%l:%m

      let g:ackprg="ack-grep -H --nocolor --nogroup --column --nopager"
      let g:unite_source_grep_command = 'ack-grep'
      let g:unite_source_grep_default_opts = '--no-heading --nocolor -a --nogroup --nopager'
      let g:unite_source_grep_recursive_opt = ''
      return 1
    endif
    if type == "grep"
      let retval = 1
      break
    endif
  endfor

  set grepprg=grep\ -n\ $*\ /dev/null
  "set grepprg=grep\ -n\ $*\ /dev/null\ --exclude\ \"\*\.svn\*\"
  let Grep_Skip_Dirs = 'RCS CVS SCCS .svn .git .hg BIN bin LIB lib Debug debug Release release'
  let Grep_Skip_Files = '*~ *.bak *.v *.o *.d *.deps tags TAGS *.rej *.orig'
  let Grep_Default_Filelist = '*' "join(split('* '.Grep_Skip_Files, ' '), ' --exclude=')

  let g:unite_source_grep_command = 'grep'
  let g:unite_source_grep_default_opts = '-iRHn'
  let g:unite_source_grep_recursive_opt = ''
  return retval
endfunction

command! -nargs=0 SetJvgrep call s:set_grep("jvgrep")
command! -nargs=0 SetAck call s:set_grep("ack-grep")
command! -nargs=0 SetAg call s:set_grep("ag")

if s:is_win
  call s:set_grep("jvgrep", "ag", "ack-grep")
else
  call s:set_grep("ag", "jvgrep", "ack-grep")
endif

let Grep_Default_Options = '-i'
let Grep_OpenQuickfixWindow = 1

let MyGrep_ExcludeReg = '[~#]$\|\.bak$\|\.o$\|\.obj$\|\.exe$\|\.dll$\|\.pdf$\|\.doc$\|\.xls$\|[/\\]tags$\|^tags$'
let MyGrepcmd_useropt = '--exclude="*\.\(svn\|git\|hg)*"'

" mygrep.vim…
"nmap [!space]gg :EGrep<CR>
"nmap [!space]gr :RGrep<CR>
" nnoremap [!space]gg :Grep<CR>
" nnoremap [!space]gr :REGrep<CR>
nnoremap [!space]g  :Ack<Space>-i<Space>''<Left>
nnoremap [!space]gg :Ack<Space>-i<Space>''<Left>


function! s:vimrc_quickfix_init()
  " nnoremap <buffer> < :<C-u><CR>
endfunction

" quickfix のエラー箇所を波線でハイライト
let g:hier_highlight_group_qf  = "qf_error_ucurl"
function! s:vimrc_make_init()
  HierUpdate
  QuickfixStatusEnable
endfunction

MyAutoCmd FileType qf call s:vimrc_quickfix_init()
MyAutoCmd QuickfixCmdPost make call s:vimrc_make_init()
" MyAutoCmd QuickfixCmdPost make,grep,grepadd,vimgrep copen
" MyAutoCmd QuickfixCmdPost l* lopen


" tags-and-searches {{{2
nnoremap [!t]r t
if s:bundle.is_installed('unite-tselect')
  nnoremap <silent> [!t]t :<C-u>Unite tselect:<C-r>=expand('<cword>')<CR> -immediately<CR>
  nnoremap <silent> <C-w>tt <C-w>s:<C-u>Unite tselect:<C-r>=expand('<cword>')<CR> -immediately<CR>
else
  " nnoremap <silent> [!t]t g<C-]>
  " nnoremap <silent> <C-w>tt <C-w>sg<C-]>
  nnoremap <silent> [!t]t :<C-u>call <SID>tselect_immediately()<CR>
  nnoremap <silent> <C-w>tt <C-w>s:<C-u>call <SID>tselect_immediately()<CR>
endif
function! s:tselect_immediately()
  execute 'normal!' (len(taglist(expand('<cword>'))) > 1 ? "g" : "")."\<C-]>"
endfunction
nnoremap <silent> [!t]j :<C-u>tag<CR>
nnoremap <silent> [!t]k :<C-u>pop<CR>
" nnoremap <silent> [!t]l :<C-u>tselect<CR>

" [[, ]] {{{2
let g:square_brackets = {
      \ 'markdown' : ['^#', 'markdownHeadingDelimiter'],
      \ 'textile' : ['^*', 'txtListBullet\d'],
      \ 'html' : '<html\|<head\|<body\|<h\d',
      \ 'rst' : '^-\+\|^=\+',
      \ 'coffee' : '->\s*$\|^\s*class\s',
      \ 'git-log.git-diff' : '^@@\|^diff ',
      \ 'git' : '^@@\|^diff ',
      \ }
function! s:nmap_square_brackets() "{{{3
  if exists('g:square_brackets[&filetype]')
    if type(g:square_brackets[&filetype]) == s:type_a
      \ && len(g:square_brackets[&filetype]) >= 2
      let [pattern, syn] = g:square_brackets[&filetype]
      silent execute printf('nnoremap <silent><buffer> ]] ' .
            \ ':<C-u>call <SID>search_with_syntax(%s, %s, "")<CR>',
            \ string(pattern), string(syn))
      silent execute printf('nnoremap <silent><buffer> [[ ' .
            \ ':<C-u>call <SID>search_with_syntax(%s, %s, "b")<CR>',
            \ string(pattern), string(syn))
    else
      nnoremap <silent><buffer> ]] :<C-u>call search(g:square_brackets[&filetype], "W")<CR>
      nnoremap <silent><buffer> [[ :<C-u>call search(g:square_brackets[&filetype], "Wb")<CR>
    endif
  endif
endfunction

function! s:search_with_syntax(pattern,syn,flags) "{{{3
  normal! m'
  let i = 0
  let cnt = v:count ? v:count : 1
  while i < cnt
    let i = i + 1
    let line = line('.')
    let col  = col('.')
    let pos = search(a:pattern, 'W'.a:flags)
    while pos != 0
          \ && synIDattr(synID(line('.'), col('.'), 0),'name') !~# a:syn
      let pos = search(a:pattern, 'W'.a:flags)
    endwhile
    if pos == 0
      call cursor(line,col)
      return
    endif
  endwhile
endfunction

MyAutoCmd FileType * call s:nmap_square_brackets()

" maps {{{2
" if &diff
" //2 = target-branch, //3 = merge branch
map <leader>1 :diffget //2 \| duffupdate<CR>
map <leader>2 :diffget //3 \| duffupdate<CR>
map <leader>3 :echo '<Leader>2 = merges from target branch(left buffer), <Leader>3 = merges from merge branch(right buffer)'<CR>
" endif

" nmaps {{{3
MyAutoCmd FileType help,ref,git-status,git-log nnoremap <buffer><nowait> q <C-w>c

function! s:execute_motionless(expr)
  let wv = winsaveview()
  execute a:expr
  call winrestview(wv)
endfunction

function! s:set_transparency(op)
  silent! execute 'set transparency'.(a:op =~# '^[-+=]' ? a:op : '=' . a:op)
  echo &transparency
endfunction

if s:is_mac && has('gui_running')
  function! s:map_gui()
    nnoremap <D-Up>   :<C-u>call <SID>set_transparency('+=5')<CR>
    nnoremap <D-Down> :<C-u>call <SID>set_transparency('-=5')<CR>
    nnoremap <D-Right> :<C-u>call <SID>set_transparency(90)<CR>
    execute 'nnoremap <D-Left> :<C-u>call <SID>set_transparency(' . &transparency . ')<CR>'
  endfunction
  MyAutoCmd GUIEnter * call s:map_gui()
elseif s:is_win && has('gui_running')
  function! s:map_gui()
    nnoremap <A-Up>   :<C-u>call <SID>set_transparency('+=5')<CR>
    nnoremap <A-Down> :<C-u>call <SID>set_transparency('-=5')<CR>
    nnoremap <A-Right> :<C-u>call <SID>set_transparency(230)<CR>
    execute 'nnoremap <A-Left> :<C-u>call <SID>set_transparency(' . &transparency . ')<CR>'
  endfunction
  MyAutoCmd GUIEnter * call s:map_gui()
endif
" win move
nnoremap [!space]. :source ~/.vimrc<CR>

"nnoremap [!edit]<C-o> :copen<CR><C-w><C-w>
nnoremap [!space]q :<C-u>call <SID>toggle_quickfix_window()<CR>
function! s:toggle_quickfix_window() "{{{4
  let n = winnr('$')
  cclose
  if n == winnr('$')
    copen
  endif
endfunction "}}}

" nnoremap [!space]f :NERDTreeToggle<CR>

nnoremap / :<C-u>nohlsearch<CR>/
nnoremap ? :<C-u>nohlsearch<CR>?

function! s:show_mapping() " {{{4
  let key = getchar()
  let c = nr2char(key)
  let s = strtrans(c)
  if stridx(s, "^") == 0
    let c = "<C-".substitute(s, '^\^', "", "").">"
  endif
  if strlen(c) > 0
    exe 'Unite output:verbose\ map\ '.c
  endif
endfunction " }}}

nnoremap <silent> [!space]hk :<C-u>call <SID>show_mapping()<CR>
nnoremap [!space]/ :<C-u>nohlsearch<CR>
nnoremap [!space]w :<C-u>call <SID>toggle_option("wrap")<CR>

nnoremap <C-w><Space> <C-w>p
nnoremap *  *N
nnoremap #  #n
nnoremap <C-w>*  <C-w>s*N
nnoremap <C-w>#  <C-w>s#n

nnoremap [!prefix]ds :call <SID>replace_at_caret_data_scheme()<CR>
function! s:replace_at_caret_data_scheme() " {{{4
  let cfile = expand('<cfile>')
  let cpath = expand(cfile)
  let errmsg = ""
  if empty(cfile) || !filereadable(cpath)
    let errmsg = "file not found : " . cfile
  endif
  if executable('ruby')
    let cmd = printf("ruby -rwebrick/httputils -e '%s'",
          \ printf('fp="%s";include WEBrick::HTTPUtils;'
          \      . 'puts "data:#{mime_type(fp, DefaultMimeTypes)};base64,'
          \      . '#{[File.read(fp)].pack("m").gsub(/\n/,"")}"', cpath))
  " elseif executable('python')
  "   let cmd = printf("python -c 'import mimetypes;fp=\"%s\";print %s'"
  "         \ , cpath, printf('"data:%s;base64,%s" % mimetypes.guess_type(fp)[0], open(fp).read().encode("base64")'))
  elseif executable('php')
    let cmd = printf("php -r '$fp=\"%s\";%s;'", cpath,
          \ 'printf("data:%s;base64,%s",mime_content_type($fp),base64_encode(file_get_contents($fp)))'
          \ )
  else
    let errmsg = "exe not found : ruby or php"
  endif
  if !empty(errmsg)
    echohl Error
    echo errmsg
    echohl None
    return
  endif
  let line = getline(".")
  call setline(".",
        \ strpart(line, 0, stridx(line, cfile))
        \ . system(cmd)
        \ . strpart(line, stridx(line, cfile) + strlen(cfile))
        \ )
endfunction

" {{{4 http://vim-users.jp/2011/04/hack213/
let g:scrolloff = &scrolloff
set scrolloff=0
" Hack for <LeftMouse> not to adjust ('scrolloff') when single-clicking.
" Implement 'scrolloff' by auto-command to control the fire.
MyAutoCmd CursorMoved * call s:reinventing_scrolloff()
let s:last_lnum = -1
function! s:reinventing_scrolloff()
  if s:last_lnum > 0 && line('.') ==# s:last_lnum
    return
  endif
  let s:last_lnum = line('.')
  let winline     = winline()
  let winheight   = winheight(0)
  let middle      = winheight / 2
  let upside      = (winheight / winline) >= 2
  " If upside is true, add winlines to above the cursor.
  " If upside is false, add winlines to under the cursor.
  if upside
    let up_num = g:scrolloff - winline + 1
    let up_num = winline + up_num > middle ? middle - winline : up_num
    if up_num > 0
      execute 'normal!' up_num."\<C-y>"
    endif
  else
    let down_num = g:scrolloff - (winheight - winline)
    let down_num = winline - down_num < middle ? winline - middle : down_num
    if down_num > 0
      execute 'normal!' down_num."\<C-e>"
    endif
  endif
endfunction
nnoremap <silent> <LeftMouse>       <Esc>:set eventignore=all<CR><LeftMouse>:set eventignore=<CR>
nnoremap          <2-LeftMouse>     g*
nnoremap <silent> <ScrollWheelUp>   <Esc>:set eventignore=all<CR><ScrollWheelUp>:set eventignore=<CR>
nnoremap <silent> <ScrollWheelDown> <Esc>:set eventignore=all<CR><ScrollWheelDown>:set eventignore=<CR>

" imaps {{{3
inoremap <C-t> <C-v><Tab>

inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <C-d> <Delete>
inoremap <C-a> <Home>

inoremap <C-]>a <Home>
inoremap <C-]>e <End>
inoremap <C-]>f <S-Right>
inoremap <C-]>b <S-Left>
inoremap <C-]>d <Delete>
inoremap <C-]><C-a> <Home>
inoremap <C-]><C-e> <End>
inoremap <C-]><C-f> <S-Right>
inoremap <C-]><C-b> <S-Left>
inoremap <C-]><C-d> <Delete>

inoremap <C-w> <C-g>u<C-w>
inoremap <C-u> <C-g>u<C-u>

" cmaps {{{3
if s:bundle.is_installed('vim-emacscommandline')
  cnoremap <C-x><C-x> <C-r>=substitute(expand('%:p:h'), ' ', '\\v:val', 'e')<CR>/
else
  cnoremap <C-a> <Home>
  cnoremap <C-e> <End>
  cnoremap <C-f> <Right>
  cnoremap <C-b> <Left>
  cnoremap <C-d> <Delete>
  Lazy cnoremap <C-x> <C-r>=substitute(expand('%:p:h'), ' ', '\\v:val', 'e')<CR>/
endif

cnoremap <C-]>a <Home>
cnoremap <C-]>e <End>
"cnoremap <C-]>f <C-f>
cnoremap <C-]>f <S-Right>
cnoremap <C-]>b <S-Left>
cnoremap <C-]>d <Delete>
cnoremap <C-]>i <C-d>
cnoremap <C-]><C-a> <Home>
cnoremap <C-]><C-e> <End>
cnoremap <C-]><C-f> <S-Right>
cnoremap <C-]><C-b> <S-Left>
cnoremap <C-]><C-d> <Delete>
cnoremap <C-]><C-i> <C-d>


" v+omap
onoremap aa a>
vnoremap aa a>
onoremap ia i>
vnoremap ia i>
onoremap ar a]
vnoremap ar a]
onoremap ir i]
vnoremap ir i]
onoremap ak a)
vnoremap ak a)
onoremap ik i)
vnoremap ik i)

" vmaps {{{3
vnoremap . :normal .<CR>
" vnoremap <Leader>te    :ExciteTranslate<CR>
vnoremap <Leader>tg    :GingerRange<CR>
vnoremap <Leader>te    :GTransEnJa<CR>
vnoremap <Leader>tj    :GTransJaEn<CR>
vnoremap <Tab>   >gv
vnoremap <S-Tab> <gv
"nnoremap : q:
" from http://vim-users.jp/2011/04/hack214/
vnoremap ( t(
vnoremap ) t)
vnoremap ] t]
vnoremap [ t[
onoremap ( t(
onoremap ) t)
onoremap ] t]
onoremap [ t[

" mouse {{{2
if s:is_mac
  nnoremap <MiddleMouse> <Nop>
  inoremap <MiddleMouse> <Nop>
  vnoremap <MiddleMouse> <Nop>
endif

" languages plugin {{{1
" perl {{{2
let g:perl_compiler_force_warnings = 0
let g:perl_extended_vars           = 1
let g:perl_include_pod             = 1
let g:perl_moose_stuff             = 1
let g:perl_no_scope_in_variables   = 1
let g:perl_no_sync_on_global_var   = 1
let g:perl_no_sync_on_sub          = 1
let g:perl_nofold_packages         = 1
let g:perl_pod_formatting          = 1
let g:perl_pod_spellcheck_headings = 1
let g:perl_string_as_statement     = 1
let g:perl_sync_dist               = 1000
let g:perl_want_scope_in_variables = 1
"let g:perl_fold = 1
"let g:perl_fold_blocks = 1

" php {{{2
"let g:php_folding = 1
let g:php_sql_query = 1
let g:php_baselib = 1
let g:php_htmlInStrings = 1
let g:php_noShortTags = 1
let g:php_parent_error_close = 1
let g:php_parent_error_open = 1
"let g:php_sync_method = x

let g:php_folding = 0
" phpfolding.vim
let g:DisableAutoPHPFolding = 1

" let g:PHP_autoformatcomment=0
"" php-doc.vim
let g:pdv_cfg_Type = 'mixed'
let g:pdv_cfg_Package = ""
let g:pdv_cfg_Version = '$id$'
if exists('g:author') && exists('g:email')
  let g:pdv_cfg_Author = g:author . ' <' . g:email . '>'
else
  let g:pdv_cfg_Author = ''
endif
let g:pdv_cfg_Copyright = ""
let g:pdv_cfg_License = 'PHP Version 3.0 {@link http://www.php.net/license/3_0.txt}'
let g:pdv_cfg_CommentEnd = "// }}}"
" javascript {{{2
if s:bundle.is_installed('simple-javascript-indenter')
  " この設定入れるとshiftwidthを1にしてインデントしてくれる
  let g:SimpleJsIndenter_BriefMode = 1
  " この設定入れるとswitchのインデントがいくらかマシに
  let g:SimpleJsIndenter_CaseIndentLevel = -1
endif

" disables plugin {{{1
let g:loaded_getscriptPlugin = 1
let g:loaded_vimballPlugin = 1
let g:loaded_netrwPlugin = 1

" plugin settings {{{1
" vim-markdown-quote-syntax {{{2
let s:mdquote_defaults = keys(extend(
      \ get(g:, 'markdown_quote_syntax_defaults', {})
      \ , get(g:, 'markdown_quote_syntax_defaults', {})
      \ ))
function! s:vimrc_mdquote_syntax_init(pos, is_initialize)
  let pos = a:pos < 1 ? 1 : a:pos
  let s = join(getline(pos, pos + 5), "\n")
  let types = empty(s:mdquote_defaults) ?
  \ ['sh', 'html', 'cpp', 'ocaml', 'erlang', 'python',
  \ 'vim', 'c', 'haskell', 'java', 'javascript', 'perl', 'diff', 'ruby', 'sql']
  \ : s:mdquote_defaults
  let ft = '\('.join(types, '\|').'\)'
  if match(s, '^```'.ft) != -1
    silent NeoBundleSource vim-markdown-quote-syntax
    silent autocmd! vimrc-mdquote-syntax
    doautocmd Syntax
    return
  endif
  if a:is_initialize
    autocmd vimrc-mdquote-syntax CursorHold
    \ <buffer> call s:vimrc_mdquote_syntax_init(line(".") - 2, 0)
  endif
endfunction

augroup vimrc-mdquote-syntax
  autocmd!
  autocmd FileType markdown,mkd call s:vimrc_mdquote_syntax_init(1, 1)
augroup END


" context_filetype {{{2
let g:context_filetype#search_offset = 500

" vim-anzu {{{2
if s:bundle.tap('vim-anzu')
  let g:anzu_status_format = "%p(%i/%l)"
  let g:anzu_bottomtop_word = "search hit BOTTOM, continuing at TOP"
  let g:anzu_topbottom_word = "search hit TOP, continuing at BOTTOM"
  " nmap n <Plug>(anzu-n)zxzz
  " nmap N <Plug>(anzu-N)zxzz
  " nmap * <Plug>(anzu-star)Nzxzz
  " nmap # <Plug>(anzu-sharp)nzxzz

  " nmap n <Plug>(anzu-n)zx
  nmap n <Plug>(anzu-n)zx:<C-u>silent AnzuUpdateSearchStatus\|redraw!<CR>zx
  " nmap n <Plug>(anzu-jump-n)zx<Plug>(anzu-echo-search-status)
  nmap N <Plug>(anzu-N)zx
  nmap * <Plug>(anzu-star)Nzx
  nmap # <Plug>(anzu-sharp)nzx
  function! s:bundle.tapped.hooks.on_source(bundle)
    " 一定時間キー入力がないとき、ウインドウを移動したとき、タブを移動したときに
    " 検索ヒット数の表示を消去する
    " MyAutoCmd CursorHold,CursorHoldI,WinLeave,TabLeave * if exists('*anzu#clear_search_status') | call anzu#clear_search_status() | endif
    MyAutoCmd CursorMoved,CursorMovedI,WinLeave,TabLeave * if exists('*anzu#clear_search_status') | call anzu#clear_search_status() | endif
  endfunction
  call s:bundle.untap()
endif

" editorconfig {{{2
if s:bundle.tap('editorconfig-vim')
  augroup vimrc-editorconfig
    function! s:editorconfig_init()
      if filereadable('.editorconfig')
        NeoBundleSource editorconfig-vim
        silent EditorConfigReload
        autocmd!
      endif
    endfunction
    autocmd BufReadPost * call s:editorconfig_init()
  augroup END
  call s:bundle.untap()
endif

" detectindent {{{2
if s:bundle.tap('detectindent')
  function! s:bundle.tapped.hooks.on_source(bundle)
    MyAutoCmd FileType * DetectIndent
    let g:detectindent_preferred_expandtab = 1
  endfunction
  call s:bundle.untap()
endif

" lightline {{{2
if s:bundle.tap('lightline.vim')
  let g:unite_force_overwrite_statusline = 0
  let g:vimfiler_force_overwrite_statusline = 0
  let g:vimshell_force_overwrite_statusline = 0
  let g:lightline = {
        \ 'colorscheme': 'solarized',
        \ 'mode_map': {'n': 'N', 'i': 'I', 'R': 'R', 'v': 'V',
        \ 'V': 'V-LINE', 'c': 'C', "\<C-v>": 'V-BLOCK', 's': 'S',
        \ 'S': 'S-LINE', "\<C-s>": 'S-BLOCK', '?': ' ',
        \ },
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename', 'xenv_version', ] ],
        \   'right': [[ 'lineinfo' ], [ 'percent' ], [ 'anzu_or_charcode', 'fileformat', 'fileencoding', 'filetype',]],
        \ },
        \ 'component_function': {
        \   'fugitive' : 'g:ll_helper.fugitive',
        \   'filename' : 'g:ll_helper.filename',
        \   'iminsert' : 'g:ll_helper.iminsert',
        \   'xenv_version' : 'g:ll_helper.xenv_version',
        \   'anzu': 'g:ll_helper.anzu',
        \   'anzu_or_charcode': 'g:ll_helper.anzu_or_charcode',
        \ },
        \ }
  let g:ll_helper = {}

  function! g:ll_helper.get(...) "{{{3
    for s in a:000
      if !empty(s)
        return s
      endif
    endfor
    return ""
  endfunction

  function! g:ll_helper.anzu_or_charcode() "{{{3
    let s = self.anzu()
    if empty(s)
      return self.charcode()
    endif
    return s
  endfunction

  function! g:ll_helper.charcode() "{{{3
    redir => ascii
      silent! ascii
    redir END

    if match(ascii, 'NUL') != -1
      return 'NUL'
    endif

    let nrformat = '0x%02x' " Zero pad hex values
    let encoding = (&fenc == '' ? &enc : &fenc)

    if encoding == 'utf-8' " Zero pad with 4 zeroes in unicode files
      let nrformat = '0x%04x'
    endif

    " Get the character and the numeric value from the return value of :ascii
    " This matches the two first pieces of the return value, e.g.
    " "<F>  70" => char: 'F', nr: '70'
    let [str, char, nr; rest] = matchlist(ascii, '\v\<(.{-1,})\>\s*([0-9]+)')

    let nr = printf(nrformat, nr) " Format the numeric value

    return "'". char ."' ". nr
  endfunction

  function! g:ll_helper.anzu() "{{{3
    return exists('*anzu#search_status') ? anzu#search_status() : ''
  endfunction
  function! g:ll_helper.is_special_ft() "{{{3
    return &filetype =~ 'help\|vimfiler\|gundo'
  endfunction

  function! g:ll_helper.fugitive() "{{{3
    if !self.is_special_ft() && exists('*fugitive#head')
      return fugitive#head()
    endif
    return ''
  endfunction

  function! g:ll_helper.modified() "{{{3
    if self.is_special_ft()
      return ''
    elseif &modified
      return '[+]'
    elseif &modifiable
      return ''
    endif
    return '[-]'
  endfunction

  function! g:ll_helper.readonly() "{{{3
    return !self.is_special_ft() && &readonly ? '[R]' : ''
  endfunction

  function! g:ll_helper.iminsert() "{{{3
    return &iminsert ? "IME" : ''
  endfunction

  function! g:ll_helper.xenv_version() "{{{3
    if has_key(self.xenvs, &filetype)
      return self.get_xenv_version(&filetype, self.xenvs[&filetype])
    endif
    return ""
    " return join(map(copy(self.lang_items), 'self[v:val]()'), '')
    " return g:ll_helper.virtualenv().g:ll_helper.rbenv()
  endfunction

  let g:ll_helper.xenvs = {
        \ 'ruby': 'rbenv',
        \ 'python': 'pyenv',
        \ 'perl': 'plenv',
        \ 'javascript': 'nodenv',
        \ 'php': 'phpenv',
        \ }

  function! g:ll_helper.get_xenv_version(ft, name) "{{{3
    if &filetype != a:ft
      return ""
    endif

    if a:ft == "ruby" && exists('$RBENV_VERSION')
      return "rbenv:" . $RBENV_VERSION
    endif
    let var = a:name . '_version'
    if !exists('b:'.var)
      let b:[var] = -1
      for f in ['.'.a:name.'-version', expand('~/.'.a:name.'/version')]
        if filereadable(f)
          let b:[var] = readfile(f)[0]
          break
        endif
      endfor
    endif
    let ver = get(b:, var, '')
    if empty(ver)
      return ""
    endif
    return a:name . ':' . ver
  endfunction

  function! g:ll_helper.virtualenv() "{{{3
    if &filetype == 'python' && exists('*virtualenv#statusline')
      return virtualenv#statusline()
    endif
    return ''
  endfunction

  function! g:ll_helper.get_filename() "{{{3
    if &filetype == 'vimfiler'
      return vimfiler#get_status_string()
    elseif &filetype == 'unite'
      return unite#get_status_string()
    elseif &filetype == 'vimshell'
      return substitute(b:vimshell.current_dir, expand('~'), '~', '')
    elseif &filetype == 'tagbar'
      return 'Tagbar ' . tagbar#currenttag("%s", "")
    elseif exists('t:undotree')
      if filetype == 'undotree' && exists('*t:undotree.GetStatusLine')
        return t:undotree.GetStatusLine()
      elseif &filetype == 'diff' exists('*t:diffpanel.GetStatusLine')
        return t:diffpanel.GetStatusLine()
      endif
    elseif expand('%t')
      return '[No Name]'
    endif
    return expand('%t')
  endfunction

  function! g:ll_helper.filename() "{{{3
    return join([self.readonly(), self.get_filename(), self.modified()], '')
  endfunction

  MyAutoCmd ColorScheme * call s:lightline_update()
  function! s:lightline_update() "{{{3
    if !exists('g:loaded_lightline')
      return
    endif
    try
      if g:colors_name =~# 'wombat\|solarized\|landscape\|jellybeans\|Tomorrow'
        let g:lightline.colorscheme =
              \ substitute(substitute(g:colors_name, '-', '_', 'g'), '256.*', '', '') .
              \ (g:colors_name ==# 'solarized' ? '_' . &background : '')
      endif
      call lightline#init()
      call lightline#colorscheme()
      call lightline#update()
      endif
    catch
    endtry
  endfunction

  call s:bundle.untap()

endif

"  jplus {{{2
if s:bundle.tap('vim-jplus')
  nmap <Leader>j <Plug>(jplus-getchar-with-space)
  vmap <Leader>j <Plug>(jplus-getchar-with-space)
  call s:bundle.untap()
endif

" commentary {{{2
if s:bundle.tap('vim-commentary')
  xmap gc <Plug>Commentary
  nmap gc <Plug>Commentary
  nmap gcc <Plug>CommentaryLine
  nmap gcu <Plug>CommentaryUndo
  call s:bundle.untap()
endif

" showmultibase {{{2
if s:bundle.tap('ShowMultiBase')
  let g:ShowMultiBase_General_UseDefaultMappings = 0

  noremap <silent> <Leader>= :ShowMultiBase<CR>
  noremap <silent> <Leader>b= :ShowMultiBase 2<CR>
  noremap <silent> <Leader>o= :ShowMultiBase 8<CR>
  noremap <silent> <Leader>d= :ShowMultiBase 10<CR>
  noremap <silent> <Leader>h= :ShowMultiBase 16<CR>
  call s:bundle.untap()
endif

" speeddating {{{2
if s:bundle.tap('vim-speeddating')
  let g:speeddating_no_mappings = 1

  if !s:bundle.is_installed('vim-cycle')
    nmap <C-A> <Plug>SpeedDatingUp
    nmap <C-X> <Plug>SpeedDatingDown
  else
    function! s:speeddating_or_cycle(incr) "{{{3
      let line = getline('.')
      execute 'normal' abs(a:incr)."\<Plug>SpeedDating".(a:incr < 0 ? 'Down' : 'Up')
      if line == getline('.')
        execute 'normal' "\<Plug>Cycle".(a:incr < 0 ? 'Previous' : 'Next')
      endif
    endfunction " }}}
    nmap <silent> <C-a> :<C-u>call <SID>speeddating_or_cycle(v:count1)<CR>
    nmap <silent> <C-x> :<C-u>call <SID>speeddating_or_cycle(-v:count1)<CR>
  endif
  xmap <C-A> <Plug>SpeedDatingUp
  xmap <C-X> <Plug>SpeedDatingDown
  nmap d<C-A> <Plug>SpeedDatingNowUTC
  nmap d<C-X> <Plug>SpeedDatingNowLocal

  call s:bundle.untap()
endif

" cycle.vim {{{2
if s:bundle.tap('vim-cycle')
  let g:cycle_no_mappings=1

  if !s:bundle.is_installed('vim-speeddating')
    nmap <C-A> <Plug>CycleNext
    nmap <C-X> <Plug>CyclePrevious
  endif

  function! s:bundle.tapped.hooks.on_post_source(bundle)
    call AddCycleGroup(['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'])
    " call AddCycleGroup(['jan', 'feb', 'mar', 'apr', 'may', 'june', 'july', 'aug', 'sep', 'oct', 'nov', 'dec'])
    call AddCycleGroup([ 'january', 'february', 'march', 'april', 'may',
          \ 'june', 'july', 'august', 'september', 'october',
          \ 'november', 'december'])

    call AddCycleGroup(['specify', 'it'])
    call AddCycleGroup(['describe', 'context'])
    call AddCycleGroup(['public', 'protected', 'private'])
    call AddCycleGroup(['#', '##', '###', '####', '#####'])
    call AddCycleGroup(["-", "\t-", "\t\t-", "\t\t\t-"])
  endfunction
  call s:bundle.untap()
endif

" vimconsole.vim {{{2
if s:bundle.tap('vimconsole.vim')
  let g:vimconsole#auto_redraw = 1

  nnoremap [!space]v :<C-u>VimConsoleToggle<CR>

  function! s:bundle.tapped.hooks.on_source(bundle)
    MyAutoCmd FileType vimconsole call s:vimrc_vimconsole_init()
    function! s:vimrc_vimconsole_init() "{{{3
      nnoremap <buffer> <C-l> :<C-u>VimConsoleRedraw<CR>
    endfunction
  endfunction "}}}
  call s:bundle.untap()
endif

" perlomni {{{2
if s:bundle.tap('perlomni.vim')
  function! s:bundle.tapped.hooks.on_source(bundle)
    call s:path_push(s:bundle.get('perlomni.vim').path . '/bin')
  endfunction
  call s:bundle.untap()
endif

" cake.vim {{{2
if s:bundle.tap('cake.vim')
  let g:cakephp_no_default_keymappings = 1
  let g:cakephp_enable_fix_mode = 1
  let g:cakephp_enable_auto_mode = 1

  if !s:bundle.is_sourced('cake.vim')
    function! s:bundle.tapped.on_post_source(bundle)
      " doautocmd VimEnter
      call cake#init_app('')
    endfunction
  endif

  function! s:detect_cakephpapp() "{{{
    if exists('g:cake.paths.app')
      return stridx(expand('%:p'), g:cake.paths.app) == 0
    endif
    return 0
  endfunction " }}}

  function! s:init_cakephp() "{{{
    if !empty(g:cake) && s:detect_cakephpapp()
      nmap <buffer> gf <Plug>CakeJump
      nmap <buffer> <C-w>f <Plug>CakeSplitJump
      nmap <buffer> <C-w>gf <Plug>CakeTabJump

      nnoremap <buffer> <Leader>cc :Ccontroller
      nnoremap <buffer> <Leader>cm :Cmodel
      nnoremap <buffer> <Leader>cv :Cview
      nnoremap <buffer> <Leader>cw :Ccontrollerview
      nnoremap <buffer> <Leader>cs :Cshell
      nnoremap <buffer> <Leader>ct :Ctask
      nnoremap <buffer> <Leader>ccf :Cconfig
      nnoremap <buffer> <Leader>ccp :Ccomponent
      nnoremap <buffer> <Leader>cl :Clog

      nnoremap <buffer> <C-w><Leader>ccs :Ccontrollersp
      nnoremap <buffer> <C-w><Leader>cms :Cmodelsp
      nnoremap <buffer> <C-w><Leader>cvs :Cviewsp
      nnoremap <buffer> <C-w><Leader>cvws :Ccontrollerviewsp
      nnoremap <buffer> <C-w><Leader>ccfs :Cconfigsp
      nnoremap <buffer> <C-w><Leader>ccps :Ccomponentsp
    endif
  endfunction " }}}

  MyAutoCmd User PluginCakephpInitializeAfter call s:init_cakephp()
  call s:bundle.untap()
endif


" gitv {{{2
if s:bundle.tap('gitv')
  let g:Gitv_OpenHorizontal = 1
  let g:Gitv_WipeAllOnClose = 1
  let g:Gitv_DoNotMapCtrlKey = 1
  " http://d.hatena.ne.jp/cohama/20130517/1368806202
  function! s:bundle.tapped.hooks.on_source(bundle)
    MyAutoCmd FileType gitv call s:vimrc_gitv_init()
    function! s:vimrc_gitv_init()
      setl iskeyword+=/,-,.

      " nnoremap <silent><buffer> [!space]C :<C-u>Git checkout <C-r>=GitvGetCurrentHash()<CR><CR>
      " nnoremap <buffer> [!space]rb :<C-u>Git rebase <C-r>=GitvGetCurrentHash()<CR><Space>
      " nnoremap <buffer> [!space]R :<C-u>Git revert <C-r>=GitvGetCurrentHash()<CR><CR>
      " nnoremap <buffer> [!space]h :<C-u>Git cherry-pick <C-r>=GitvGetCurrentHash()<CR><CR>
      " nnoremap <buffer> [!space]rh :<C-u>Git reset --hard <C-r>=GitvGetCurrentHash()<CR>
      nnoremap <buffer> G :<C-u>Gbrowse <C-r>=GitvGetCurrentHash()<CR><CR>
      if s:bundle.is_installed('unite.vim')
        nnoremap <buffer><nowait> [!space] :<C-u>Unite menu:ft_gitv<CR>
      endif
    endfunction

    function! GitvGetCurrentHash()
      return matchstr(getline('.'), '\[\zs.\{7\}\ze\]$')
    endfunction
  endfunction
  call s:bundle.untap()
endif

" w3m {{{2
if s:bundle.tap('w3m.vim')
  Alias w3m W3mSplit
  Alias www W3mSplit
  call s:bundle.untap()
endif

" OmniSharp "{{{2
" let g:OmniSharp_host = "http://localhost:2000"
let g:OmniSharp_typeLookupInPreview = 1

" reanimate.vim {{{2
if s:bundle.tap('vim-reanimate')
  let g:reanimate_save_dir = $VIM_CACHE."/vim-reanimate"
  let g:reanimate_default_save_name = "latest"
  " sessionoptions
  let g:reanimate_sessionoptions =
        \ "blank,curdir,folds,help,localoptions,tabpages,unix"
  let g:reanimate_disables = [
        \ "reanimate_message",
        \ "reanimate_viminfo",
        \ "reanimate_window"
        \ ]

  function! s:bundle.tapped.hooks.on_source(bundle)
    augroup vimrc-plugin-reanimate
      autocmd!
      " autocmd VimEnter * ReanimateLoad
      autocmd CursorHold,VimLeavePre * ReanimateSaveCursorHold
    augroup End

    let s:event = {'name': 'user_event'}
    function! s:event.load_pre(...)
      tabnew
      " hide tabonly
    endfunction

    function! s:event.save_pre(...)
      silent! argdelete *
    endfunction

    call reanimate#hook(s:event)
    unlet s:event
  endfunction
  call s:bundle.untap()
endif

" colorv {{{2
let g:colorv_cache_fav = $VIM_CACHE . "/vim_colorv_fav"
let g:colorv_cache_file = $VIM_CACHE . "/vim_colorv_cache"

" trans.vim {{{2
let g:trans_default_lang = "en-ja"

" inline_edit {{{2
if s:bundle.is_installed('inline_edit.vim')
  let g:inline_edit_autowrite = 1
  let g:inline_edit_patterns = [
        \ {
        \ 'main_filetype': '*html',
        \ 'sub_filetype': 'handlebars',
        \ 'indent_adjustment': 1,
        \ 'start': '<script\>[^>]*type="text/template"[^>]*>',
        \ 'end': '</script>',
        \ }
        \ ]
  nnoremap <Leader>i :<C-u>InlineEdit<CR>
endif

" cascading.vim {{{2
if s:bundle.is_installed('cascading.vim')
  nmap <silent> !" <Plug>(cascading)
endif

" switch.vim {{{2
if s:bundle.is_installed('switch.vim')
  " let g:switch_custom_definitions = [ {
  "       \ } ]
  nnoremap <silent> !! :<C-u>Switch<CR>
  " let b:switch_custom_definitions = [

  let s:switch_definitions = {
        \ '_': [
        \ ['get', 'post', 'put', 'delete'],
        \ ]
        \ }
  function! s:switch_definitions_deploy()
    if empty(s:switch_definitions) || empty(&filetype)
      return
    endif
    let dict = exists('b:switch_custom_definitions') ? b:switch_custom_definitions : []

    for ft in split(&filetype, '\.')
      if has_key(s:switch_definitions, ft)
        let dict = extend(dict, s:switch_definitions[ft])
      endif
    endfor
    if exists('s:switch_definitions._')
      let dict = extend(dict, s:switch_definitions._)
    endif

    let b:switch_custom_definitions = dict
  endfunction
  MyAutoCmd filetype * call <SID>switch_definitions_deploy()
  " let g:switch_custom_definitions = [
  "       \ {'ruby': [
  "       \ ["describe", "context", "specific", "example"],
  "       \ ['before', 'after'],
  "       \ ['be_true', 'be_false'],
  "       \ ['get', 'post', 'put', 'delete'],
  "       \ ['==', 'eql', 'equal'],
  "       \ { '.should_not': '.should' },
  "       \ ['.to_not', '.to'],
  "       \ { '([^. ]+).should(_not|)': 'expect(\1).to \2' },
  "       \ { 'expect(([^. ]+)).to(_not|)': '\1.should \2' },
  "       \ ]} ]
endif

" undotree {{{2
if s:bundle.is_installed('undotree')
  nnoremap <Leader>u :<C-u>UndotreeToggle<CR>

  let g:undotree_SetFocusWhenToggle = 1
  let g:undotree_SplitLocation = 'topleft'
  let g:undotree_SplitWidth = 35
  let g:undotree_diffAutoOpen = 1
  let g:undotree_diffpanelHeight = 25
  let g:undotree_RelativeTimestamp = 1
  let g:undotree_TreeNodeShape = '*'
  let g:undotree_HighlightChangedText = 1
  let g:undotree_HighlightSyntax = "UnderLined"
endif

" vim-localrc {{{2
if s:bundle.is_installed('vim-localrc')
  let g:localrc_filename = '.local.vimrc'
  if has('vim_starting')
    " http://vim-users.jp/2009/12/hack112/ => vimrc-local
    call localrc#load('vimrc_local.vim', getcwd(), 3)
  endif
endif


" eregex.vim {{{2
let g:eregex_default_enable=0

" vim-trimr {{{2
let g:trimr_method = 'ignore_filetype'
let g:trimr_targets = ['markdown', 'mkd', 'textile']

" clever-f {{{2
if s:bundle.is_installed('clever-f.vim')
  let g:clever_f_not_overwrites_standard_mappings=1
  if s:bundle.is_installed('unite.vim')
    nmap [!unite]f <Plug>(clever-f-f)
    vmap f <Plug>(clever-f-f)
  else
    map f <Plug>(clever-f-f)
  endif
  map F <Plug>(clever-f-F)
  " map t <Plug>(clever-f-t)
  " map T <Plug>(clever-f-T)
endif

" hl_matchit {{{2
if s:bundle.tap('hl_matchit.vim')
  let g:hl_matchit_enable_on_vim_startup = 0
  let g:hl_matchit_hl_groupname = 'Title'
  let g:hl_matchit_allow_ft_regexp = 'html\|eruby\|eco'
  let s:hl_matchit_running = get(g:, 'hl_matchit_enable_on_vim_startup', 0)
  let s:hl_matchit_last_off_time = 0

  function! s:bundle.tapped.hooks.on_source(bundle)
    function! s:hl_matchit_fire(on)
      if a:on
        call hl_matchit#do_highlight()
        " HiMatchOn
      elseif !a:on
        HiMatchOff
      endif
    endfunction
    if !get(g:, 'hl_matchit_enable_on_vim_startup', 0)
      augroup vimrc-plugin-hl_matchit
        autocmd!
        autocmd CursorHold * call s:hl_matchit_fire(1)
        autocmd CursorMoved * call s:hl_matchit_fire(0)
      augroup END
    endif
  endfunction
  call s:bundle.untap()
endif

" dirdiff.vim {{{2
if s:bundle.is_installed('DirDiff.vim')
  let g:DirDiffExcludes = "CVS,*.class,*.o,*.exe,.*.swp,*.log,.git,.svn,.hg"
  let g:DirDiffIgnore = "Id:,Revision:,Date:"
  map ;dg <Plug>DirDiffGet
  map ;dp <Plug>DirDiffPut
  map ;dj <Plug>DirDiffNext
  map ;dk <Plug>DirDiffPrev
endif

" splitjoin.vim {{{2
if s:bundle.is_installed('splitjoin.vim')
  let g:splitjoin_split_mapping = 'gS'
  let g:splitjoin_join_mapping = 'gJ'
  let g:splitjoin_normalize_whitespace = 1
  let g:splitjoin_align = 1

  " nmap [!prefix]j :<C-u>SplitjoinSplit<CR>
  " nmap [!prefix]k :<C-u>SplitjoinJoin<CR>
endif

" rainbow_parentheses {{{2
if s:bundle.tap('rainbow_parentheses.vim')
  function! s:bundle.tapped.hooks.on_source(bundle)
    MyAutoCmd VimEnter * RainbowParenthesesToggleAll
  endfunction
  call s:bundle.untap()
endif

" vim-smartinput {{{2
if s:bundle.tap('vim-smartinput')
  " clear auto cmaps(for altercmd.vim)
  " MyAutoCmd VimEnter * call <SID>smartinput_init()

  function! s:bundle.tapped.hooks.on_source(bundle)
    function! s:sminput_define_rules(is_load_default_rules) "{{{
      if a:is_load_default_rules
        call smartinput#define_default_rules()
      endif
      call smartinput#define_rule({
            \   'at':       '(\%#)',
            \   'char':     '<Space>',
            \   'input':    '<Space><Space><Left>',
            \   })

      call smartinput#map_to_trigger('i', '<Space>', '<Space>', '<Space>')
      call smartinput#define_rule({
            \   'at':       '( \%# )',
            \   'char':     '<BS>',
            \   'input':    '<Del><BS>',
            \   })

      call smartinput#define_rule({
            \   'at':       '{\%#}',
            \   'char':     '<Space>',
            \   'input':    '<Space><Space><Left>',
            \   })

      call smartinput#define_rule({
            \   'at':       '{ \%# }',
            \   'char':     '<BS>',
            \   'input':    '<Del><BS>',
            \   })

      call smartinput#define_rule({
            \   'at':       '\[\%#\]',
            \   'char':     '<Space>',
            \   'input':    '<Space><Space><Left>',
            \   })

      call smartinput#define_rule({
            \   'at':       '\[ \%# \]',
            \   'char':     '<BS>',
            \   'input':    '<Del><BS>',
            \   })

      " 改行取り除き
      " call smartinput#define_rule({
      "       \   'at': '\s\+\%#',
      "       \   'char': '<CR>',
      "       \   'input': "<C-o>:call setline('.', substitute(getline('.'), '\\s\\+$', '', ''))<CR><CR>",
      "       \   })

      " Ruby 文字列内変数埋め込み
      call smartinput#map_to_trigger('i', '#', '#', '#')
      call smartinput#define_rule({
            \   'at': '\%#',
            \   'char': '#',
            \   'input': '#{}<Left>',
            \   'filetype': ['ruby'],
            \   'syntax': ['Constant', 'Special'],
            \   })

      " Ruby ブロック引数 ||
      call smartinput#map_to_trigger('i', '<Bar>', '<Bar>', '<Bar>')
      call smartinput#define_rule({
            \   'at': '\({\|\<do\>\)\s*\%#',
            \   'char': '<Bar>',
            \   'input': '<Bar><Bar><Left>',
            \   'filetype': ['ruby'],
            \    })

      " テンプレート内のスペース
      call smartinput#map_to_trigger('i', '<', '<', '<')
      call smartinput#define_rule({
            \   'at':       '<\%#>',
            \   'char':     '<Space>',
            \   'input':    '<Space><Space><Left>',
            \   'filetype': ['cpp'],
            \   })
      call smartinput#define_rule({
            \   'at':       '< \%# >',
            \   'char':     '<BS>',
            \   'input':    '<Del><BS>',
            \   'filetype': ['cpp'],
            \   })
      " struct
      call smartinput#define_rule({
            \   'at'       : '\%(\<struct\>\|\<class\>\|\<enum\>\)\s*\w\+.*\%#',
            \   'char'     : '{',
            \   'input'    : '{};<Left><Left>',
            \   'filetype' : ['cpp'],
            \   })
      " http://qiita.com/todashuta@github/items/bdad8e28843bfb3cd8bf
      call smartinput#map_to_trigger('i', '<Plug>(smartinput_BS)',
            \   '<BS>',
            \   '<BS>')
      call smartinput#map_to_trigger('i', '<Plug>(smartinput_C-h)',
            \   '<BS>',
            \   '<C-h>')
      call smartinput#map_to_trigger('i', '<Plug>(smartinput_CR)',
            \   '<Enter>',
            \   '<Enter>')
      " http://qiita.com/hatchinee/items/c5bc19a656925ce33882
      " classとかの定義時に:までを入れる
      call smartinput#define_rule({
            \   'at'       : '^\s*\%(\<def\>\|\<if\>\|\<for\>\|\<while\>\|\<class\>\|\<with\>\)\s*\w\+.*\%#',
            \   'char'     : '(',
            \   'input'    : '():<Left><Left>',
            \   'filetype' : ['python'],
            \   })
      " が、すでに:がある場合は重複させない. (smartinputでは、atの定義が長いほど適用の優先度が高くなる)
      call smartinput#define_rule({
            \   'at'       : '^\s*\%(\<def\>\|\<if\>\|\<for\>\|\<while\>\|\<class\>\|\<with\>\)\s*\w\+.*\%#.*:',
            \   'char'     : '(',
            \   'input'    : '()<Left>',
            \   'filetype' : ['python'],
            \   })
      " 末尾:の手前でも、エンターとか:で次の行にカーソルを移動させる
      call smartinput#define_rule({
            \   'at'       : '^\s*\%(\<def\>\|\<if\>\|\<for\>\|\<while\>\|\<class\>\|\<with\>\)\s*\w\+.*\%#:$',
            \   'char'     : ':',
            \   'input'    : '<Right><CR>',
            \   'filetype' : ['python'],
            \   })
      call smartinput#define_rule({
            \   'at'       : '^\s*\%(\<def\>\|\<if\>\|\<for\>\|\<while\>\|\<class\>\|\<with\>\)\s*\w\+.*\%#:$',
            \   'char'     : '<CR>',
            \   'input'    : '<Right><CR>',
            \   'filetype' : ['python'],
            \   })
    endfunction "}}}

    command! SmartinputOff call smartinput#clear_rules()
    command! SmartinputOn call s:sminput_define_rules(1) | call s:smartinput_init()
    " --;;;;;;;;
    command! -nargs=? SmartinputBufferMapClear call s:sminput_buffer_mapclear(<q-args>)

    function! s:sminput_buffer_mapclear(mode) "{{{
      let mode = empty(a:mode) ? '*' : a:mode
      let vars = smartinput#scope()
      let hash = {}
      " TODO special keys
      let rules = filter(get(vars, 'available_nrules', []), 'v:val._char =~# "^[a-zA-Z0-9!-/:-@\\[-`{-~]\\+$"')
      for item in copy(filter(rules, 'mode == "*" || mode == v:val.mode'))
        if get(hash, item._char, 1)
          let char = substitute(item._char, '[|]', '\\\1', 'g')
          execute printf("%smap \<buffer> %s %s", item.mode, char, char)
          let hash[item._char] = 0
        endif
      endfor
    endfunction "}}}

    function! s:smartinput_init()
      if hasmapto('<CR>', 'c')
        cunmap <CR>
      endif
    endfunction

    call s:sminput_define_rules(0)
    call s:smartinput_init()
  endfunction
  call s:bundle.untap()
endif

" golden-ratio {{{2
" let g:golden_ratio_ignore_ftypes=['unite', 'vimfiler']
", 'quickrun']
" nmap [!space]s <Plug>(golden_ratio_toggle)

" ambicmd {{{2
if s:bundle.is_installed('vim-ambicmd')
  function! s:ambicmd_expand(key, mode, line)
    " give priority to altercmd.vim
    if hasmapto(a:line, a:mode, 1)
      return a:key
    endif
    return ambicmd#expand(a:key)
  endfunction

  cmap <expr> <Space> <SID>ambicmd_expand("\<Space>", "c", getcmdline())
  cmap <expr> <CR> <SID>ambicmd_expand("\<CR>", "c", getcmdline())
  " cnoremap <expr> <C-l> ambicmd#expand("\<Space>")
  " cnoremap <expr> <Space> ambicmd#expand("\<Space>")
  " cnoremap <expr> <CR> ambicmd#expand("\<CR>")
endif

" camelcasemotion {{{2
if s:bundle.tap('CamelCaseMotion')
  nmap <silent> [!prefix]w <Plug>CamelCaseMotion_w
  nmap <silent> [!prefix]e <Plug>CamelCaseMotion_e
  nmap <silent> [!prefix]b <Plug>CamelCaseMotion_b
  vmap <silent> [!prefix]w <Plug>CamelCaseMotion_w
  vmap <silent> [!prefix]e <Plug>CamelCaseMotion_e
  vmap <silent> [!prefix]b <Plug>CamelCaseMotion_b

  omap <silent> i,w <Plug>CamelCaseMotion_iw
  xmap <silent> i,w <Plug>CamelCaseMotion_iw
  omap <silent> i,b <Plug>CamelCaseMotion_ib
  xmap <silent> i,b <Plug>CamelCaseMotion_ib
  omap <silent> i,e <Plug>CamelCaseMotion_ie
  xmap <silent> i,e <Plug>CamelCaseMotion_ie

  call s:bundle.untap()
endif

" indent-guides {{{2
if s:bundle.tap('vim-indent-guides')
  let g:indent_guides_enable_on_vim_startup = 1
  if has('gui_running')
    let g:indent_guides_auto_colors = 1
  else
    function! s:bundle.tapped.hooks.on_source(bundle)
      let g:indent_guides_auto_colors = 0
      augroup vimrc-plugin-indentguides
        autocmd!
        autocmd VimEnter,Colorscheme * :highlight IndentGuidesEven ctermbg=236 ctermfg=white
        autocmd VimEnter,Colorscheme * :highlight IndentGuidesOdd ctermbg=235 ctermfg=white
      augroup END
    endfunction
    call s:bundle.untap()
  endif
endif

if s:bundle.tap('indentLine')
  let g:indentLine_char = '¦'
  " let g:indentLine_color_term = 236
  " let g:indentLine_color_gui = '#A4E57E'
endif


" smartword {{{2
if s:bundle.is_installed('vim-smartword')
  nmap w  <Plug>(smartword-w)
  nmap b  <Plug>(smartword-b)
  nmap e  <Plug>(smartword-e)
  nmap ge <Plug>(smartword-ge)
  vmap w  <Plug>(smartword-w)
  vmap b  <Plug>(smartword-b)
  vmap e  <Plug>(smartword-e)
  vmap ge <Plug>(smartword-ge)
endif

" vim-altr {{{2
if s:bundle.tap('vim-altr')
  function! s:bundle.tapped.hooks.on_source(bundle)
    call altr#define('autoload/%.vim', 'doc/%.txt', 'plugin/%.vim', 'test/%.vim')

    call altr#define('%.c', '%.cpp', '%.m', '%.h')

    call altr#define('%.rb', 'spec/%_spec.rb')
    call altr#define('lib/%.rb', 'spec/lib/%_spec.rb')
    call altr#define('app/models/%.rb', 'spec/models/%_spec.rb', 'spec/factories/%s.rb')
    call altr#define('app/controllers/%.rb', 'spec/controllers/%_spec.rb')
    call altr#define('app/helpers/%.rb', 'spec/helpers/%_spec.rb')

    call altr#define('%.js', 'test/%Test.js', 'test/%_test.js', 'spec/%_spec.js', 'spec/%Spec.js')
    call altr#define('%.coffee', 'test/%Test.coffee', 'test/%_test.coffee', 'spec/%_spec.coffee', 'spec/%Spec.coffee')

    call altr#define('Controller/%.php', 'Test/Case/Controller/%Test.php')
    call altr#define('Model/%.php', 'Test/Case/Model/%Test.php')
    call altr#define('View/Helper/%.php', 'Test/Case/View/Helper/%Test.php')
    call altr#define('View/%.php', 'Test/Case/View/%Test.php')
  endfunction

  nmap [!space]k <Plug>(altr-back)
  nmap [!space]j <Plug>(altr-forward)
  nmap <F1> <Plug>(altr-back)
  nmap <F2> <Plug>(altr-forward)
  call s:bundle.untap()
endif

" vim-template "{{{2
if s:bundle.tap('vim-template')
  let g:template_basedir = expand('$HOME/.vim')
  let g:template_files = 'template/**'
  let g:template_free_pattern = 'template'

  function! s:template_keywords() "{{{3
    silent! %s/<+FILENAME_NOEXTUC+>/\=toupper(expand('%:t:r'))/g
    silent! %s/<+FILENAME_NOEXT+>/\=expand('%:t:r')/g
    silent! %s/<+FILENAME+>/\=expand('%:t')/g
    silent! %s/<+EMAIL+>/\=g:email/g
    silent! %s/<+AUTHOR+>/\=g:author/g
    silent! %s/<+HOMEPAGE_URL+>/\=g:homepage_url/g
    silent! exe "normal! gg"
    "" expand eval
    %s/<%=\(.\{-}\)%>/\=eval(submatch(1))/ge
  endfunction

  call s:mkvars(['g:email', 'g:author', 'g:homepage_url'], '')

  "autocmd BufNewFile * execute 'TemplateLoad'
  MyAutoCmd User plugin-template-loaded call s:template_keywords()

  call s:bundle.untap()
endif

" sonictemplate-vim {{{2
if s:bundle.tap('sonictemplate-vim')
  let g:sonictemplate_vim_template_dir = expand('$HOME/.vim/sonictemplate/')
  " nmap <C-y><C-t> <Plug>(sonictemplate)
  " imap <C-y><C-t> <Plug>(sonictemplate)
  nmap <C-y><C-t> :<C-u>Unite sonictemplate<CR>
  imap <C-y><C-t> <ESC>:<C-u>Unite sonictemplate<CR>

  let g:sonictemplate_key='\<Nop>'
  " let g:sonictemplate_intelligent_key='\<Nop>'
  nmap <C-y>t :<C-u>Unite sonictemplate<CR>
  imap <C-y>t <ESC>:<C-u>Unite sonictemplate<CR>
endif

" junkfile.vim http://vim-users.jp/2010/11/hack181/ {{{2
if s:bundle.tap('junkfile.vim')
  nnoremap [!prefix]ss :<C-u>JunkfileOpen<CR>
  call s:bundle.untap()
endif
command! -nargs=0 EnewNofile enew | setl buftype=nofile

nmap [!prefix]sc :<C-u>EnewNofile<CR>

" alignta {{{2
if s:bundle.tap('vim-alignta')
  let g:alignta_confirm_for_retab = 0
  " let g:Align_xstrlen=3
  " vmap [!prefix]a :Align

  vnoremap [!prefix]a :Alignta
  vnoremap [!prefix],a :Alignta<< [:=><\-)}\]]\+
  vnoremap [!prefix],r :Alignta<< [=><\-)}\]]\+
  vnoremap [!prefix],t :Alignta \|<CR>
  vnoremap [!prefix],c :Alignta<< \(//\|#\|\/\*\)/1<CR>
endif

" submode {{{2
" http://d.hatena.ne.jp/tyru/20100502/vim_mappings
if s:bundle.is_installed('vim-submode')

  " browser {{{3
  if s:is_mac
    call submode#enter_with('cscroll', 'n', '', 'sb', ':ChromeScrollDown<CR>')
    " call submode#enter_with('cscroll', 'n', '', 'sk', ':ChromeScrollUp<CR>')
    call submode#map('cscroll', 'n', '', 'j', ':ChromeScrollDown<CR>')
    call submode#map('cscroll', 'n', '', 'k', ':ChromeScrollUp<CR>')
    call submode#map('cscroll', 'n', '', 'l', ':ChromeTabRight<CR>')
    call submode#map('cscroll', 'n', '', 'h', ':ChromeTabLeft<CR>')
    call submode#map('cscroll', 'n', '', 'L', ':ChromePageGo<CR>')
    call submode#map('cscroll', 'n', '', 'H', ':ChromePageBack<CR>')
    call submode#map('cscroll', 'n', '', 'r', ':ChromeTabReload<CR>')
  endif

  " expand-region {{{3
  if s:bundle.is_installed('vim-expand-region')
    " don't work...
    call submode#enter_with('ex_region', 'v', '',  '+', '+')
    call submode#enter_with('ex_region', 'v', '',  '-', '+')
    call submode#leave_with('ex_region', 'v', '',  '<Esc>')
    call submode#map       ('ex_region', 'v', 'r', 'l', "<Plug>(expand_region_expand)")
    call submode#map       ('ex_region', 'v', 'r', 'j', "<Plug>(expand_region_expand)")
    call submode#map       ('ex_region', 'v', 'r', '+', "<Plug>(expand_region_expand)")
    call submode#map       ('ex_region', 'v', 'r', 'k', "<Plug>(expand_region_shrink)")
    call submode#map       ('ex_region', 'v', 'r', 'h', "<Plug>(expand_region_shrink)")
    call submode#map       ('ex_region', 'v', 'r', '-', "<Plug>(expand_region_shrink)")
    " map [!space]l <Plug>(expand_region_expand)
    " map [!space]h <Plug>(expand_region_shrink)
    " let g:expand_region_use_select_mode = 0
  endif

  " Change current window size {{{3
  call submode#enter_with('winsize', 'n', '', 'sw', '<Nop>')
  call submode#leave_with('winsize', 'n', '', '<Esc>')
  call submode#map       ('winsize', 'n', '', 'j', '<C-w>-:redraw<CR>')
  call submode#map       ('winsize', 'n', '', 'k', '<C-w>+:redraw<CR>')
  call submode#map       ('winsize', 'n', '', 'h', '<C-w><:redraw<CR>')
  call submode#map       ('winsize', 'n', '', 'l', '<C-w>>:redraw<CR>')
  call submode#map       ('winsize', 'n', '', 'J', ':set lines+=1<CR>')
  call submode#map       ('winsize', 'n', '', 'K', ':set lines-=1<CR>')
  call submode#map       ('winsize', 'n', '', 'H', ':set columns-=5<CR>')
  call submode#map       ('winsize', 'n', '', 'L', ':set columns+=5<CR>')

  " undo/redo {{{3
  call submode#enter_with('undo/redo', 'n', '', 'g-', 'g-')
  call submode#enter_with('undo/redo', 'n', '', 'g+', 'g+')
  call submode#leave_with('undo/redo', 'n', '', '<Esc>')
  call submode#map       ('undo/redo', 'n', '', '-', 'g-')
  call submode#map       ('undo/redo', 'n', '', '+', 'g+')

  " Tab walker. {{{3
  call submode#enter_with('tabwalker', 'n', '', 'st', '<Nop>')
  call submode#enter_with('tabwalker', 'n', '', 'se', '<Nop>')
  call submode#leave_with('tabwalker', 'n', '', '<Esc>')
  call submode#map       ('tabwalker', 'n', '', 'h', 'gT:redraw<CR>')
  call submode#map       ('tabwalker', 'n', '', 'l', 'gt:redraw<CR>')
  call submode#map       ('tabwalker', 'n', '', 'H', ':execute "tabmove" tabpagenr() - 2<CR>')
  call submode#map       ('tabwalker', 'n', '', 'L', ':execute "tabmove" tabpagenr()<CR>')
  call submode#map       ('tabwalker', 'n', '', 'n', ':execute "tabnew"<CR>:tabmove<CR>')
  call submode#map       ('tabwalker', 'n', '', 'c', ':execute "tabnew"<CR>:tabmove<CR>')
  call submode#map       ('tabwalker', 'n', '', 'q', ':execute "tabclose"<CR>')
  call submode#map       ('tabwalker', 'n', '', 'o', ':execute "tabonly"<CR>')

  " winmove {{{3
  call submode#enter_with('winmove', 'n', '', 'sj', '<C-w>j')
  call submode#enter_with('winmove', 'n', '', 'sk', '<C-w>k')
  call submode#enter_with('winmove', 'n', '', 'sh', '<C-w>h')
  call submode#enter_with('winmove', 'n', '', 'sl', '<C-w>l')
  call submode#leave_with('winmove', 'n', '', '<Esc>')
  call submode#map       ('winmove', 'n', '', 'j', '<C-w>j')
  call submode#map       ('winmove', 'n', '', 'k', '<C-w>k')
  call submode#map       ('winmove', 'n', '', 'h', '<C-w>h')
  call submode#map       ('winmove', 'n', '', 'l', '<C-w>l')
  call submode#map       ('winmove', 'n', '', 'J', '<C-w>j')
  call submode#map       ('winmove', 'n', '', 'K', '<C-w>k')
  call submode#map       ('winmove', 'n', '', 'H', '<C-w>h')
  call submode#map       ('winmove', 'n', '', 'L', '<C-w>l')
  call submode#map       ('winsize', 'n', '', '-', '<C-w>-:redraw<CR>')
  call submode#map       ('winsize', 'n', '', '+', '<C-w>+:redraw<CR>')
  call submode#map       ('winsize', 'n', '', '<', '<C-w><:redraw<CR>')
  call submode#map       ('winsize', 'n', '', '>', '<C-w>>:redraw<CR>')

  " Quickfix {{{3
  call submode#enter_with('quickfix', 'n', '',  'sq', '<Nop>')
  call submode#leave_with('quickfix', 'n', '',  '<Esc>')
  call submode#map       ('quickfix', 'n', '',  'j', ':cn<CR>')
  call submode#map       ('quickfix', 'n', '',  'k', ':cp<CR>')
  call submode#map       ('quickfix', 'n', '',  'n', ':cn<CR>')
  call submode#map       ('quickfix', 'n', '',  'p', ':cp<CR>')
  call submode#map       ('quickfix', 'n', 'x', 'c', ':cclose<CR>')
  call submode#map       ('quickfix', 'n', '',  'o', ':copen<CR>')
  call submode#map       ('quickfix', 'n', '',  'w', ':cwindow<CR>')
endif

" open-browser.vim {{{2
if s:bundle.is_installed('open-browser.vim')
  nmap [!space]u <Plug>(openbrowser-open)
  vmap [!space]u <Plug>(openbrowser-open)
endif

" netrw {{{2
let g:netrw_home = $VIM_CACHE
let g:netrw_list_hide = '\~$,^tags$,\(^\|\s\s\)\zs\.\.\S\+'

" yankring {{{2
let g:yankring_history_dir = $VIM_CACHE
let g:yankring_default_menu_mode = 0
let g:yankring_min_element_length = 2
let g:yankring_window_height = 14

" rails.vim {{{2
if s:bundle.tap('vim-rails')
  let g:rails_some_option = 1
  let g:rails_level = 4
  let g:rails_syntax = 1
  let g:rails_statusline = 1
  let g:rails_url='http://localhost:3000'
  let g:rails_subversion=0
  let g:rails_default_file='config/database.yml'

  function! s:vimrc_rails_init()
    nnoremap <buffer><leader>vv :Rview<CR>
    nnoremap <buffer><leader>cc :Rcontroller<CR>
    nnoremap <buffer><leader>mm :Rmodel<Space>
    nnoremap <buffer><leader>pp :Rpreview<CR>

    nnoremap <buffer> [!t]r :R<CR>
    nnoremap <buffer> [!t]a :A<CR>

    Rnavcommand api app/controllers/api -glob=**/* -suffix=_controller.rb
    " Rnavcommand tmpl app/controllers/tmpl -glob=**/* -suffix=_controller.rb
    Rnavcommand config config   -glob=*.*  -suffix= -default=routes.rb
    " nnoremap <buffer><C-H><C-H><C-H>  :<C-U>Unite rails/view<CR>
    " nnoremap <buffer><C-H><C-H>       :<C-U>Unite rails/model<CR>
    " nnoremap <buffer><C-H>            :<C-U>Unite rails/controller<CR>
    " nnoremap <buffer><C-H>c           :<C-U>Unite rails/config<CR>
    " nnoremap <buffer><C-H>s           :<C-U>Unite rails/spec<CR>
    " nnoremap <buffer><C-H>m           :<C-U>Unite rails/db -input=migrate<CR>
    " nnoremap <buffer><C-H>l           :<C-U>Unite rails/lib<CR>
    " nnoremap <buffer><expr><C-H>g     ':e '.b:rails_root.'/Gemfile<CR>'
    " nnoremap <buffer><expr><C-H>r     ':e '.b:rails_root.'/config/routes.rb<CR>'
    " nnoremap <buffer><expr><C-H>se    ':e '.b:rails_root.'/db/seeds.rb<CR>'
    " nnoremap <buffer><C-H>ra          :<C-U>Unite rails/rake<CR>
    " nnoremap <buffer><C-H>h           :<C-U>Unite rails/heroku<CR>
  endfunction

  MyAutoCmd User Rails call s:vimrc_rails_init()
endif


" python {{{2
let g:pymode_rope = 1
let g:pymode_rope_goto_def_newwin = 'new'
let g:pymode_rope_vim_completion = 1
let g:pymode_run = 0
let g:pymode_doc = 0
let g:pymode_lint = 0
let g:pymode_virtualenv = 0
let g:pymode_rope_global_prefix = '[!rope]'

" jedi-vim {{{2
if s:bundle.is_installed('jedi-vim')
  let g:jedi#auto_initialization = 1
  let g:jedi#popup_on_dot = 0
  let g:jedi#rename_command = '<leader>R'
  " let g:jedi#show_call_signatures = 0
  let g:jedi#show_call_signatures = 0
  let g:jedi#auto_vim_configuration = 0
  MyAutoCmd FileType python let b:did_ftplugin = 1
        \ | setlocal omnifunc=jedi#complete
endif
" pydiction {{{2
let g:pydiction_location = '~/.vim/dict/pydiction-complete-dict'

" html5.vim {{{2
let g:event_handler_attributes_complete = 1
let g:rdfa_attributes_complete = 1
let g:microdata_attributes_complete = 1
let g:aria_attributes_complete = 1

" PIV {{{2
let g:PIVCreateDefaultMappings=0

" sudo.vim {{{2
if s:is_mac && has('gui_running') && s:bundle.is_installed('sudo-gui.vim')
  command! -bang SW SudoWriteMacGUI
else
  command! SW w sudo:%
  command! SR read sudo:%
endif

" hatena.vim {{{2
let g:hatena_base_dir = $VIM_CACHE . '/vim-hatena/'
call s:mkdir(g:hatena_base_dir.'/cookies')
let g:hatena_upload_on_write = 0
let g:hatena_upload_on_write_bang = 1
let g:hatena_no_default_keymappings = 1

" dbext.vim {{{2
let g:dbext_default_prompt_for_parameters=0
let g:dbext_default_history_file=expand('$VIM_CACHE/dbext_sql_history.txt')
let g:dbext_default_menu_mode=0

" SQLUtilities {{{2
let g:sqlutil_default_menu_mode=0

" zen-coding.vim {{{2
let g:user_zen_leader_key='<C-y>'

" endtagcomment https://gist.github.com/411828 {{{2
nmap [!prefix]/ <Plug>(endtagcomment)

" smartchr "{{{2
if s:bundle.is_installed('vim-smartchr')
  inoremap <expr>, smartchr#one_of(', ', ',')
endif

" MyAutoCmd FileType
"       \ c,cpp,javascript,ruby,python,java,perl,php
"       \ call s:vimrc_smartchr_init()

function! s:vimrc_smartchr_init() "{{{3
  " http://d.hatena.ne.jp/ampmmn/20080925/1222338972
  " 演算子の間に空白を入れる
  "inoremap <buffer><expr> < search('^#include\%#', 'bcn')? ' <': smartchr#one_of(' < ', ' << ', '<')
  "inoremap <buffer><expr> > search('^#include <.*\%#', 'bcn')? '>': smartchr#one_of(' > ', ' >> ', '>')
  "inoremap <buffer><expr> + smartchr#one_of(' + ', '++', '+')
  "inoremap <buffer><expr> - smartchr#one_of(' - ', '--', '-')
  "inoremap <buffer><expr> / smartchr#one_of(' / ', '// ', '/')
  " *はポインタで使うので、空白はいれない
  "inoremap <buffer><expr> & smartchr#one_of(' & ', ' && ', '&')
  "inoremap <buffer><expr> % smartchr#one_of(' % ', '%')
  "inoremap <buffer><expr> , smartchr#one_of(', ', ',')
  " 3項演算子の場合は、後ろのみ空白を入れる
  "inoremap <buffer><expr> ? smartchr#one_of('? ', '?')
  "inoremap <buffer><expr> : smartchr#one_of(': ', '::', ':')

  " =の場合、単純な代入や比較演算子として入力する場合は前後にスペースをいれる。
  " 複合演算代入としての入力の場合は、直前のスペースを削除して=を入力
"  inoremap <buffer><expr> = search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '
"        \ : search('\(*\<bar>!\)\%#.', 'bcn') ? '= '
"        \ : smartchr#one_of(' = ', ' == ', '===', '=')

  " if文直後の(は自動で間に空白を入れる
  " inoremap <buffer><expr> ( search('\<\if\%#', 'bcn')? ' (': '('

endfunction

" unite.vim {{{2
LCAlias Unite
if s:bundle.tap('unite.vim')
  nnoremap [!unite] <Nop>
  nmap     f       [!unite]
  " define at clever-f
  " nnoremap [!unite]f f

  " unite basic settings {{{3
  let g:unite_data_directory = $VIM_CACHE . '/vim-unite'
  let g:unite_update_time=1000
  let g:unite_source_history_yank_enable=0
  "let g:unite_enable_start_insert=1
  let g:unite_enable_start_insert=0
  " let g:unite_source_file_mru_limit=100
  let g:unite_source_file_mru_limit=200
  let g:unite_source_file_mru_time_format = ''
  "let g:unite_source_file_mru_time_format = '%Y-%m-%d %H:%M:%S'
  let g:unite_winheight = 20
  " let g:unite_winwidth = &columns - 12
  "let g:unite_split_rule = 'botright'

  let g:unite_source_file_rec_max_cache_files = 5000

  " unite fn {{{3
  function! s:unite_grep(path, ...) "{{{4
    execute printf('Unite grep:%s %s', a:path, join(a:000, ' '))
  endfunction

  " unite-history
  let g:unite_source_history_yank_enable = 1


  " unite hooks.on_source {{{3
  function! s:bundle.tapped.hooks.on_source(bundle)
    " file_rec {{{4
    " call unite#custom#source('file_rec/async', 'ignore_pattern', '\.\(png\|gif\|jpeg\|jpg\|tiff\)$')
    " call unite#custom#source('file_rec', 'ignore_pattern', '\.\(png\|gif\|jpeg\|jpg\|tiff\)$')
    " call unite#custom#source('repo_files', 'ignore_pattern', '\.\(png\|gif\|jpeg\|jpg\|tiff\)$')

    call unite#custom#source('file',
          \ 'ignore_pattern',
          \ '\%(^\|/\)\.$\|\~$\|\.\%(o|exe|dll|bak|sw[po]\)$\|/chalice_cache/\|/-Tmp-/')

    call unite#custom#source('file_rec,file_rec/async,repo_files',
        \ 'ignore_pattern', join([
        \ '\.git/', '\.svn/', '\.hg/',
        \ '.ico', '.png', '.jpg',
        \ 'node_modules', 'bower_components', 'dist',
        \ 'coverage',
        \ '.sass_cache',
        \ ], '\|'))
    " files {{{4
    call unite#custom#profile('files', 'smartcase', 1)

    call unite#custom#substitute('files', '\$\w\+', '\=eval(submatch(0))', 200)

    call unite#custom#substitute('files', '[^~.]\zs/', '*/*', 20)
    call unite#custom#substitute('files', '/\ze[^*]', '/*', 10)

    call unite#custom#substitute('files', '^@@', '\=fnamemodify(expand("#"), ":p:h")."/*"', 2)
    call unite#custom#substitute('files', '^@', '\=getcwd()."/*"', 1)
    call unite#custom#substitute('files', '^\\', '~/*')
    call unite#custom#substitute('files', '^\~', escape($HOME, '\'), -2)

    call unite#custom#substitute('files', '^;v', '~/.vim/*')
    call unite#custom#substitute('files', '^;ft', '~/.vim/after/ftplugin/')
    call unite#custom#substitute('files', '^;r', '\=$VIMRUNTIME."/*"')
    if s:is_win
      call unite#custom#substitute('files', '^;p', 'C:/Program Files/*')
      if isdirectory(expand('$USERPROFILE/Desktop'))
        call unite#custom#substitute('files', '^;d', '\=expand("$USERPROFILE/Desktop/")."*"')
      else
        call unite#custom#substitute('files', '^;d', '\=expand("$USERPROFILE/デスクトップ/")."*"')
      endif
    else
      call unite#custom#substitute('files', '^;d', '\=$HOME."/Desktop/*"')
    endif
    " custom actions {{{4
    " custom action open_unite_file {{{5
    let s:unite_action_open_unite_file = {
          \ }
    function! s:unite_action_open_unite_file.func(candidate)
      " echoerr a:candicate.word
      let path = a:candidate.action__path
      execute 'Unite' 'file:'.path
    endfunction
    call unite#custom_action('directory', 'open_unite_file', s:unite_action_open_unite_file)
    unlet! s:unite_action_action_open_unite_file

    " custom action insert_or_narrow {{{5
    let s:unite_action_narrow_or_insert = {
          \ 'is_quit': 0
          \ }
    function! s:unite_action_narrow_or_insert.func(candidate)
      " echoerr a:candicate.word
      let path = a:candidate.action__path
      if isdirectory(path)
        call unite#take_action('narrow', a:candidate)
      else
        let context = unite#get_context()
        " call unite#close(context.buffer_name)
        call unite#take_action('insert', a:candidate)
      endif
    endfunction
    call unite#custom_action('file', 'narrow_or_insert', s:unite_action_narrow_or_insert)
    unlet! s:unite_action_narrow_or_insert

    " unite-menu {{{4
    if !exists("g:unite_source_menu_menus")
       let g:unite_source_menu_menus = {}
    endif
    " http://d.hatena.ne.jp/osyo-manga/20130225/1361794133
    function! s:unite_menu_create(desc, ...) "{{{5
      let commands = {
      \   'description' : a:desc,
      \}
      let commands.candidates = a:0 >= 1 ? a:1 : {}
      function commands.map(key, value)
        let [word, value] = a:value
        if isdirectory(value)
          return {
          \   "word" : "[directory] ".word,
          \   "kind" : "directory",
          \   "action__directory" : value
          \ }
        elseif !empty(glob(value))
          return {
          \   "word" : "[file] ".word,
          \   "kind" : "file",
          \   "default_action" : "tabdrop",
          \   "action__path" : value,
          \ }
        else
          return {
          \   "word" : "[command] ".word,
          \   "kind" : "command",
          \   "action__command" : value
          \ }
          endif
      endfunction
      return commands
    endfunction "5}}}
    " shortcut {{{5
    let g:unite_source_menu_menus["shortcut"] = s:unite_menu_create(
    \ 'Shortcut', [
    \   ["edit .vimrc"        , $MYVIMRC]                                  ,
    \   ["reload .vimrc"      , "source " . $MYVIMRC]                      ,
    \   ["edit .gvimrc"       , $MYGVIMRC]                                 ,
    \   ["VimFiler ~/.vim"    , "VimFiler " .$HOME . "/.vim"]              ,
    \   ["scriptnames"        , "Unite scriptnames"]                       ,
    \   ["neobundle vimfiles" , "Unite neobundle/vimfiles"]                ,
    \   ["all vimfiles"       , "Unite neobundle/rtpvimfiles"]             ,
    \   ["colorscheme"        , "Unite colorscheme -auto-preview"]         ,
    \   ["airline themes"     , "Unite airline_themes -auto-preview"]      ,
    \   ["global options"     , "Unite output:set"]                        ,
    \   ["local options"      , "Unite output:setlocal"]                   ,
    \   ["mappings"           , "Unite mapping"]                           ,
    \   ["todo"               , "Todo"]                                    ,
    \   ["repl"               , "Unite menu:repl"]                         ,
    \   ["vim help"           , "Unite menu:vimhelp"]                      ,
    \   ["os menu"            , "Unite menu:os"]                           ,
    \   ["fold"               , "Unite fold"]                              ,
    \   ["quickrun config"    , "Unite quickrun_config"]                   ,
    \ ])
    " vimhelp {{{5
    let g:unite_source_menu_menus["vimhelp"] = s:unite_menu_create(
    \ 'Help', [
    \   ['Vimscript functions' , 'help function-list']         ,
    \   ['Vimscript grammar'   , 'help usr_41']                ,
    \   ['Regexp'              , 'help pattern-overview']      ,
    \   ['quickkref'           , 'help quickref']              ,
    \   ['Option'              , 'help option-list']           ,
    \   ['Tips'                , 'help tips']                  ,
    \   ['User Manual'         , 'help usr_toc']               ,
    \   ['Startup Options'     , 'help startup-options']       ,
    \   ['Window'              , 'help windows']               ,
    \   ['Tab'                 , 'help tabpage']               ,
    \   ['Plugin'              , 'help write-plugin']          ,
    \   ['FtPlugin'            , 'help write-filetype-plugin'] ,
    \   ['Helpfile'            , 'help help-writing']          ,
    \ ])
    " repl {{{5
    let g:unite_source_menu_menus["repl"] = s:unite_menu_create(
    \ 'Repl', [
    \   ["irb"                , "VimShellInteractive irb --simple-prompt"] ,
    \   ["perl"               , "VimShellInteractive reply"]               ,
    \   ["javascript"         , "VimShellInteractive node"]                ,
    \   ["coffee"             , "VimShellInteractive coffee -i --nodejs"]                ,
    \   ["ghci"               , "VimShellInteractive ghci"]                ,
    \   ["python"             , "VimShellInteractive python"]              ,
    \   ["php"                , "VimShellInteractive phpa-norl"]           ,
    \   ["VimShellPop"        , "VimShellPop"]                             ,
    \   ["VimConsole"         , "VimConsoleOpen"]                          ,
    \ ])
    " os {{{5
    if s:is_win
      let g:unite_source_menu_menus["os"] = s:unite_menu_create(
            \ 'Windows', [
            \   ["irb"                , "VimShellInteractive irb --simple-prompt"] ,
            \ ])
    elseif s:is_mac
      let g:unite_source_menu_menus["os"] = s:unite_menu_create(
            \ 'Mac', [
            \   ["Library"              , "VimFiler ~/Library"]                                                  ,
            \   ["Desktop"              , "VimFiler ~/Desktop"]                                                  ,
            \   ["Downloads"            , "VimFiler ~/Downloads"]                                                ,
            \   ["Sites"                , "VimFiler ~/Sites"]                                                    ,
            \   ["Documents"            , "VimFiler ~/Documents"]                                                ,
            \   ["Log"                  , "VimFiler ~/Library/Logs/"]                                            ,
            \   ["SystemLog"            , "VimFiler /var/log/"]                                                  ,
            \   ["Keyremap4macbook xml" , "tabnew ~/Library/Application\\ Support/Keyremap4macbook/private.xml"] ,
            \ ])
    else
      let g:unite_source_menu_menus["os"] = s:unite_menu_create(
            \ 'Unix', [
            \   ["irb"                , "VimShellInteractive irb --simple-prompt"] ,
            \ ])
    endif

    " perl {{{5
    let g:unite_source_menu_menus["ft_perl"] = s:unite_menu_create(
    \ 'Perl Menu', [
    \   ["local module"  , "Unite perl/local"]  ,
    \   ["global module" , "Unite perl/global"] ,
    \ ])
    " ruby {{{5
    let g:unite_source_menu_menus["ft_ruby"] = s:unite_menu_create(
    \ 'Ruby Menu', [
    \   ["rake"             , "Unite rake"]              ,
    \   ["rails controller" , "Unite rails/controller"]  ,
    \   ["rails model"      , "Unite rails/model"]       ,
    \   ["rails view"       , "Unite rails/view"]        ,
    \   ["rails helper"     , "Unite rails/helper"]      ,
    \   ["rails lib"        , "Unite rails/lib"]         ,
    \   ['Add param'        , 'RAddParameter']           ,
    \   ['Split cond'       , 'RConvertPostConditional'] ,
    \   ['Extract let'      , 'RExtractLet']             ,
    \   ['Remove tmpvar'    , 'RInlineTemp']             ,
    \   ['chef attribute'   , 'ChefFindAttribute']       ,
    \   ['chef recipe'      , 'ChefFindRecipe']          ,
    \   ['chef definition'  , 'ChefFindDefinition']      ,
    \   ['chef lwrp'        , 'ChefFindLWRP']            ,
    \   ['chef source'      , 'ChefFindSource']          ,
    \   ['chef related'     , 'ChefFindRelated']         ,
    \ ])
    " vmap...
    " \   ['Extract constant', 'RExtractConstant'],
    " \   ['Rename local var', 'RRenameLocalVariable'],
    " \   ['Rename instance var', 'RRenameInstanceVariable'],
    " \   ['Rename instance var', 'RExtractMethod'],
    " java {{{5
    let g:unite_source_menu_menus["ft_java"] = s:unite_menu_create(
    \ 'Java Menu' , [
    \   ["import" , "Unite javaimport"] ,
    \   ["gradle" , "Unite gradle"]     ,
    \ ])
    " gitv {{{5
    let g:unite_source_menu_menus["ft_gitv"] = s:unite_menu_create(
    \ 'Gitv', [
    \ ['logview', "execute 'GitLogViewer' eval('GitvGetCurrentHash()')"],
    \ ['gbrowse', "execute 'Gbrowse' eval('GitvGetCurrentHash()')"],
    \ ['checkout', "execute 'Git checkout' eval('GitvGetCurrentHash())"],
    \ ['rebase', "execute 'Git rebase' eval('GitvGetCurrentHash())"],
    \ ['revert', "execute 'Git revert' eval('GitvGetCurrentHash())"],
    \ ['cherry-pick', "execute 'Git cherry-pick' eval('GitvGetCurrentHash())"],
    \ ['reset --hard', "execute 'Git reset --hard' eval('GitvGetCurrentHash())"],
    \ ])

    " let g:unite_source_menu_menus["ft_"] = s:unite_menu_create(
    " \ '', [
    " \  ["", ""],
    " \ ])

    function! s:unite_context_menu() "{{{6
      if !exists('g:unite_source_menu_menus["ft_' . &filetype . '"]')
        echohl Error
        echon "menu not found"
        echohl None
        return
      endif
      execute 'Unite' 'menu:'.'ft_'.&filetype
    endfunction "5}}}

    " memolist - http://d.hatena.ne.jp/osyo-manga/20130919 {{{4
    let g:unite_source_alias_aliases = {
    \  "memolist" : {
    \     "source" : "file",
    \     "args" : g:memolist_path,
    \  },
    \  "memolist_rec" : {
    \     "source" : "file_rec"
    \  },
    \}


    function! s:get_memolist_tags(filepath)
      return filereadable(a:filepath) ? matchstr(get(filter(readfile(a:filepath, "", 6), 'v:val =~ ''^tags: \[.*\]'''), 0), '^tags: \[\zs.*\ze\]') : ""
    endfunction

    let s:filter = {
    \  "name" : "converter_add_memolist_tags_word",
    \}

    function! s:filter.filter(candidates, context)
      for candidate in a:candidates
        if !has_key(candidate, "converter_add_ftime_word_base")
          let candidate.converter_add_ftime_word_base = candidate.word
        endif
        let word = get(candidate, "converter_add_ftime_word_base", candidate.action__path)
        let candidate.word = s:get_memolist_tags(get(candidate, "action__path")) . " " . word
      endfor
      return a:candidates
    endfunction

    call unite#define_filter(s:filter)
    unlet s:filter

    let s:filter = {
    \  "name" : "converter_add_memolist_tags_abbr",
    \}
    function! s:filter.filter(candidates, context)
      for candidate in a:candidates
        " if !has_key(candidate, "converter_add_ftime_word_base")
        "   let candidate.converter_add_ftime_word_base = candidate.abbr
        " endif
        let abbr = get(candidate, "abbr", candidate.word)
        let candidate.abbr = printf("%s %s", abbr, s:get_memolist_tags(get(candidate, "action__path")))
      endfor
      return a:candidates
    endfunction
    call unite#define_filter(s:filter)
    unlet s:filter

    let s:filter = {
    \  "name" : "converter_add_filename_word",
    \}
    function! s:filter.filter(candidates, context)
      for candidate in a:candidates
        " if !has_key(candidate, "converter_add_ftime_word_base")
        "   let candidate.converter_add_ftime_word_base = candidate.abbr
        " endif
        let abbr = get(candidate, "abbr", candidate.word)
        let candidate.abbr = printf("%s %s", abbr, fnamemodify(get(candidate, "action__path"), ":p:t"))
      endfor
      return a:candidates
    endfunction
    call unite#define_filter(s:filter)
    unlet s:filter

    call unite#custom_max_candidates("memolist", 500)
    call unite#custom#source('memolist', 'converters', ["converter_file_firstline_abbr", "converter_add_ftime_abbr", 'converter_add_memolist_tags_abbr'])
    call unite#custom#source('memolist', 'matchers', ["converter_file_firstline_word", "converter_add_memolist_tags_word", "matcher_default"])
    " call unite#custom#source('memolist', 'matchers', ["converter_file_firstline_word", "converter_add_memolist_tags_word", "converter_add_filename_word", "matcher_default"])
    " call unite#custom#source('memolist', 'converters', ["converter_file_firstline_abbr", "converter_add_ftime_abbr"])
    " call unite#custom#source('memolist', 'matchers', ["converter_file_firstline_word", "converter_add_memolist_tags_word", "matcher_default"])

    call unite#custom_max_candidates("memolist_rec", 50)
    call unite#custom#source('memolist_rec', 'converters', ["converter_file_firstline_abbr", "converter_add_ftime_abbr", 'converter_add_memolist_tags_abbr'])
    " call unite#custom#source('memolist_rec', 'converters', ["converter_file_firstline_abbr", "converter_add_ftime_abbr"])
    call unite#custom#source('memolist_rec', 'matchers', ["converter_file_firstline_word", "converter_add_memolist_tags_word", "matcher_default"])
    " 4}}}

  endfunction "3}}}

  " unite mappings {{{3
  function! s:unite_map(bang, prefix, key, ...) " {{{4
    if a:key[0] == "<"
      let key = empty(a:bang) ? a:key : substitute(a:key, "^<", "<S-", "")
      let bang_key = empty(a:bang) ? substitute(a:key, "^<", "<S-", "") : a:key
    else
      let key = empty(a:bang) ? a:key : toupper(a:key)
      let bang_key = empty(a:bang) ? toupper(a:key) : a:key
    endif
    let cmdargs = join(a:000, " ")
    let fmt = "%snoremap <silent> [!unite]%s :<C-u>Unite %s %s<CR>"

    exe printf(fmt, a:prefix, key, "", cmdargs)
    exe printf(fmt, a:prefix, bang_key, "-no-quit", cmdargs)
  endfunction " }}}
  command! -nargs=* -bang UniteNMap call s:unite_map("<bang>", "n", <f-args>)

  nmap [!unite]u  :<C-u>Unite<Space>

  " UniteNMap   s         source
  UniteNMap   <Space>   buffer
  UniteNMap   j         buffer_tab
  UniteNMap   k         tab
  UniteNMap   l         file -profile-name=files
  UniteNMap   d         directory_mru -default-action=vimfiler
  UniteNMap   zz        z -default-action=vimfiler
  UniteNMap   za        fold
  UniteNMap   <Leader>r quickrun_config
  UniteNMap   ;         file:<C-r>=expand('%:p:h')<CR> -profile-name=files
  UniteNMap   m         file_mru -default-action=open -profile-name=files
  UniteNMap   y         sonictemplate
  UniteNMap   c         webcolorname
  UniteNMap   i         jump
  UniteNMap   o         outline
  UniteNMap!  gg        grep:<C-r>=getcwd()<CR> -buffer-name=grep -auto-preview
  UniteNMap!  gr        grep -buffer-name=grep
  " UniteNMap!  gt        grep:<C-r>=getcwd()<CR>:TODO\|FIXME\|XXX\|NOTE\|!!!\|\?\?\? -buffer-name=todo -auto-preview
  " UniteNMap   gl        grep_launcher
  UniteNMap!  gl        line -start-insert
  UniteNMap!  gi        git_grep -buffer-name=git_grep
  UniteNMap!  tt        gtags/context -buffer-name=tag
  UniteNMap!  tr        gtags/ref -buffer-name=tag
  UniteNMap!  td        gtags/def -buffer-name=tag
  UniteNMap!  tg        gtags/grep -buffer-name=tag
  UniteNMap!  ti        gtags/completion -buffer-name=tag
  UniteNMap!  q         quickfix -buffer-name=qfix
  UniteNMap   p         history/yank
  " UniteNMap   @         quickrun_config
  " UniteNMap   :         history/command command
  " UniteNMap   /         history/search
  UniteNMap   bb        bookmark -default-action=open
  if s:is_win
    UniteNMap ,         everything -start-insert
  elseif s:is_mac
    UniteNMap ,         spotlight -start-insert
  else
    UniteNMap ,         locate -start-insert
  endif

  nnoremap <silent> [!unite]ba :<C-u>UniteBookmarkAdd<CR>
  " UniteNMap   rr        quicklearn -immediately
  nnoremap [!space]R :<C-u>Unite quicklearn -immediately<CR>
  nnoremap <Leader>qr :<C-u>Unite quicklearn -immediately<CR>

  nnoremap <silent> [!unite]v :Unite menu:shortcut<CR>
  nnoremap <silent> [!unite]V :call <SID>unite_context_menu()<CR>

  " filepath insert TODO : don't works well...--;
  nnoremap <C-y><C-f> :<C-u>Unite -default-action=narrow_or_insert file<CR>
  inoremap <C-y><C-f> <C-o>:<C-u>Unite -default-action=narrow_or_insert file<CR>

  " Alias colorscheme Unite colorscheme -auto-preview

  " if s:bundle.is_installed('vimproc.vim')
  "   UniteNMap a file_rec/async -start-insert
  " else
  UniteNMap a file_rec -start-insert
  " endif

  " nnoremap <silent> [!unite]h  :<C-u>UniteWithCursorWord help:ja help<CR>
  " nnoremap <silent> [!unite]hh :<C-u>call <SID>unite_ref_filetype()<CR>
  nnoremap <silent> [!unite]hh :<C-u>call <SID>unite_ref_callable()<CR>
  nnoremap <silent> [!unite]he :<C-u>Unite help<CR>
  nnoremap <silent> [!unite]hk :<C-u>Unite mapping<CR>

  function! s:unite_ref_callable(...) "{{{4
    let kwd = ""
    if a:0 > 0
      let isk = &l:isk
      setlocal isk& isk+=- isk+=. isk+=:
      let kwd = expand('<cword>')
      let &l:isk = isk
    endif
    let name = ref#detect()
    let names = type(name) == s:type_s ? [name] : name
    unlet name

    let completable = keys(filter(ref#available_sources(), 'exists("v:val.complete")'))
    let sources = filter(names, 'index(completable, v:val) != -1')
    unlet names

    if !empty(sources)
      let source = join(map(sources, '"ref/".v:val'), ' ')
      execute printf('Unite -default-action=below -input=%s %s', kwd, source)
    else
      echohl Error
      echomsg "Not Found : ref source"
      echohl Normal
    endif
    unlet kwd completable sources source
  endfunction

  function! s:unite_ref_filetype() " {{{4
    let ft = &ft
    let names = []

    let isk = &l:isk
    setlocal isk& isk+=- isk+=. isk+=:
    let kwd = expand('<cword>')
    let &l:isk = isk

    let types = ref#detect()
    if s:type_s == type(types)
      unlet types
      let types = ['man']
    endif
    let types = filter(types, 'type(ref#available_sources(v:val)) == s:type_h')
    if !empty(types)
      execute 'Unite' '-default-action=below' '-input='.kwd join(map(types, '"ref/".v:val'), ' ')
    else
      echohl Error
      echomsg "Not Found : ref source"
      echohl Normal
    endif
  endfunction "}}}

  nnoremap          [!unite]rr :<C-u>UniteResume<Space>
  nnoremap <silent> [!unite]re :<C-u>UniteResume<CR>
  nnoremap <silent> [!unite]ri :<C-u>UniteResume git<CR>
  nnoremap <silent> [!unite]rg :<C-u>UniteResume grep<CR>
  nnoremap <silent> [!unite]rt :<C-u>UniteResume todo<CR>
  nnoremap <silent> [!unite]rq :<C-u>UniteResume qfix<CR>

  if s:bundle.is_installed('neocomplcache.vim')
    inoremap <C-x><C-j> <C-o>:Unite neocomplcache -buffer-name=completition -start-insert<CR>
    inoremap <C-x>i <C-o>:Unite neocomplcache -buffer-name=completition -start-insert<CR>
  elseif s:bundle.is_installed('neocomplete.vim')
    inoremap <C-x><C-j> <C-o>:Unite neocomplete -buffer-name=completition -start-insert<CR>
    inoremap <C-x>i <C-o>:Unite neocomplete -buffer-name=completition -start-insert<CR>
  endif

  command! Todo silent! exe 'Unite' printf('grep:%s::%s', getcwd(), s:regexp_todo) '-buffer-name=todo' '-no-quit'

  function! s:unite_open_ftplugin()
    let dirs = ['after', 'ftplugin', 'snippets', 'template', 'sonictemplate']
    execute 'Unite' '-input='.&filetype join(map(dirs, '"file_rec:~/.vim/".v:val'), " ")
  endfunction
  " nnoremap <silent> [!unite]v  :<C-u>call <SID>unite_open_ftplugin()<CR>
  " nnoremap <silent> [!unite]V  :<C-u>Unite file:~/.vim/<CR>
  " nnoremap <silent> [!unite]v  :<C-u>Unite scriptnames<CR>
  " nnoremap <silent> [!unite]V  :<C-u>call <SID>unite_open_ftplugin()<CR>
  " nnoremap <silent> [!unite]v  :<C-u>Unite file_rec:~/.vim/after file_rec:~/.vim/ftplugin<CR>

  " http://d.hatena.ne.jp/osyo-manga/20120205/1328368314 "{{{3
  function! s:tags_update()
      " include している tag ファイルが毎回同じとは限らないので毎回初期化
      setlocal tags=
      if s:bundle.is_installed('neocomplcache.vim')
        for filename in neocomplcache#sources#include_complete#get_include_files(bufnr('%'))
            execute "setlocal tags+=".neocomplcache#cache#encode_name('tags_output', filename)
        endfor
      elseif s:bundle.is_installed('neocomplete.vim')
        for filename in neocomplete#sources#include#get_include_files(bufnr('%'))
            execute "setlocal tags+=".neocomplete#cache#encode_name('tags_output', filename)
        endfor
      endif
  endfunction

  command!
      \ -nargs=? PopupTags
      \ call <SID>tags_update() | Unite tag:<args>

  function! s:get_func_name(word)
      let end = match(a:word, '<\|[\|(')
      return end == -1 ? a:word : a:word[ : end-1 ]
  endfunction

  " カーソル下のワード(word)で絞り込み
  nnoremap <silent> [!unite]] :<C-u>execute "PopupTags ".expand('<cword>')<CR>

  " カーソル下のワード(WORD)で ( か < か [ までが現れるまでで絞り込み
  nnoremap <silent> [!unite]<C-]> :<C-u>execute "PopupTags "
      \.substitute(<SID>get_func_name(expand('<cWORD>')), '\:', '\\\:', "g")<CR>

  call s:bundle.untap()
endif
" cmd-t/r {{{3
function! s:get_cmd_t_key(key)
  return printf("<%s-%s>", has('gui_macvim') ? "D" : "A", a:key)
endfunction
function! s:unite_project_files(...)
  let opts = (a:0 ? join(a:000, ' ') : '')
  let dir = unite#util#path2project_directory(expand('%'))
  execute 'Unite' opts 'file_rec:' . dir
endfunction
" execute 'nnoremap' '<silent>' s:get_cmd_t_key("t") ":<C-u>call <SID>unite_project_files('-start-insert')<CR>"
execute 'nnoremap' '<silent>' s:get_cmd_t_key("t") ":<C-u>Unite repo_files -start-insert<CR>"
execute 'nnoremap' '<silent>' s:get_cmd_t_key("r") ':<C-u>Unite outline -start-insert<CR>'

MyAutoCmd FileType unite call s:vimrc_unite_init() "{{{3
function! s:vimrc_unite_init()

  imap <buffer> jj <Plug>(unite_insert_leave)j
  imap <buffer> qq <Plug>(unite_exit)
  imap <buffer> ]] <C-o><Plug>(unite_rotate_next_source)
  imap <buffer> [[ <C-o><Plug>(unite_rotate_previous_source)
  imap <buffer> <ESC> <ESC><ESC>

  nmap <buffer><nowait> q <Plug>(unite_exit)
  nnoremap <silent><buffer><expr> <C-j> unite#do_action('split')
  inoremap <silent><buffer><expr> <C-j> unite#do_action('split')
  nmap <buffer> t <Plug>(unite_choose_action)
  nmap <buffer> l <Plug>(unite_do_default_action)
  nmap <buffer> P <Plug>(unite_toggle_auto_preview)
  if s:bundle.is_installed('vim-smartinput') && exists(':SmartinputBufferMapClear')
    SmartinputBufferMapClear i
  endif
endfunction

" milkode http://qiita.com/items/abe5df7c5b21160532b8 "{{{3
if executable('gmilk')
  " gmilk コマンドの結果をUnite qf で表示する
  command! -nargs=1 Gmilk call <SID>run_gmilk("gmilk -a -n 200", <f-args>)

  function! s:run_gmilk(cmd, arg)
    silent execute "cgetexpr system(\"" . a:cmd . " ". a:arg . "\")"
    if len(getqflist()) == 0
      echohl WarningMsg
      echomsg "No match found."
      echohl None
    else
      execute "Unite -auto-preview qf"
      redraw!
    endif
  endfunction
endif

" git-vim {{{2
" let g:git_no_map_default = 1
" let g:git_command_edit = 'rightbelow vnew'
" nnoremap [!space]gd :<C-u>GitDiff --cached<Enter>
" nnoremap [!space]gD :<C-u>GitDiff<Enter>
" nnoremap [!space]gs :<C-u>GitStatus<Enter>
" nnoremap [!space]gl :<C-u>GitLog<Enter>
" nnoremap [!space]gL :<C-u>GitLog -u \| head -10000<Enter>
" nnoremap [!space]ga :<C-u>GitAdd<Enter>
" nnoremap [!space]gA :<C-u>GitAdd <cfile><Enter>
" nnoremap [!space]gc :<C-u>GitCommit<Enter>
" nnoremap [!space]gC :<C-u>GitCommit --amend<Enter>
" nnoremap [!space]gp :<C-u>Git push

" fugitive.vim {{{2
function! s:git_qfix(...)
  let word = input("Pattern: ")
  if empty(word)
    echoerr "abort"
  endif
  execute 'silent' call('printf', copy(a:000) + [word])
  Unite -no-quit quickfix
endfunction

nnoremap <silent> [!space]gd :<C-u>Gdiff --cached<CR>
nnoremap <silent> [!space]gD :<C-u>Gdiff<CR>
nnoremap <silent> [!space]gs :<C-u>Gstatus<CR>
nnoremap [!space]gl :<C-u>silent Glog <Bar> Unite -no-quit quickfix<CR>
nnoremap [!space]gL :<C-u>silent Glog -- <Bar> Unite -no-quit quickfix<CR>
nnoremap [!space]gg :<C-u>call <SID>git_qfix('Ggrep -i "%s"')<CR>
nnoremap [!space]ggr :<C-u>Unite -no-quit -start-insert vcs_grep<CR>
nnoremap [!space]ggm :<C-u>call <SID>git_qfix('Glog --grep="%s"')<CR>
nnoremap [!space]ggl :<C-u>call <SID>git_qfix('Glog -S="%s"')<CR>
nnoremap [!space]gR :<C-u>Gremove<CR>
nnoremap [!space]gm :<C-u>Gmove<Space>
nnoremap [!space]ga :<C-u>Gwrite<CR>
nnoremap [!space]gA :<C-u>Gwrite <cfile><CR>
nnoremap <silent> [!space]gc :<C-u>Gcommit<CR>
nnoremap <silent> [!space]gC :<C-u>Gcommit --amend<CR>
nnoremap <silent> [!space]gb :<C-u>Gblame<CR>
nnoremap <silent> [!space]gB :<C-u>Gbrowse<CR>
nnoremap <silent> [!space]gp :<C-u>Git push
nnoremap <silent> [!space]ge :<C-u>Gedit<Space>
nnoremap <silent> [!space]gv :<C-u>Gitv<CR>
nnoremap <silent> [!space]gV :<C-u>Gitv!<CR>
command! Gdiffoff diffoff | q | Gedit
function! s:vimrc_git_init()
  setl foldmethod=expr
  " setl foldexpr=getline(v:lnum)!~'^commit'
  setlocal foldexpr=GitLogViewerFoldExpr(v:lnum)
  setlocal foldtext=GitLogViewerFoldText()
endfunction
MyAutoCmd FileType git call s:vimrc_git_init()
function! s:vimrc_fugitive_bufread_init()
  if exists('b:fugitive_type')
    if b:fugitive_type == "commit"
      " if exists('b:fugitive_display_format') && !b:fugitive_display_format
      "   normal a
      " endif
      normal! G
      if line('.') == 3
        setlocal modifiable
        normal! o
        execute "r! git show --no-color " . fugitive#buffer().sha1()
        setlocal nomodified nomodifiable
      endif
      normal! gg
    endif
  endif
endfunction
" MyAutoCmd BufReadPost  fugitive://**//[0-9a-f][0-9a-f]* call s:vimrc_fugitive_bufread_init()
" MyAutoCmd User Fugitive call s:vimrc_fugitive_init()

" TOhtml {{{2
let g:html_number_lines = 0
let g:html_use_css = 1
let g:use_xhtml = 1
let g:html_use_encoding = 'utf-8'

" tagbar taglist {{{2
" basic options {{{3
function! s:setup_tags()
  set tags+=./tags,tags
  for f in split("\n", glob($HOME . '/.java-dev/tags/*'))
    execute 'set' 'tags+='.f
  endfor
endfunction
call s:setup_tags()

if s:bundle.is_installed('taglist.vim') "{{{4
  let g:Tlist_Auto_Update = 1
  let g:Tlist_Show_One_File = 0
  let g:Tlist_Exit_OnlyWindow = 1
  let g:Tlist_Use_Right_Window = 0
  let g:Tlist_WinWidth = 25

  let g:tlist_objc_settings='objc;P:protocols;i:interfaces;I:implementations;M:instance methods;C:implementation methods;Z:protocol methods;v:property'
  let g:tlist_ruby_settings='Ruby;c:classes;f:methods;m:modules;F:singleton methods;r:regex'
  let g:tlist_javascript_settings='js;o:object;f:function;a:array;s:string;b:boolean;n:number;v:variable'
  " let g:tlist_javascript_settings='JavaScript;f:functions;c:classes;m:methods;p:properties;v:global variables;I:inner'
  let g:tlist_coffee_settings='coffee;c:class;n:namespace;f:function;m:method;v:var;i:ivar'
  " let g:tlist_scala_settings = 'scala;t:trait;c:class;T:type;m:method;C:constant;l:local;p:package;o:object'
  let g:tlist_scala_settings='scala;c:classes;o:objects;t:traits;r:cclasses;a:aclasses;m:methods;V:values;v:variables;T:types;i:includes;p:packages'
  let g:tlist_actionscript_settings='actionscript;f:functions;p:properties;v:variables;r:function, functions;c:classes'
  let g:tlist_tex_settings='Tex;c:chapters;s:sections;u:subsections;b:subsubsections;p:parts;P:paragraphs;G:subparagraphs'
  let g:tlist_make_settings='Make;m:macros;t:targets'
  let g:tlist_ant_settings='Ant;p:projects;t:targets'
  let g:tlist_typescript_settings='typescript;c:classes;n:modules;f:functions;v:variables;m:members;i:interfaces;e:enums'
  let g:tlist_haxe_settings='haxe;p:package;f:function;v:variable;p:package;c:class;i:interface;t:typedef'

  if s:is_mac && executable('/Applications/MacVim.app/Contents/MacOS/ctags')
    let g:Tlist_Ctags_Cmd='/Applications/MacVim.app/Contents/MacOS/ctags'
  endif
  nnoremap <silent> [!prefix]tt :<C-u>TlistToggle<CR>
  nnoremap <silent> [!prefix]to :<C-u>TlistOpen<CR>1<C-w>h
else "{{{4
  let g:tagbar_type_objc = {
        \ 'ctagstype' : 'objc',
        \ 'kinds'     : [
        \   'P:protocols',
        \   'i:interfaces',
        \   'I:implementations',
        \   'M:instance methods',
        \   'C:implementation methods',
        \   'Z:protocol methods',
        \   'v:property',
        \ ]}
  let g:tagbar_type_ruby = {'ctagstype': 'Ruby', 'kinds':
        \   ['c:classes', 'f:methods', 'm:modules', 'F:singleton methods', 'r:regex']
        \ }
  let g:tagbar_type_javascript = {
        \ 'ctagstype' : 'js',
        \ 'kinds'     : [
        \   'o:object',
        \   'f:function',
        \   'a:array',
        \   's:string',
        \   'v:variable',
        \   'b:boolean',
        \   'n:number',
        \ ]}
  " let g:tagbar_type_javascript = {'ctagstype': 'JavaScript',
  "       \   'kinds': ['f:functions', 'c:classes', 'm:methods', 'p:properties', 'v:global variables', 'I:inner'] }
  if executable('coffeetags')
    let g:tagbar_type_coffee = {
          \ 'ctagsbin' : 'coffeetags',
          \ 'ctagsargs' : '',
          \ 'kinds' : [
          \   'f:functions',
          \   'o:object',
          \ ],
          \ 'sro' : ".",
          \ 'kind2scope' : {
          \   'f' : 'object',
          \   'o' : 'object',
          \ }
          \ }
  else
    let g:tagbar_type_coffee = {'ctagstype': 'coffee',
          \   'kinds': ['c:class', 'n:namespace', 'f:function', 'm:method', 'v:var', 'i:ivar'] }
  endif
  let g:tagbar_type_scala = {'ctagstype': 'scala',
        \   'kinds': ['c:classes', 'o:objects', 't:traits', 'r:cclasses',
        \   'a:aclasses', 'm:methods', 'V:values', 'v:variables',
        \   'T:types', 'i:includes', 'p:packages'] }
  let g:tagbar_type_actionscript = {'ctagstype': 'actionscript',
        \   'kinds': ['f:functions', 'p:properties', 'v:variables',
        \   'r:function, functions', 'c:classes'] }
  let g:tagbar_type_tex = {
        \ 'ctagstype' : 'latex',
        \   'kinds': ['c:chapters', 's:sections', 'u:subsections', 'b:subsubsections',
        \   'p:parts', 'P:paragraphs', 'G:subparagraphs'] }
  let g:tagbar_type_make = { 'ctagstype' : 'make',
        \   'kinds': ['m:macros', 't:targets'] }
  let g:tagbar_type_ant = {'ctagstype': 'Ant',
        \   'kinds': ['p:projects', 't:targets'] }
  let g:tagbar_type_typescript = {'ctagstype': 'typescript',
        \   'kinds': ['c:classes', 'n:modules', 'f:functions', 'v:variables', 'm:members',
        \   'i:interfaces', 'e:enums'] }
  let g:tagbar_type_haxe = {'ctagstype': 'haxe', 'kinds': [
        \ 'p:package', 'f:function', 'v:variable', 'p:package', 'c:class', 'i:interface', 't:typedef',
        \ ] }

  " let g:tagbar_type_xxx = {
  "       \ 'ctagstype' : '',
  "       \ 'kinds'     : [
  "       \   '',
  "       \ ]}

  if s:is_mac && executable('/Applications/MacVim.app/Contents/MacOS/ctags')
    " let g:Tlist_Ctags_Cmd='/Applications/MacVim.app/Contents/MacOS/ctags'
    let g:tagbar_ctags_bin='/Applications/MacVim.app/Contents/MacOS/ctags'
  endif
  nnoremap <silent> [!prefix]tt :<C-u>TagbarToggle<CR>
  nnoremap <silent> [!prefix]to :<C-u>TagbarOpen<CR>1<C-w>h
endif "}}}

" SrcExpl {{{2
nnoremap <silent> [!prefix]t<Space> :<C-u>SrcExplToggle<CR>
let g:SrcExpl_refreshTime = 1000

" surround.vim {{{2
nmap ss <Plug>Yssurround
" nmap ss <Plug>Ysurround
imap <C-g>y <Esc><Plug>Yssurround

let g:surround_custom_mapping = {}
let g:surround_custom_mapping._ = {
      \ "\<CR>" : "\n\r\n",
      \ 'g':  "_('\r')",
      \ 'G':  "_(\"\r\")",
      \ '!':  "<!-- \r -->",
      \ }
let g:surround_custom_mapping.html = {
      \ '1':  "<h1>\r</h1>",
      \ '2':  "<h2>\r</h2>",
      \ '3':  "<h3>\r</h3>",
      \ '4':  "<h4>\r</h4>",
      \ '5':  "<h5>\r</h5>",
      \ '6':  "<h6>\r</h6>",
      \ 'p':  "<p>\r</p>",
      \ 'u':  "<ul>\r</ul>",
      \ 'o':  "<ol>\r</ol>",
      \ 'l':  "<li>\r</li>",
      \ 'a':  "<a href=\"\">\r</a>",
      \ 'A':  "<a href=\"\r\"></a>",
      \ 'i':  "<img src=\"\r\" alt=\"\" />",
      \ 'I':  "<img src=\"\" alt=\"\r\" />",
      \ 'd':  "<div>\r</div>",
      \ 'D':  "<div class=\"selection\">\r</div>",
      \ '%':  "<?php \r ?>",
      \ '#':  "<?php # \r ?>",
      \ '/':  "<?php // \r ?>",
      \ '=':  "<?php echo \r ?>",
      \ }
let g:surround_custom_mapping.help = {
      \ 'p':  "> \r <",
      \ }
let g:surround_custom_mapping.ruby = {
      \ '-':  "<% \r %>",
      \ '=':  "<%= \r %>",
      \ '9':  "(\r)",
      \ '5':  "%(\r)",
      \ '%':  "%(\r)",
      \ 'w':  "%w(\r)",
      \ '#':  "#{\r}",
      \ '3':  "#{\r}",
      \ 'e':  "begin \r end",
      \ 'E':  "<<EOS \r EOS",
      \ 'i':  "if \1if\1 \r end",
      \ 'u':  "unless \1unless\1 \r end",
      \ 'c':  "class \1class\1 \r end",
      \ 'm':  "module \1module\1 \r end",
      \ 'd':  "def \1def\1\2args\r..*\r(&)\2 \r end",
      \ 'p':  "\1method\1 do \2args\r..*\r|&| \2\r end",
      \ 'P':  "\1method\1 {\2args\r..*\r|&|\2 \r }",
      \ }
let g:surround_custom_mapping.eruby = {
      \ '-':  "<% \r %>",
      \ '=':  "<%= \r %>",
      \ '#':  "<%# \r %>",
      \ 'h':  "<%= h \r %>",
      \ 'e':  "<% \r %>\n<% end %>",
      \ }
let g:surround_custom_mapping.markdown = {
      \ 'h': "`\r`",
      \ 'c': "```\n\r\n```",
      \ '!':  "<!-- \r -->",
      \ }
let g:surround_custom_mapping.php = {
      \ '-':  "<?php \r ?>",
      \ '=':  "<?php echo \r ?>",
      \ 'h':  "<?php echo h( \r ); ?>",
      \ 'e':  "<?php echo \r ?>",
      \ 'f':  "<?php foreach ($\r as $val): ?>\n<?php endforeach; ?>",
      \ '%':  "<?php \r ?>",
      \ '#':  "<?php # \r ?>",
      \ '/':  "<?php // \r ?>",
      \ }
let g:surround_custom_mapping.javascript = {
      \ 'f':  "function(){ \r }"
      \ }
let g:surround_custom_mapping.lua = {
      \ 'f':  "function(){ \r }"
      \ }
let g:surround_custom_mapping.python = {
      \ 'p':  "print( \r)",
      \ '[':  "[\r]",
      \ }
let g:surround_custom_mapping.vim= {
      \'f':  "function! \r endfunction"
      \ }

" operator {{{2
" http://labs.timedia.co.jp/2011/07/vim-excel-and-sql.html
if s:bundle.is_installed('vim-operator-user')
  call operator#user#define('excelize', 'OperatorExcelize')
  function! OperatorExcelize(motion_wise)
    let b = line("'[")
    let e = line("']")
    execute b ',' e 'substitute/\v(\''?)(\$?\u+\$?\d+)(\''?)/\1" \& \2 \& "\3/g'
    execute b 'substitute/^/="/'
    execute e 'substitute/$/"/'
  endfunction

  call operator#user#define_ex_command('retab', 'retab')
  call operator#user#define_ex_command('join', 'join')
  call operator#user#define_ex_command('uniq', 'sort u')
  call operator#user#define_ex_command('trimright', 's/\s\+$//')

  map _ <Plug>(operator-replace)
  map ;e <Plug>(operator-excelize)
  map ;h <Plug>(operator-html-escape)
  map ;H <Plug>(operator-html-unescape)
  map ;c <Plug>(operator-camelize)
  map ;C <Plug>(operator-decamelize)
  map ;<C-i> <Plug>(operator-retab)
  map ;j <Plug>(operator-join)
  map ;u <Plug>(operator-uniq)
  map ;k <Plug>(operator-trimright)

  map <Leader>tm <Plug>(operator-tabular-tsv2md))
  map <Leader>Tm <Plug>(operator-tabular-md2tsv)
  map <Leader>nm <Plug>(operator-normalize_utf8mac)
  map ;s <Plug>(operator-shuffle)

  if s:bundle.is_installed('vim-operator-surround')
    map <silent>sa <Plug>(operator-surround-append)
    map <silent>sd <Plug>(operator-surround-delete)
    map <silent>sr <Plug>(operator-surround-replace)
    map <silent>sba <Plug>(operator-surround-append)<Plug>(textobj-multiblock-a)
    map <silent>sbd <Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)
    map <silent>sbr <Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)
  endif
endif

" textobj {{{2
if s:bundle.is_installed('vim-textobj-user')
  function! s:textobj_mapping(key, cmd)
    silent exe 'omap' a:key a:cmd
    silent exe 'vmap' a:key a:cmd
    " silent exe 'xmap' a:key a:cmd
    " silent exe 'smap' a:key a:cmd
  endfunction
  command! -nargs=+ Tmap call s:textobj_mapping(<f-args>)
  function! s:textobj_mapping_by_name(key, name)
    call s:textobj_mapping('i'.a:key, '<Plug>(textobj-' . a:name . '-i)')
    call s:textobj_mapping('a'.a:key, '<Plug>(textobj-' . a:name . '-a)')
  endfunction
  command! -nargs=+ TTmap call s:textobj_mapping_by_name(<f-args>)

  Tmap if <Plug>(textobj-function-i)
  Tmap af <Plug>(textobj-function-a)
  Tmap ii <Plug>(textobj-indent-i)
  Tmap ai <Plug>(textobj-indent-a)

  " Tmap a/ <Plug>(textobj-lastpat-n)
  " Tmap i/ <Plug>(textobj-lastpat-n)
  " Tmap a? <Plug>(textobj-lastpat-N)
  " Tmap i? <Plug>(textobj-lastpat-N)

  TTmap e entire
  nnoremap <silent> yie :<C-u>call <SID>execute_motionless("normal y\<Plug>(textobj-entire-i)")<CR>
  nnoremap <silent> yae :<C-u>call <SID>execute_motionless("normal y\<Plug>(textobj-entire-a)")<CR>
  TTmap y syntax
  TTmap ,_ quoted
  TTmap f function

  " TTmap e entire
  TTmap ,, parameter
  " TTmap l line
  TTmap ,b between
  TTmap ,f fold
  TTmap q enclosedsyntax
  " TTmap b multiblock
  TTmap b multitextobj
  TTmap ,w wiw
  TTmap u lastinserted
  TTmap U url
  TTmap # ifdef
  Tmap ixx <Plug>(textobj-context-i)

  Tmap axa <Plug>(textobj-xmlattribute-xmlattribute)
  Tmap ixa <Plug>(textobj-xmlattribute-xmlattributenospace)
  " TTmap m  motionmotion

  TTmap P php-phptag
  TTmap aP php-phparray

  " let g:textboj_ _no_default_key_mappings=1
  " let g:textboj_datetime_no_default_key_mappings=1
  " let g:textboj_jabraces_no_default_key_mappings=1

  let g:textboj_syntax_no_default_key_mappings=1
  let g:textboj_quoted_no_default_key_mappings=1
  let g:textboj_function_no_default_key_mappings=1

  " let g:textobj_entire_no_default_key_mappings=1
  let g:textobj_parameter_no_default_key_mappings=1
  let g:textobj_line_no_default_key_mappings=1
  let g:textobj_between_no_default_key_mappings=1
  let g:textboj_fold_no_default_key_mappings=1
  let g:textboj_enclosedsyntax_no_default_key_mappings=1
  let g:textboj_multiblock_no_default_key_mappings=1
  let g:textobj_wiw_no_default_key_mappings=1
  let g:textboj_lastinserted_no_default_key_mappings=1
  let g:textboj_url_no_default_key_mappings=1
  let g:textboj_ifdef_no_default_key_mappings=1
  let g:textboj_context_no_default_key_mappings=1
  " let g:textboj_xbrackets_no_default_key_mappings=1
  let g:textboj_php_no_default_key_mappings=1

  let g:textobj_multiblock_blocks = [
  \ [ '(', ')' ],
  \ [ '[', ']' ],
  \ [ '{', '}' ],
  \ [ '<', '>', 1 ],
  \ [ '"', '"', 1 ],
  \ [ "'", "'", 1 ],
  \ [ "_", "_", 1 ],
  \]

  let g:textobj_multitextobj_textobjects_i = [
  \ "\<Plug>(textobj-url-i)",
  \ "\<Plug>(textobj-multiblock-i)",
  \ "\<Plug>(textobj-ruby-any-i)",
  \ "\<Plug>(textobj-function-i)",
  \ "\<Plug>(textobj-indent-i)",
  \]
  " \ "\<Plug>(textobj-entire-i)",

  let g:textobj_multitextobj_textobjects_a = [
  \ "\<Plug>(textobj-url-a)",
  \ "\<Plug>(textobj-multiblock-a)",
  \ "\<Plug>(textobj-ruby-any-i)",
  \ "\<Plug>(textobj-function-a)",
  \ "\<Plug>(textobj-indent-i)",
  \]
  " \ "\<Plug>(textobj-entire-a)",

  let g:textobj_multitextobj_textobjects_group_i = {
  \ "A" : [
  \   "\<Plug>(textobj-url-i)",
  \   "\<Plug>(textobj-wiw-i)",
  \   "iw",
  \ ]
  \}
endif

" vim-niceblock {{{2
if s:bundle.is_installed('vim-niceblock')
  xmap I <Plug>(niceblock-I)
  xmap A <Plug>(niceblock-A)
endif

" ref.vim {{{2
if s:bundle.is_installed('vim-ref')
  let g:ref_open = '8split'
  let g:ref_cache_dir = $VIM_CACHE . '/vim-ref'
  if !exists('g:ref_detect_filetype')
    let g:ref_detect_filetype = {}
  endif
  let g:ref_detect_filetype._ = 'webdict'
  let g:ref_use_vimproc = 0
  let g:ref_alc_use_cache = 1
  let g:ref_alc_start_linenumber = 43

  if s:bundle.is_installed('vimproc.vim')
    let g:ref_use_vimproc = 1
  endif

  " options {{{3
  " webdict {{{4
  if s:is_win
    " for w3m
    let $LANG='C.UTF-8'
    let g:ref_source_webdict_encoding = 'utf-8'
  endif
  let g:ref_source_webdict_sites = {
        \   'alc' : {
        \     'url': 'http://eow.alc.co.jp/%s',
        \     'keyword_encoding,': 'utf-8',
        \     'cache': 1,
        \   },
        \   'weblio': {
        \     'url': 'http://ejje.weblio.jp/content/%s',
        \     'keyword_encoding': 'utf-8',
        \     'cache': 1,
        \   },
        \   'wikipedia': {
        \     'url': 'http://ja.wikipedia.org/wiki/%s',
        \     'keyword_encoding': 'utf-8',
        \     'cache': '0',
        \   },
        \   'wikipedia:en': {
        \     'url': 'http://en.wikipedia.org/wiki/%s',
        \     'keyword_encoding': 'utf-8',
        \     'cache': '0',
        \   },
        \   'wiktionary': {
        \     'url': 'http://ja.wiktionary.org/wiki/%s',
        \     'keyword_encoding': 'utf-8',
        \     'cache': '0',
        \   },
        \   'ja_en': {
        \     'url': 'http://translate.google.co.jp/m?hl=ja\&sl=ja\&tl=en\&ie=UTF-8\&prev=_m\&q=%s',
        \     'keyword_encoding': 'utf-8',
        \     'cache': '0',
        \   },
        \   'en_ja': {
        \     'url': 'http://translate.google.co.jp/m?hl=ja\&sl=en\&tl=ja\&ie=UTF-8\&prev=_m\&q=%s',
        \     'keyword_encoding': 'utf-8',
        \     'cache': '0',
        \   },
        \   'ruby_toolbox': {
        \     'url': 'https://www.ruby-toolbox.com/search?utf8=%%E2%%9C%%93\&q=%s',
        \     'keyword_encoding': 'utf-8',
        \     'cache': '0',
        \   },
        \   'rurema': {
        \     'url': 'http://doc.ruby-lang.org/ja/search/query:%s/',
        \     'keyword_encoding': 'utf-8',
        \     'cache': '0',
        \   },
        \   'rubygems': {
        \     'url': 'http://rubygems.org/search?query=%s',
        \     'keyword_encoding': 'utf-8',
        \     'cache': '0',
        \   },
        \   'node_toolbox': {
        \     'url': 'http://nodetoolbox.com/search?q=%s',
        \     'keyword_encoding': 'utf-8',
        \     'cache': '0',
        \   },
        \   'chef_cookbooks': {
        \     'url': 'http://community.opscode.com/search?query=%s\&scope=cookbook',
        \     'keyword_encoding': 'utf-8',
        \     'cache': '0',
        \   },
        \   'underscore.js': {
        \     'url': 'http://underscorejs.org/?q=%s',
        \     'keyword_encoding': 'utf-8',
        \     'cache': '1',
        \   },
        \   'lodash.js': {
        \     'url': 'http://lodash.com/docs?q=%s',
        \     'keyword_encoding': 'utf-8',
        \     'cache': '1',
        \   },
        \   'cpan': {
        \     'url': 'http://search.cpan.org/search?q=%s;s={startIndex}',
        \     'keyword_encoding': 'utf-8',
        \     'cache': '0',
        \   },
        \ }
  function! g:ref_source_webdict_sites.alc.filter(output)
    return join(split(a:output, "\n")[38:], "\n")
  endfunction
  function! g:ref_source_webdict_sites.weblio.filter(output)
    return join(split(a:output, "\n")[53 :], "\n")
  endfunction
  function! g:ref_source_webdict_sites.wikipedia.filter(output)
    return join(split(a:output, "\n")[17 :], "\n")
  endfunction
  function! g:ref_source_webdict_sites.wiktionary.filter(output)
    return join(split(a:output, "\n")[38:], "\n")
  endfunction
  function! g:ref_source_webdict_sites.rurema.filter(output)
    return substitute(a:output, '.*検索結果', '', '')
  endfunction
  function! g:ref_source_webdict_sites.node_toolbox.filter(output)
    return join(split(a:output, "\n")[34 :], "\n")
  endfunction
  function! g:ref_source_webdict_sites.chef_cookbooks.filter(output)
    return join(split(a:output, "\n")[18 :], "\n")
  endfunction

  " webdict default {{{4
  let g:ref_source_webdict_sites.default = 'alc'

  " webdict command {{{4
  function! s:ref_webdict_search(source, count, l1, l2, text)
    " let text = a:firstline == 0 ? a:text : join(getline(a:firstline, a:lastline), "\n")
    let text = a:count == 0 ? a:text : join(getline(a:l1, a:l2), "\n")
    execute "Ref" "webdict" a:source text
  endfunction
  command! -nargs=? -range=0 GTransEnJa call s:ref_webdict_search('en_ja', <count>, <line1>, <line2>, <q-args>)
  command! -nargs=? -range=0 GTransJaEn call s:ref_webdict_search('ja_en', <count>, <line1>, <line2>, <q-args>)

  " langs {{{4
  let g:ref_source_webdict_sites.default = 'alc'
  let g:ref_phpmanual_path=$VIM_CACHE.'/docs/phpman/'
  let g:ref_javadoc_path = $VIM_CACHE.'/docs/jdk-6-doc/ja'
  let g:ref_jquery_path = $VIM_CACHE.'/docs/jqapi-latest/docs'
  let g:ref_html_path=$VIM_CACHE.'/docs/htmldoc/www.aptana.com/reference/html/api'
  let g:ref_html5_path=$VIM_CACHE.'/docs/html5doc/dist'
  let g:ref_jscore_path=$VIM_CACHE.'/docs/jscore/www.aptana.com/reference/html/api'
  let g:ref_jsdom_path=$VIM_CACHE.'/docs/jscore/www.aptana.com/reference/html/api'
  "let g:ref_jquery_use_cache = 1
  let g:ref_nodejsdoc_dir=$VIM_CACHE.'/docs/nodejs/doc'

  " if isdirectory($HOME."/.nodebrew")
  "   let g:ref_nodejsdoc_dir = my#dir#find("~/.nodebrew/src/node-v*").last() . "/doc"
  " endif

  if executable('rurema')
    let g:ref_refe_cmd     = "rurema"
    let g:ref_refe_version = 2
  endif
  if s:is_win
    let g:ref_refe_encoding = 'cp932'
  else
    " let g:ref_refe_encoding = 'utf-8'
    " if exists('$RSENSE_HOME') && executable($RSENSE_HOME.'/bin/rsense')
    "   let g:ref_refe_rsense_cmd = $RSENSE_HOME.'/bin/rsense'
    " endif
  endif
  let g:ref_perldoc_complete_head = 1
  " }}}

  LCAlias Ref
  for src in ['refe', 'ri', 'perldoc', 'man'
        \ , 'pydoc', 'jsref', 'jquery'
        \ , 'cppref', 'cheat', 'nodejs', ]
    silent! exe 'Alias' src 'Ref' src
  endfor
  Alias webd[ict] Ref webdict
  Alias mr Ref webdict
  Alias alc Ref webdict alc
  Alias php[manual] Ref phpmanual
  Alias timo Ref timobileref
  Alias tide Ref tidesktopref

  nnoremap [!space]hh :Ref alc <C-r>=expand("<cWORD>")<CR><CR>

  if !exists('g:ref_jsextra_defines')
    let g:ref_jsextra_defines = {}
  endif
  call extend(g:ref_jsextra_defines, {
        \ 'EaselJS' : {
        \   'type' : 'yui',
        \   'command' : 'zip',
        \   'relative' : '',
        \   'url' : 'https://github.com/CreateJS/EaselJS/raw/master/docs/EaselJS_docs-0.5.0.zip',
        \ },
        \ 'TweenJS' : {
        \   'type' : 'yui',
        \   'command' : 'zip',
        \   'relative' : '',
        \   'url' : 'https://github.com/CreateJS/TweenJS/raw/master/docs/TweenJS_docs-0.3.0.zip',
        \ },
        \ 'PreloadJS' : {
        \   'type' : 'yui',
        \   'command' : 'zip',
        \   'relative' : '',
        \   'url' : 'https://github.com/CreateJS/PreloadJS/raw/master/docs/PreloadJS_docs-0.2.0.zip',
        \ },
        \ 'SoundJS' : {
        \   'type' : 'yui',
        \   'command' : 'zip',
        \   'relative' : '',
        \   'url' : 'https://github.com/CreateJS/SoundJS/raw/master/docs/SoundJS_docs-0.3.0.zip',
        \ },
        \ })
endif

" quickrun {{{2
if s:bundle.tap('vim-quickrun')
  nnoremap <expr><silent><C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"
  "silent! nmap <unique> <Space> <Plug>(quickrun)
  if !exists('g:quickrun_config')
    let g:quickrun_config={}
  endif
  let g:quickrun_config._ = {
        \   'outputter/buffer/split' : ':botright 8sp',
        \   'hook/inu/enable' : 1,
        \   'hook/inu/redraw' : 1,
        \   'hook/inu/wait' : 20,
        \ }
  if s:bundle.is_installed('vimproc.vim')
    call extend(g:quickrun_config._, {
        \   'runner' : 'vimproc',
        \   'runner/vimproc/updatetime' : 100,
        \ })
  endif

  call extend(g:quickrun_config, {
        \  'objc/gcc' : {
        \    'command' : 'gcc',
        \    'exec' : ['%c %o %s -o %s:p:r -framework Foundation', '%s:p:r %a', 'rm -f %s:p:r'],
        \    'tempfile': '{tempname()}.m'
        \  },
        \ })
  call extend(g:quickrun_config, {
        \  'go/8g' : {
        \    'command': '8g',
        \    'exec': ['8g %s', '8l -o %s:p:r %s:p:r.8', '%s:p:r %a', 'rm -f %s:p:r'],
        \  },
        \ })
  call extend(g:quickrun_config, {
        \  'csharp/csc' : {
        \    'command' : 'csc',
        \    'runmode' : 'simple',
        \    'exec' : ['%c /nologo %s:gs?/?\\? > /dev/null', '"%S:p:r:gs?/?\\?.exe" %a', ':call delete("%S:p:r.exe")'],
        \    'tempfile' : '{tempname()}.cs',
        \  },
        \  'csharp/cs' : {
        \    'command' : 'cs',
        \    'runmode' : 'simple',
        \    'exec' : ['%c %s > /dev/null', 'mono "%S:p:r:gs?/?\\?.exe" %a', ':call delete("%S:p:r.exe")'],
        \    'tempfile' : '{tempname()}.cs',
        \  },
        \ })
  call extend(g:quickrun_config, {
        \  'coffee/to_javascript' : {
        \     'command': 'coffee',
        \     'cmdopt': '-pb',
        \     'outputter/buffer/filetype': 'javascript',
        \  },
        \  'jsx/jsx' : {
        \    'command': 'jsx',
        \    'exec' : '%c %o --run %s',
        \  },
        \ })
  call extend(g:quickrun_config, {
        \ 'slim' : {
        \   'type' : 'slim/slimrb',
        \ },
        \ 'slim/slimrb' : {
        \   'command' : 'slimrb',
        \   'exec' : ['%c %o -p %s'],
        \ },
        \ })
  " http://qiita.com/joker1007/items/9dc7f2a92cfb245ad502
  call extend(g:quickrun_config, {
        \ 'ruby.rspec/rspec_bundle': {
        \   'command': 'rspec',
        \   'outputter/buffer/split': 'botright',
        \   'exec': 'bundle exec %c %o --color --tty %s'
        \ },
        \ 'ruby.rspec/rspec_normal': {
        \   'command': 'rspec',
        \   'outputter/buffer/split': 'botright',
        \   'exec': '%c %o --color --tty %s'
        \ },
        \ 'ruby.rspec/rspec_zeus': {
        \   'command': 'rspec',
        \   'outputter/buffer/split': 'botright',
        \   'exec': 'zeus test %o --color --tty %s'
        \ },
        \ 'ruby.rspec/rspec_spring': {
        \   'command': 'rspec',
        \   'outputter/buffer/split': 'botright',
        \   'exec': 'spring rspec %o --color --tty %s'
        \ },
        \ 'ruby/cucumber_bundle': {
        \   'command': 'cucumber',
        \   'outputter/buffer/split': 'botright',
        \   'exec': 'bundle exec %c %o --color %s'
        \ },
        \ 'ruby/cucumber_zeus': {
        \   'command': 'cucumber',
        \   'outputter/buffer/split': 'botright',
        \   'exec': 'zeus cucumber %o --color %s'
        \ },
        \ 'ruby/cucumber_spring': {
        \   'command': 'cucumber',
        \   'outputter/buffer/split': 'botright',
        \   'exec': 'spring cucumber %o --color %s'
        \ },
        \ })

  call extend(g:quickrun_config, {
        \  'ruby/rspec' : {
        \    'command' : 'rspec',
        \    'exec' : '%c %o -l {line(".")}',
        \  },
        \  'php/phpunit' : {
        \    'command' : 'phpunit',
        \  },
        \  'python/nosetests' : {
        \    'command' : 'nosetests',
        \    'cmdopt': '-s -vv',
        \  },
        \  'perl/prove' : {
        \    'command' : 'prove',
        \  },
        \ })
  call extend(g:quickrun_config, {
        \ 'mysql' : {
        \   'type' : 'sql/mysql',
        \ },
        \ 'sql' : {
        \   'type' : 'sql/postgresql',
        \ },
        \ 'sql/mysql' : {
        \   'runner' : 'system',
        \   'command' : 'mysql',
        \   'exec' : ['%c %o < %s'],
        \ },
        \ 'sql/postgresql': {
        \   'command' : 'psql',
        \   'exec': ['%c %o'],
        \ }
        \ })
  call extend(g:quickrun_config, {
        \  'markdown/markedwrapper' : {
        \    'command' : 'markedwrapper',
        \    'exec' : '%c %o %s',
        \  },
        \  'markdown/mdown' : {
        \    'command' : 'mdown',
        \    'exec' : '%c %o -i %s',
        \  },
        \  'markdown/Marked' : {
        \    'command' : 'open',
        \    'outputter' : 'null',
        \    'exec' : '%c -a Marked %o %s',
        \  },
        \  'markdown/multimarkdown' : {
        \    'command' : 'multimarkdown',
        \  },
        \  'markdown/rdiscount' : {
        \    'command' : 'rdiscount',
        \  },
        \  'markdown/markdown' : {
        \    'command' : 'markdown',
        \  },
        \ })
  call extend(g:quickrun_config, {
        \  'markdown/md2backlog' : {
        \    'command' : 'md2backlog',
        \  },
        \  'markdown/vim-helpfile' : {
        \    'command' : 'vim-helpfile',
        \  },
        \  'markdown/markdown2pod' : {
        \    'command' : 'markdown2pod',
        \  },
        \ })

  call extend(g:quickrun_config, {
        \  'processing/osascript' : {
        \    'command': 'osascript',
        \    'exec' : ['osascript %o ' . globpath(&runtimepath, 'bin/runPSketch.scpt'). ' %s:p:h:t']
        \  },
        \  'processing/processing-java' : {
        \    'command': 'processing-java',
        \    'exec' : '%c %o --sketch=$PWD/ --output=/Library/Processing --run --force',
        \  },
        \  'applescript/osascript' : {
        \    'command' : 'osascript',
        \    'output' : '_',
        \  },
        \  'diag/diag' : {
        \    'exec': [
        \       '%c -a %s -o %{expand("%:r")}.png',
        \       printf("%s %{expand(%:r)}.png %s",
        \         s:is_win ? 'explorer' : (s:is_mac ? 'open -g' : 'xdg-open'),
        \         s:is_win ? "" : "&"),
        \    ],
        \    'outputter': 'message',
        \ },
        \ })
  call extend(g:quickrun_config, {
        \  'command/cat' : {
        \    'command' : 'cat',
        \    'exec' : ['%c %o %s'],
        \  },
        \ })

  call extend(g:quickrun_config, {
        \   'objc' : {
        \     'type' : executable('gcc') ? 'objc/gcc':
        \              '',
        \   },
        \   'jsx' : {
        \     'type' : 'jsx/jsx',
        \   },
        \ })
  call extend(g:quickrun_config, {
        \   'cs' : {
        \     'type' : executable('csc') ? 'csharp/csc':
        \              executable('cs') ? 'csharp/cs':
        \              '',
        \   },
        \   'go' : {
        \     'type' : executable('8g') ? 'go/8g':
        \              '',
        \   },
        \ })
  call extend(g:quickrun_config, {
        \   'ruby.rspec' : {
        \     'type' : 'ruby/rspec',
        \   },
        \   'python.nosetests' : {
        \     'type' : 'python/nosetests',
        \   },
        \   'perl.prove' : {
        \     'type' : 'perl/prove',
        \   },
        \   'php.phpunit' : {
        \     'type' : 'php/phpunit',
        \   },
        \ })
  call extend(g:quickrun_config, {
        \   'markdown' : {
        \     'type' :
        \              s:is_mac && isdirectory('/Applications/Marked.app') ? 'markdown/Marked':
        \              executable('markedwrapper')    ? 'markdown/markedwrapper':
        \              executable('mdown')            ? 'markdown/mdown':
        \              executable('pandoc')           ? 'markdown/pandoc':
        \              executable('multimarkdown')    ? 'markdown/multimarkdown':
        \              executable('MultiMarkdown.pl') ? 'markdown/MultiMarkdown.pl':
        \              executable('rdiscount')        ? 'markdown/rdiscount':
        \              executable('bluecloth')        ? 'markdown/bluecloth':
        \              executable('markdown')         ? 'markdown/markdown':
        \              executable('Markdown.pl')      ? 'markdown/Markdown.pl':
        \              executable('redcarpet')        ? 'markdown/redcarpet':
        \              executable('kramdown')         ? 'markdown/kramdown':
        \              '',
        \     'outputter' : 'browser',
        \   },
        \ })
  call extend(g:quickrun_config, {
        \   'processing' : {
        \     'type' : executable('processing-java') ? 'processing/processing-java' :
        \              executable('osascript') ? 'processing/osascript':
        \              '',
        \   },
        \   'applescript' : {
        \     'type' : executable('osascript') ? 'applescript/osascript':
        \              '',
        \   },
        \   'diag' : {
        \     'type' : 'diag/diag',
        \   },
        \ })

  nnoremap <Leader><Leader>r :<C-u>QuickRun command/cat<CR>

  " for testcase {{{3
  MyAutoCmd BufWinEnter,BufNewFile *_spec.rb setl filetype=ruby.rspec
  MyAutoCmd BufWinEnter,BufNewFile *test.php,*Test.php setl filetype=php.phpunit
  function! s:gen_phpunit_skel()
    let old_cwd = getcwd()
    let cwd = expand('%:p:h')
    let name = expand('%:t:r')
    let m = matchlist(join(getline(1, 10), "\n"), "\s*namespace\s*\(\w+\)\s*;")
    let type = match(name, '\(_test|Test\)$') == -1 ? "--test" : "--class"
    let opts = []
    if !empty(m)
      call add(opts, '--')
      call add(opts, m[1])
    endif
    silent exe 'lcd' cwd
    exe "!" printf("phpunit-skelgen %s %s %s", join(opts, " "), type, name)
    silent exe 'lcd' old_cwd
  endfunction
  command! PhpUnitSkelGen call <SID>gen_phpunit_skel()
  MyAutoCmd BufWinEnter,BufNewFile test_*.py setl filetype=python.nosetests
  MyAutoCmd BufWinEnter,BufNewFile *.t setl filetype=perl.prove

  if s:bundle.is_installed('vim-ref')
    augroup vimrc-plugin-ref
      autocmd!
      autocmd FileType ruby.rspec,php.phpunit,python.nosetests,perl.prove call s:testcase_lazy_init()
    augroup END

    function! s:testcase_lazy_init()
      call ref#register_detection('ruby.rspec', 'refe', 'append')
      call ref#register_detection('php.phpunit', 'phpmanual', 'append')
      call ref#register_detection('python.nosetests', 'pydoc', 'append')
      call ref#register_detection('perl.prove', 'perldoc', 'append')
      augroup vimrc-plugin-ref
        autocmd!
      augroup END
    endfunction
  endif


  function! s:vimrc_quickrun_init() "{{{4
    nmap <buffer> q :quit<CR>
  endfunction "}}}
  MyAutoCmd FileType quickrun call s:vimrc_quickrun_init()

  call s:bundle.untap()
endif

" watchdogs {{{2
if s:bundle.tap('vim-watchdogs') && s:bundle.is_installed('vimproc.vim')

  NeoBundleSource shabadou.vim vim-watchdogs

  " run ok
  "  python, jsonlint, coffee
  " \   'hook/back_window/enable_exit' : 1,
  " \   'hook/unite_quickfix/no_focus' : 1,
  " watchdogs g:quickrun_config {{{3
  call extend(g:quickrun_config, {
        \ 'watchdogs_checker/_' : {
        \   'hook/close_quickfix/enable_failure' : 1,
        \   'hook/close_quickfix/enable_success' : 1,
        \   'hook/hier_update/enable' : 1,
        \   'hook/quickfix_status_enable/enable' : 1,
        \   'hook/back_window/enable' : 1,
        \   'outputter/quickfix/open_cmd' : '',
        \ },
        \ })
  call extend(g:quickrun_config, {
        \ 'perl/watchdogs_checker' : {
        \   'type' : 'watchdogs_checker/perl-projectlibs',
        \ },
        \ 'cpanfile/watchdogs_checker': {
        \   'type' : 'watchdogs_checker/cpanfile',
        \ },
        \ "watchdogs_checker/perl-locallib" : {
        \   "command" : "perl",
        \   "exec"    : "%c %o -Mlib=local/lib/perl5/ -Mlib=lib -Mlib=. -cw %s:p",
        \   "quickfix/errorformat" : '%m\ at\ %f\ line\ %l%.%#',
        \ },
        \ 'watchdogs_checker/perl-projectlibs': {
        \   'command' : 'perl',
        \   'exec' : '%c %o -cw -MProject::Libs %s:p',
        \   'quickfix/errorformat' : '%m\ at\ %f\ line\ %l%.%#',
        \ },
        \ 'watchdogs_checker/cpanfile': {
        \   'command' : 'perl',
        \   'exec' : '%c %o -w -MModule::CPANfile -e "Module::CPANfile->load(q|%S:p|)"',
        \   'quickfix/errorformat' : '%m\ at\ %f\ line\ %l%.%#',
        \ },
        \ })
  call extend(g:quickrun_config, {
        \ 'html/watchdogs_checker' : {
        \   'type' : 'watchdogs_checker/tidy',
        \ },
        \ 'xhtml/watchdogs_checker' : {
        \   'type' : 'watchdogs_checker/tidy',
        \ },
        \ 'watchdogs_checker/tidy' : {
        \   'command' : 'tidy',
        \    'exec'    : '%c -raw -quiet -errors --gnu-emacs yes %o %s:p',
        \    'quickfix/errorformat' : '%f:%l:%c: %m',
        \ },
        \ 'haml/watchdogs_checker' : {
        \   'type' : 'watchdogs_checker/haml',
        \ },
        \ 'watchdogs_checker/haml' : {
        \   'command' : 'haml',
        \    'exec'    : '%c -c %o %s:p',
        \    'quickfix/errorformat' : 'Haml error on line %l: %m,'
        \                           . 'Syntax error on line %l: %m,%-G%.%#',
        \ },
        \ 'watchdogs_checker/slimrb' : {
        \   'command' : 'slimrb',
        \    'exec'    : '%c -c %o %s:p',
        \    'quickfix/errorformat' : '%C\ %#%f\, Line %l\, Column %c,'.
        \                             '%-G\ %.%#,'.
        \                             '%ESlim::Parser::SyntaxError: %m,'.
        \                             '%+C%.%#'
        \ },
        \ })
  call extend(g:quickrun_config, {
        \ 'json/watchdogs_checker' : {
        \   'type' : 'watchdogs_checker/jsonlint',
        \ },
        \ 'watchdogs_checker/jsonlint' : {
        \   'command' : 'jsonlint',
        \    'exec'    : '%c %s:p %o --compact',
        \    'quickfix/errorformat' : '%ELine %l:%c,%Z\\s%#Reason: %m,'
        \                           . '%C%.%#,%f: line %l\, col %c\, %m,%-G%.%#',
        \ },
        \ 'watchdogs_checker/nodejs' : {
        \   'command' : 'node',
        \    'exec'    : '%c %o %s:p',
        \    'quickfix/errorformat' : '%AError: %m,%AEvalError: %m,'
        \                           . '%ARangeError: %m,%AReferenceError: %m,'
        \                           . '%ASyntaxError: %m,%ATypeError: %m,'
        \                           .  '%Z%*[\ ]at\ %f:%l:%c,%Z%*[\ ]%m (%f:%l:%c),'
        \                           .  '%*[\ ]%m (%f:%l:%c),%*[\ ]at\ %f:%l:%c,%Z%p^,'
        \                           .  '%A%f:%l,%C%m,%-G%.%#'
        \ },
        \ 'watchdogs_checker/jsonval' : {
        \   'command' : 'jsonval',
        \    'exec'    : '%c %o %s:p',
        \    'quickfix/errorformat' : '%E%f: %m at line %l,%-G%.%#',
        \ },
        \ 'coffee/watchdogs_checker' : {
        \   'type' : 'watchdogs_checker/coffee',
        \ },
        \ 'watchdogs_checker/coffee' : {
        \   'command' : 'coffee',
        \   'exec'    : '%c -c -p %o %s:p',
        \   'quickfix/errorformat' : '%E%f:%l:%c: %trror: %m,' .
        \                            'Syntax%trror: In %f\, %m on line %l,' .
        \                            '%EError: In %f\, Parse error on line %l: %m,' .
        \                            '%EError: In %f\, %m on line %l,' .
        \                            '%W%f(%l): lint warning: %m,' .
        \                            '%W%f(%l): warning: %m,' .
        \                            '%E%f(%l): SyntaxError: %m,' .
        \                            '%-Z%p^,' .
        \                            '%-G%.%#'
        \ },
        \ 'watchdogs_checker/coffeelint' : {
        \   'command' : 'coffeelint',
        \   'exec'    : '%c -csv %o %s:p',
        \   'quickfix/errorformat' : '%f\,%l\,%\d%#\,%trror\,%m,' .
        \                            '%f\,%l\,%trror\,%m,' .
        \                            '%f\,%l\,%\d%#\,%tarn\,%m,' .
        \                            '%f\,%l\,%tarn\,%m'
        \ },
        \ 'typescript/watchdogs_checker' : {
        \   'type' : 'watchdogs_checker/tsc',
        \ },
        \ 'watchdogs_checker/tsc' : {
        \   'command' : 'tsc',
        \    'exec'    : '%c %o %s:p',
        \    'quickfix/errorformat' : '%+A %#%f %#(%l\,%c): %m,%C%m',
        \ },
        \ })
  call extend(g:quickrun_config, {
        \ 'css/watchdogs_checker' : {
        \   'type' : 'watchdogs_checker/csslint',
        \ },
        \ 'watchdogs_checker/csslint' : {
        \   'command' : 'csslint',
        \    'exec'    : '%c %o --format=compact %s:p',
        \    'quickfix/errorformat' : '%-G,%-G%f: lint free!,%f: line %l\, col %c\, %trror - %m,%f: line %l\, col %c\, %tarning - %m,%f: line %l\, col %c\, %m,',
        \ },
        \ })
  if !executable('pyflakes')
    call extend(g:quickrun_config, {
        \  'python/watchdogs_checker' : {
        \    'type' : 'watchdogs_checker/python',
        \  },
        \ })
  endif
  call extend(g:quickrun_config, {
        \ 'watchdogs_checker/python' : {
        \   'command' : 'python',
        \    'exec'    : "%c %o -c \"compile(open('%s:p').read(), '%s:p', 'exec')\"",
        \    'quickfix/errorformat' :
        \       '%A  File "%f"\, line %l\,%m,' .
        \       '%C    %.%#,' .
        \       '%+Z%.%#Error: %.%#,' .
        \       '%A  File "%f"\, line %l,' .
        \       '%+C  %.%#,' .
        \       '%-C%p^,' .
        \       '%Z%m,' .
        \       '%-G%.%#'
        \ },
        \ })
  call extend(g:quickrun_config, {
        \ 'csharp/watchdogs_checker' : {
        \   'type' : 'watchdogs_checker/mcs',
        \ },
        \ 'watchdogs_checker/mcs' : {
        \   'command' : 'mcs',
        \    'exec'    : '%c %o %s:p',
        \    'cmdopt'  : '--parse',
        \    'quickfix/errorformat' : '%f(%l\\\,%c):\ error\ CS%n:\ %m',
        \ },
        \ })
  call extend(g:quickrun_config, {
        \ 'objc/watchdogs_checker' : {
        \   'type' : 'watchdogs_checker/gcc_objc',
        \ },
        \ 'watchdogs_checker/gcc_objc' : {
        \   'command' : 'gcc',
        \    'exec'    : '%c -fsyntax-only -lobjc %o %s:p',
        \    'quickfix/errorformat' : '%-G%f:%s:,'
        \                           . '%f:%l:%c: %trror: %m,'
        \                           . '%f:%l:%c: %tarning: %m,'
        \                           . '%f:%l:%c: %m,'
        \                           . '%f:%l: %trror: %m,'
        \                           . '%f:%l: %tarning: %m,'
        \                           . '%f:%l: %m',
        \ },
        \ })
  call extend(g:quickrun_config, {
        \ 'eruby/watchdogs_checker' : {
        \   'type' : 'watchdogs_checker/ruby_erb',
        \ },
        \ 'Gemfile/watchdogs_checker' : {
        \   'type' : 'watchdogs_checker/ruby',
        \ },
        \ 'watchdogs_checker/erubis' : {
        \   'command' : 'erubis',
        \    'exec'    : '%c -z %o %s:p',
        \    'quickfix/errorformat' : '%f:%l:%m',
        \ },
        \ 'watchdogs_checker/ruby_erb' : {
        \   'command' : 'ruby',
        \    'exec'    : '%c -rerb -e "puts ERB.new('
        \           . 'File.read(''%s:p'').gsub(''<\%='', ''<\%'')'
        \           . ', nil, ''-'').src" | %c -c %o',
        \    'quickfix/errorformat' : '%-GSyntax OK,%E-:%l: syntax error, %m,%Z%p^,%W-:%l: warning: %m,%Z%p^,%-C%.%#',
        \ },
        \ 'cucumber/watchdogs_checker' : {
        \   'type' : 'watchdogs_checker/cucumber',
        \ },
        \ 'watchdogs_checker/cucumber' : {
        \   'command': 'cucumber',
        \    'exec'  : '%c --dry-run --quiet --strict --format pretty %o %s:p',
        \    'quickfix/errorformat' : '%f:%l:%c:%m,%W      %.%# (%m),%-Z%f:%l:%.%#,%-G%.%#',
        \ },
        \ 'watchdogs_checker/foodcritic': {
        \   'command': 'foodcritic',
        \   'exec'   : '%c %o %s:p',
        \   'quickfix/errorformat': 'FC%n: %m: %f:%l',
        \ },
        \ })
  call extend(g:quickrun_config, {
        \ 'applescript/watchdogs_checker' : {
        \   'type' : 'watchdogs_checker/osacompile',
        \ },
        \ 'watchdogs_checker/osacompile' : {
        \   'command' : 'osacompile',
        \    'exec'    : '%c -o %o %s:p',
        \    'quickfix/errorformat' : '%f:%l:%m',
        \ },
        \ })
  call extend(g:quickrun_config, {
        \ 'lua/watchdogs_checker' : {
        \   'type' : 'watchdogs_checker/luac',
        \ },
        \ 'watchdogs_checker/luac' : {
        \   'command' : 'luac',
        \    'exec'    : '%c -p %o %s:p',
        \    'quickfix/errorformat' : 'luac: %#%f:%l: %m',
        \ },
        \ 'qml/watchdogs_checker' : {
        \   'type' : 'watchdogs_checker/qmlscene',
        \ },
        \ 'watchdogs_checker/qmlscene' : {
        \   'command' : 'qmlscene',
        \    'exec'    : '%c -c %o %s:p',
        \    'cmdopt' : '--quit',
        \    'quickfix/errorformat' : 'file:\/\/%f:%l %m',
        \ },
        \ })
  call extend(g:quickrun_config, {
        \ 'watchdogs_checker/sqlplus' : {
        \   'command' : 'sqlplus',
        \   'cmdopt'  : '-S %{OracleConnection()}',
        \   'exec'    : '%c %o \@%s:p',
        \   'quickfix/errorformat' : '%Eerror\ at\ line\ %l:,%Z%m',
        \ },
        \ })
  call extend(g:quickrun_config, {
        \ 'watchdogs_checker/twig-lint' : {
        \   'command' : 'twig-lint',
        \   'exec'    : '%c lint --format=csv %o %s:p',
        \   'quickfix/errorformat' : '"%f"\,%l\,%m',
        \ },
        \ })
  " call extend(g:quickrun_config, {
  "       \ '/watchdogs_checker' : {
  "       \   'type' : 'watchdogs_checker/',
  "       \ },
  "       \ 'watchdogs_checker/' : {
  "       \   'command' : '',
  "       \   'exec'    : '%c -c %o %s:p',
  "       \   'quickfix/errorformat' : '',
  "       \ },
  "       \ })

  " watchdogs setup {{{3
  call watchdogs#setup(g:quickrun_config)

  let g:watchdogs_check_BufWritePost_enable = 1

  " watchdogs helper command {{{3
  command! -nargs=0 WatchdogsOff let g:watchdogs_check_BufWritePost_enable=0
  command! -nargs=0 WatchdogsOn let g:watchdogs_check_BufWritePost_enable=1
  command! -nargs=? WatchdogsConfig call <SID>wd_helper.show_config(<f-args>)

  let s:wd_helper = {}
  function! s:wd_helper.find_by_names(...) "{{{4
    let ftype = a:0 > 0 ? a:1 : &filetype
    let names = []
    let default_name = ftype . "/watchdogs_checker"
    let default_type = ""
    if exists('g:quickrun_config[default_name]')
      call add(names, default_name)
      if exists('g:quickrun_config[default_name].type')
        call add(names, g:quickrun_config[default_name].type)
        let default_type = g:quickrun_config[default_name].type
      endif
    endif
    for name in keys(g:quickrun_config)
      if name == default_name || name == default_type
        continue
      endif
      if name =~? 'watchdogs_checker' && name =~? ftype
        call add(names, name)
      endif
    endfor
    return names
  endfunction

  function! s:wd_helper.show_config(...) "{{{4
    let names = call('self.find_by_names', a:000)
    let items = []
    if !empty(names)
      if exists(':PP')
        for name in names
          echo printf("let g:quickrun_config['%s']=", name)
          exe 'PP' 'g:quickrun_config["' . name . '"]'
        endfor
      else
        for name in names
          call add(items, printf("let g:quickrun_config['%s'] = %s", name, string(g:quickrun_config[name])))
        endfor
        echo join(items, "\n")
      endif
    endif
  endfunction
endif

" quickhl {{{2
if s:bundle.is_installed('vim-quickhl')
  nmap [!space]m <Plug>(quickhl-toggle)
  xmap [!space]m <Plug>(quickhl-toggle)
  nmap [!space]M <Plug>(quickhl-reset)
  xmap [!space]M <Plug>(quickhl-reset)
  nmap [!space], <Plug>(quickhl-match)
endif

" echodoc {{{2
let g:echodoc_enable_at_startup=0

" clang_complete {{{2
" let g:clang_exec = 'path/to/clang'
" let g:clang_use_library = 1
" let g:clang_library_path = 'path/to/libclang.dll'
let g:neocomplcache_force_overwrite_completefunc = 1
let g:neocomplete#force_overwrite_completefunc = 1
" clang_complete の自動呼び出し OFF
let g:clang_complete_auto = 0
let g:cland_auto_select = 0

" neosnippet {{{2
if s:bundle.is_installed('neosnippet.vim')
  let g:neosnippet#snippets_directory            = $HOME . '/.vim/snippets'
  let g:neosnippet#enable_snipmate_compatibility = 0
  " let g:neosnippet#disable_runtime_snippets._    = 1

  function! s:can_snip()
    return neosnippet#expandable_or_jumpable() && &filetype != "snippet"
  endfunction
  let s:pair_closes = [ "]", "}", ")", "'", '"', ">", "|" , ","]
  function! s:imap_tab()
    if neosnippet#expandable()
      return "\<Plug>(neosnippet_expand)"
    elseif neosnippet#jumpable()
      return "\<Plug>(neosnippet_jump)"
    " if s:can_snip()
    "   return "\<Plug>(neosnippet_jump_or_expand)"
    elseif pumvisible()
      return "\<C-n>"
    endif

    let line = getline(".")
    let pos = col(".") - 1
    let org_pos = pos
    if strlen(substitute(line[0:pos], '^\s*', '', '')) <= 0
      return "\<TAB>"
    endif
    while (line[pos] == " ")
      let pos = pos + 1
    endwhile
    let ch = line[pos]
    if index(s:pair_closes, ch) != -1
      while (line[pos+1] == " ")
        let pos = pos+1
      endwhile
      return repeat("\<Right>", pos - org_pos + 1)
    endif
    if s:bundle.is_sourced('emmet-vim')
          \ && line[pos] =~# '[a-zA-Z]'
          \ && line[pos+1] =~# '[^<>"'']'
          \ && &filetype =~# 'x\?html\|s\?css\|php\|eruby'
      return "\<Plug>(EmmetExpandAbbr)"
    endif
    return "\<TAB>"
  endfunction

  imap <expr><TAB> <SID>imap_tab()
  smap <expr><TAB> <SID>can_snip() ?
        \ "\<Plug>(neosnippet_jump_or_expand)" : "\<TAB>"

  imap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
  smap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"

  imap <C-l> <Plug>(neosnippet_jump_or_expand)
  smap <C-l> <Plug>(neosnippet_jump_or_expand)
endif

" neocomplete, neocomplcache {{{2
if s:bundle.is_installed('neocomplcache.vim') "{{{3
  " options {{{4
  let g:neocomplcache_temporary_dir = $VIM_CACHE . '/neocomplcache'
  let g:neocomplcache_enable_at_startup                   = 1
  let g:neocomplcache_cursor_hold_i_time                  = 500
  let g:neocomplcache_max_list = 100  " 補完候補の数
  let g:neocomplcache_enable_auto_select = 1   " 一番目の候補を自動選択

  let g:neocomplcache_enable_smart_case                   = 1
  let g:neocomplcache_enable_camel_case_completion        = 0 " camel case off
  let g:neocomplcache_enable_underbar_completion          = 1
  " let g:neocomplcache_enable_auto_delimiter               = 1
  let g:neocomplcache_disable_caching_file_path_pattern   =
        \ "\.log$\|_history$\|\.howm$\|\.jax$\|\.snippets$"
  let g:neocomplcache_lock_buffer_name_pattern            =
        \ '\*ku\*\|\.log$\|\.jax$\|\.log\.'

  let g:neocomplcache_min_syntax_length                   = 3
  " let g:neocomplcache_plugin_completion_length     = {
  " let g:neocomplcache_auto_completion_start_length        = 2
  " let g:neocomplcache_manual_completion_start_length      = 1
  " let g:neocomplcache_min_keyword_length                  = 3
  " let g:neocomplcache_ignore_case                         = 0
  " \ 'snipMate_complete' : 1,
  " \ 'buffer_complete'   : 1,
  " \ 'include_complete'  : 2,
  " \ 'syntax_complete'   : 2,
  " \ 'filename_complete' : 2,
  " \ 'keyword_complete'  : 2,
  " \ 'omni_complete'     : 1,
  " \ }

  call s:initialize_global_dict('neocomplcache_', [
        \ 'keyword_patterns',
        \ 'dictionary_filetype_lists',
        \ 'source_disable',
        \ 'include_patterns', 'vim_completefuncs',
        \ 'omni_patterns',
        \ 'force_omni_patterns',
        \ 'delimiter_patterns',
        \ 'same_filetype_lists', 'member_prefix_patterns',
        \ 'next_keyword_patterns',
        \ 'include_exprs',
        \ 'omni_functions',
        \ 'include_paths',
        \ ])

  let g:neocomplcache_keyword_patterns.default = '\h\w*' " 日本語をキャッシュしない

  call extend(g:neocomplcache_source_disable, {
        \ 'syntax_complete' : 1,
        \ })

  function! s:neocomplcache_dictionary_config() "{{{4
    for fp in split(globpath("~/.vim/dict", "*.dict"), "\n")
      let _name = fnamemodify(fp, ":p:t:r")
      let g:neocomplcache_dictionary_filetype_lists[_name] = fp
    endfor

    call extend(g:neocomplcache_dictionary_filetype_lists, {
          \ 'default'     : '',
          \ 'vimshell'    : $VIM_CACHE . '/vimshell/command-history',
          \ })
    " \ 'javascript'  : $HOME . '/.vim/dict/javascript.dict',

    for [key, val] in items({
          \ 'vimshell'    : $VIM_CACHE . '/vimshell/command-history',
          \ 'javascript'  : $HOME . '/.vim/dict/node.dict',
          \ 'eruby'       : $HOME . '/.vim/dict/ruby.dict',
          \ })
      if exists('g:neocomplcache_dictionary_filetype_lists[key]')
        let g:neocomplcache_dictionary_filetype_lists[key] .= ",".val
      else
        let g:neocomplcache_dictionary_filetype_lists[key] = val
      endif

    endfor
  endfunction "}}}
  call s:neocomplcache_dictionary_config()

  let g:use_zen_complete_tag=1

  call extend(g:neocomplcache_vim_completefuncs, {
        \ 'Ref'   : 'ref#complete',
        \ 'Unite' : 'unite#complete_source',
        \ 'VimShellExecute' :
        \   'vimshell#vimshell_execute_complete',
        \ 'VimShellInteractive' :
        \   'vimshell#vimshell_execute_complete',
        \ 'VimShellTerminal' :
        \   'vimshell#vimshell_execute_complete',
        \ 'VimShell' : 'vimshell#complete',
        \ 'VimFiler' : 'vimfiler#complete',
        \ 'Vinarise' : 'vinarise#complete',
        \ })

  let g:neocomplcache_force_omni_patterns.c =
        \ '[^.[:digit:] *\t]\%(\.\|->\)'
  let g:neocomplcache_force_omni_patterns.cpp =
        \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
  let g:neocomplcache_force_omni_patterns.cs = '[^.]\.\%(\u\{2,}\)\?'
  " let g:neocomplcache_force_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|::'
  let g:neocomplcache_force_omni_patterns.objc = '[^.[:digit:] *\t]\%(\.\|->\)'
  let g:neocomplcache_force_omni_patterns.objcpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

  let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

  let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'

  let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
  let g:neocomplcache_delimiter_patterns.php = ['->', '::', '\']
  let g:neocomplcache_member_prefix_patterns.php = '->\|::'
  call s:bulk_dict_variables([{
        \   'dict' : g:neocomplcache_omni_patterns,
        \   'names' : ['twig', 'smarty'],
        \   'value' : '<[^>]*'
        \ }, {
        \   'dict' : g:neocomplcache_next_keyword_patterns,
        \   'names' : ['twig', 'smarty'],
        \   'value' : '[[:alnum:]_:-]*>\|[^"]*"'
        \ }])


  let g:neocomplcache_include_patterns.scala = '^import'
  " javascript
  if s:bundle.is_installed('tern_for_vim')
    let g:neocomplcache_omni_functions.javascript = 'tern#Complete'
  elseif s:bundle.is_installed('vim-nodejs-complete')
    let g:neocomplcache_omni_functions.javascript = 'nodejscomplete#CompleteJS'
  endif

  " haxe
  let g:neocomplcache_omni_patterns.haxe = '\v([\]''"]|\w)(\.|\()\w*'
  " autohotkey
  let g:neocomplcache_include_paths.autohotkey = '.,,'
  let g:neocomplcache_include_patterns.autohotkey = '^\s*#\s*include'
  let g:neocomplcache_include_exprs.autohotkey = ''
  " }}}

  if s:bundle.is_installed('neocomplcache.vim')
    " Recommended key-mappings.
    " <CR>: close popup and save indent.
    " inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
    inoremap <silent> <CR> <C-R>=neocomplcache#smart_close_popup()<CR><CR>

    " <TAB>: completion.
    " inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

    " <C-h>, <BS>: close popup and delete backword char.
    if s:bundle.is_installed('vim-smartinput')
      " inoremap <expr> <C-h>  neocomplcache#smart_close_popup()
      "       \ . eval(smartinput#sid().'_trigger_or_fallback("\<BS>", "\<C-h>")')
      " inoremap <expr> <BS>   neocomplcache#smart_close_popup()
      "       \ .eval(smartinput#sid().'_trigger_or_fallback("\<BS>", "\<BS>")')
      imap <expr> <C-h>  neocomplcache#smart_close_popup()
            \ . "\<Plug>(smartinput_BS)"
      imap <expr> <BS>   neocomplcache#smart_close_popup()
            \ . "\<Plug>(smartinput_C-h)"
    else
      inoremap <expr><C-h>  neocomplcache#smart_close_popup()."\<C-h>"
      inoremap <expr><BS>   neocomplcache#smart_close_popup()."\<C-h>"
    endif

    " inoremap <expr> <C-y>  neocomplcache#close_popup()
    inoremap <expr> <C-e>  pumvisible() ? neocomplcache#cancel_popup() : "\<End>"

    inoremap <expr> <C-j> pumvisible() ? neocomplcache#close_popup() : "\<CR>"

    imap <C-s> <Plug>(neocomplcache_start_unite_complete)

    nnoremap [!space]ne :NeoComplCacheEnable<CR>
    nnoremap [!space]nd :NeoComplCacheDisable<CR>
  endif
  " endwise
  " inoremap <silent> <cr> <c-r>=EnterIndent()<cr>
  " if s:bundle.is_installed('vim-indent_cr')
    " Lazy inoremap <silent><expr> <CR> (pumvisible()?neocomplcache#smart_close_popup():"")
    "       \ ."\<C-r>=indent_cr#enter()\<CR>\<C-r>=endwize#crend()\<CR>"
    imap <silent><expr> <CR> (pumvisible()?neocomplcache#smart_close_popup():"")
          \ ."\<Plug>(smartinput_CR)\<C-r>=endwize#crend()\<CR>"
  " else
    " Lazy inoremap <silent><expr> <CR> (pumvisible()?neocomplcache#smart_close_popup():"")
    "       \ ."\<CR>\<C-r>=endwize#crend()\<CR>"
  " endif


elseif s:bundle.is_installed('neocomplete.vim') "{{{3
  " options {{{4
  let g:neocomplete#data_directory = $VIM_CACHE . '/neocomplete'
  let g:neocomplete#enable_at_startup                   = 1
  let g:neocomplete#cursor_hold_i_time                  = 500
  let g:neocomplete#max_list = 100  " 補完候補の数
  let g:neocomplete#enable_auto_select = 1   " 一番目の候補を自動選択

  let g:neocomplete#enable_smart_case                   = 1
  let g:neocomplete#enable_camel_case_completion        = 0 " camel case off
  let g:neocomplete#enable_underbar_completion          = 1
  " let g:neocomplete#enable_auto_delimiter               = 1
  let g:neocomplete#disable_caching_file_path_pattern   =
        \ "\.log$\|_history$\|\.howm$\|\.jax$\|\.snippets$"
  let g:neocomplete#lock_buffer_name_pattern            =
        \ '\*ku\*\|\.log$\|\.jax$\|\.log\.'

  let g:neocomplete#min_syntax_length                   = 3
  " let g:neocomplete#plugin_completion_length     = {
  " let g:neocomplete#auto_completion_start_length        = 2
  " let g:neocomplete#manual_completion_start_length      = 1
  " let g:neocomplete#min_keyword_length                  = 3
  " let g:neocomplete#ignore_case                         = 0
  " \ 'snipMate_complete' : 1,
  " \ 'buffer_complete'   : 1,
  " \ 'include_complete'  : 2,
  " \ 'syntax_complete'   : 2,
  " \ 'filename_complete' : 2,
  " \ 'keyword_complete'  : 2,
  " \ 'omni_complete'     : 1,
  " \ }

  call s:initialize_global_dict('neocomplete#', [
        \ 'keyword_patterns',
        \ 'sources#dictionary#dictionaries',
        \ 'source_disable',
        \ 'sources#include#patterns', 'sources#vim#complete_functions',
        \ 'sources#omni#input_patterns',
        \ 'force_omni_input_patterns',
        \ 'delimiter_patterns',
        \ 'same_filetypes', 'sources#member#prefix_patterns',
        \ 'next_keyword_patterns',
        \ 'sources#include#exprs',
        \ 'sources#omni#functions',
        \ 'sources#include#paths',
        \ ])

  let g:neocomplete#keyword_patterns.default = '\h\w*' " 日本語をキャッシュしない

  call extend(g:neocomplete#source_disable, {
        \ 'syntax_complete' : 1,
        \ })

  function! s:neocomplete_dictionary_config() "{{{4
    for fp in split(globpath("~/.vim/dict", "*.dict"), "\n")
      let _name = fnamemodify(fp, ":p:t:r")
      let g:neocomplete#sources#dictionary#dictionaries[_name] = fp
    endfor

    call extend(g:neocomplete#sources#dictionary#dictionaries, {
          \ 'default'     : '',
          \ 'vimshell'    : $VIM_CACHE . '/vimshell/command-history',
          \ })
    for [key, val] in items({
          \ 'vimshell'    : $VIM_CACHE . '/vimshell/command-history',
          \ 'javascript'  : $HOME . '/.vim/dict/node.dict',
          \ 'eruby'       : $HOME . '/.vim/dict/ruby.dict',
          \ })
      if exists('g:neocomplete#sources#dictionary#dictionaries[key]')
        let g:neocomplete#sources#dictionary#dictionaries[key] .= ",".val
      else
        let g:neocomplete#sources#dictionary#dictionaries[key] = val
      endif

    endfor
    " \ 'javascript'  : $HOME . '/.vim/dict/javascript.dict',
  endfunction "}}}
  call s:neocomplete_dictionary_config()

  let g:use_zen_complete_tag=1

  call extend(g:neocomplete#sources#vim#complete_functions, {
        \ 'Ref'   : 'ref#complete',
        \ 'Unite' : 'unite#complete_source',
        \ 'VimShellExecute' :
        \   'vimshell#vimshell_execute_complete',
        \ 'VimShellInteractive' :
        \   'vimshell#vimshell_execute_complete',
        \ 'VimShellTerminal' :
        \   'vimshell#vimshell_execute_complete',
        \ 'VimShell' : 'vimshell#complete',
        \ 'VimFiler' : 'vimfiler#complete',
        \ 'Vinarise' : 'vinarise#complete',
        \ })

  " clang
  let g:neocomplete#force_omni_input_patterns.c =
        \ '[^.[:digit:] *\t]\%(\.\|->\)'
  let g:neocomplete#force_omni_input_patterns.cpp =
        \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
  let g:neocomplete#force_omni_input_patterns.cs = '[^.]\.\%(\u\{2,}\)\?'
  " let g:neocomplete#force_omni_input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|::'
  let g:neocomplete#force_omni_input_patterns.objc = '[^.[:digit:] *\t]\%(\.\|->\)'
  let g:neocomplete#force_omni_input_patterns.objcpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

  " perl
  let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

  " ruby
  let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'

  " python
  let g:neocomplete#force_omni_input_patterns.python = '[^. \t]\.\w*'

  " scala
  let g:neocomplete#sources#include#patterns.scala = '^import'

  " javascript
  if s:bundle.is_installed('tern_for_vim')
    let g:neocomplete#sources#omni#functions.javascript = 'tern#Complete'
    let g:neocomplete#sources#omni#functions.coffee = 'tern#Complete'
    " MyAutoCmd FileType coffee call tern#Enable()
  elseif s:bundle.is_installed('vim-nodejs-complete')
    let g:neocomplete#sources#omni#functions.javascript = 'nodejscomplete#CompleteJS'
  endif
  " let g:neocomplete#sources#omni#functions.javascript = 'jscomplete#CompleteJS'
  let g:neocomplete#sources#omni#input_patterns.javascript =
        \ '\h\w*\|[^. \t]\.\w*'
  let g:neocomplete#sources#omni#input_patterns.coffee =
        \ '\h\w*\|[^. \t]\.\w*'

  " haxe
  let g:neocomplete#sources#omni#input_patterns.haxe = '\v([\]''"]|\w)(\.|\()\w*'

  " php
  let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
  let g:neocomplete#delimiter_patterns.php = ['->', '::', '\']
  let g:neocomplete#sources#member#prefix_patterns.php = '->\|::'
  call s:bulk_dict_variables([{
        \   'dict' : g:neocomplete#sources#omni#input_patterns,
        \   'names' : ['twig', 'smarty'],
        \   'value' : '<[^>]*'
        \ }, {
        \   'dict' : g:neocomplete#next_keyword_patterns,
        \   'names' : ['twig', 'smarty'],
        \   'value' : '[[:alnum:]_:-]*>\|[^"]*"'
        \ }])

  " Go
  if s:bundle.is_installed('vim-gocode')
    let g:neocomplete#sources#omni#functions.go = 'gocomplete#Complete'
  endif

  " Clojure
  if s:bundle.is_installed('vim-clojure')
    let g:neocomplete#sources#omni#functions.clojure = 'vimclojure#OmniCompletion'
  endif

  " SQL
  let g:neocomplete#sources#omni#functions.sql = 'sqlcomplete#Complete'

  " R
  if s:bundle.is_installed('Vim-R-plugin')
    let g:neocomplete#sources#omni#input_patterns.r = '[[:alnum:].\\]\+'
    let g:neocomplete#sources#omni#functions.r = 'rcomplete#CompleteR'
  endif

  " XQuery
  if s:bundle.is_installed('XQuery-indentomnicomplete')
    let g:neocomplete#sources#omni#input_patterns.xquery =
          \ '\k\|:\|\-\|&'
    let g:neocomplete#sources#omni#functions.xquery =
          \ 'xquerycomplete#CompleteXQuery'
  endif

  " autohotkey
  let g:neocomplete#sources#include#paths.autohotkey = '.,,'
  let g:neocomplete#sources#include#patterns.autohotkey = '^\s*#\s*include'
  let g:neocomplete#sources#include#exprs.autohotkey = ''

  " }}}


  " Recommended key-mappings.
  " <CR>: close popup and save indent.
  " inoremap <expr><CR>  neocomplete#smart_close_popup() . "\<CR>"
  inoremap <silent> <CR> <C-R>=neocomplete#smart_close_popup()<CR><CR>

  " <TAB>: completion.
  " inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

  " <C-h>, <BS>: close popup and delete backword char.
  if s:bundle.is_installed('vim-smartinput')
    " inoremap <expr> <C-h>  neocomplete#smart_close_popup()
    "       \ . eval(smartinput#sid().'_trigger_or_fallback("\<BS>", "\<C-h>")')
    " inoremap <expr> <BS>   neocomplete#smart_close_popup()
    "       \ .eval(smartinput#sid().'_trigger_or_fallback("\<BS>", "\<BS>")')
    imap <expr> <C-h>  neocomplete#smart_close_popup()
          \ . "\<Plug>(smartinput_BS)"
    imap <expr> <BS>   neocomplete#smart_close_popup()
          \ . "\<Plug>(smartinput_C-h)"
  else
    inoremap <expr><C-h>  neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS>   neocomplete#smart_close_popup()."\<C-h>"
  endif

  " inoremap <expr> <C-y>  neocomplete#close_popup()
  inoremap <expr> <C-e> pumvisible() ? neocomplete#cancel_popup() : "\<End>"

  inoremap <expr> <C-j> pumvisible() ? neocomplete#close_popup() : "\<CR>"

  imap <C-s> <Plug>(neocomplete_start_unite_complete)

  nnoremap [!space]ne :NeocompleteEnable<CR>
  nnoremap [!space]nd :NeocompleteDisable<CR>

  " endwise
  " inoremap <silent> <cr> <c-r>=EnterIndent()<cr>
  " if s:bundle.is_installed('vim-enter-indent')
  "   Lazy inoremap <silent><expr> <CR> (pumvisible()?neocomplete#smart_close_popup():"")."\<C-r>=indent_cr#enter()\<CR>\<C-r>=endwize#crend()\<CR>"
    imap <silent><expr> <CR> (pumvisible()?neocomplete#smart_close_popup():"")
          \ ."\<Plug>(smartinput_CR)\<C-r>=endwize#crend()\<CR>"
  " else
  "   Lazy inoremap <silent><expr> <CR> (pumvisible()?neocomplete#smart_close_popup():"")."\<CR>\<C-r>=endwize#crend()\<CR>"
  " endif
endif

" completes {{{3
let g:nodejs_complete_config = {
      \ 'max_node_compl_len': 15,
      \ }
if s:bundle.is_installed('tern_for_vim')
  let g:nodejs_complete_config.js_compl_fn = 'tern#Complete'
elseif s:bundle.is_installed('jscomplete-vim')
  let g:nodejs_complete_config.js_compl_fn= 'jscomplete#CompleteJS'
endif
" let g:node_usejscomplete = 1
let g:jscomplete_use = ['dom', 'es6th', 'moz']

if exists("+omnifunc") " {{{4
  MyAutoCmd FileType php           setl omnifunc=phpcomplete#CompletePHP
  MyAutoCmd FileType html,markdown setl omnifunc=htmlcomplete#CompleteTags
  MyAutoCmd FileType python        setl omnifunc=pythoncomplete#Complete
  " MyAutoCmd FileType javascript   setl omnifunc=javascriptcomplete#CompleteJS
  " MyAutoCmd FileType javascript    setl omnifunc=jscomplete#CompleteJS
  if s:bundle.is_installed('tern_for_vim')
    " mark
    MyAutoCmd FileType coffee    setl omnifunc=tern#Complete
  elseif s:bundle.is_installed('vim-nodejs-complete')
    MyAutoCmd FileType javascript,coffee    setl omnifunc=nodejscomplete#CompleteJS
  endif
  MyAutoCmd FileType java          setl omnifunc=javacomplete#Complete completefunc=javacomplete#CompleteParamsInfo
  MyAutoCmd FileType xml           setl omnifunc=xmlcomplete#CompleteTags
  MyAutoCmd FileType css           setl omnifunc=csscomplete#CompleteCSS
  MyAutoCmd FileType c             setl omnifunc=ccomplete#Complete
  MyAutoCmd FileType actionscript  setl omnifunc=actionscriptcomplete#CompleteAS
  MyAutoCmd FileType *
        \ if &l:omnifunc == ''
        \ | setlocal omnifunc=syntaxcomplete#Complete
        \ | endif
endif

if s:bundle.is_installed('rsense')
  let $RSENSE_HOME = s:bundle.get('rsense').path
endif

" if exists('$RSENSE_HOME') " {{{4 RSENSE
"   let g:rsenseHome=$RSENSE_HOME
"   let g:rsenseUseOmniFunc=0
" elseif exists('+omnifunc')
"   "MyAutoCmd FileType ruby setl omnifunc=rubycomplete#Complete
" endif

" vimproc {{{2
if s:bundle.is_installed('vimproc.vim')
  function! s:setup_vimproc_dll() " {{{3
    let path = ""
    let vimproc_root = s:bundle.get('vimproc.vim').path
    if s:is_win
      if has('unix')
        let path = expand(vimproc_root . '/autoload/proc_cygwin.dll')
      elseif has('win64')
        let path = expand('$VIM/plugins/vimproc/autoload/vimproc_win64.dll')
      elseif has('win32')
        let path = expand('$VIM/plugins/vimproc/autoload/vimproc_win32.dll')
      endif
      " else
      "   if has('win64')
      "     let path = expand(vimproc_root . '/autoload/proc_win64.dll')
      "   else
      "     let path = expand(vimproc_root . '/autoload/proc_win32.dll')
      "   endif
      "   if !filereadable(path)
      "     if has('win64')
      "       let path = expand('~/.vim/lib/vimproc/vimproc_win64.dll')
      "     elseif has('win32')
      "       let path = expand('~/.vim/lib/vimproc/vimproc_win32.dll')
      "     elseif has('win16')
      "       let path = expand('~/.vim/lib/vimproc/vimproc_win16.dll')
      "     endif
      "   endif
      " endif
    elseif s:is_mac
      let path = expand(vimproc_root . '/autoload/proc_mac.so')
    else
      let path = expand(vimproc_root . '/autoload/proc_unix.so')
    endif
    if filereadable(path)
      let g:vimproc_dll_path = path
      let g:vimproc#dll_path = path
    endif
  endfunction " }}}

  call s:setup_vimproc_dll()
endif

" vimshell {{{2
if s:bundle.is_installed('vimshell')
  let g:vimshell_temporary_directory = $VIM_CACHE . "/vimshell"
  let g:vimshell_enable_smart_case = 1
  let g:vimshell_enable_auto_slash = 1

  let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
  if s:bundle.is_installed('vim-fugitive')
    " let g:vimshell_right_prompt = '"[" . fugitive#head() . "]"'
    let g:vimshell_right_prompt = 'fugitive#statusline()'
  endif
  " if s:bundle.is_installed('vim-vcs')
  "   let g:vimshell_right_prompt = 'vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'
  " endif

  if s:is_win " {{{3
    " Display user name on Windows.
    let g:vimshell_prompt = $USERNAME."% "
    let g:vimshell_use_ckw = 1
    "let g:vimproc_dll_path = expand("~/.vim/lib/vimproc/win32/proc.dll")
  else " {{{3
    " Display user name
    let g:vimshell_prompt = $USER."$ "
  endif

  let s:vimshell_hooks = {} "{{{3
  function! s:vimshell_hooks.chpwd(args, context)
    if len(split(glob('*'), '\n')) < 100
      call vimshell#execute('ls')
    else
      call vimshell#execute('echo "Many files."')
    endif
  endfunction
  function! s:vimshell_hooks.emptycmd(cmdline, context)
    call vimshell#set_prompt_command('ls')
    return 'ls'
  endfunction

  function! s:vimshell_hooks.preprompt(args, context)
    " call vimshell#execute('echo "preprompt"')
  endfunction

  function! s:vimshell_hooks.preexec(cmdline, context)
    " call vimshell#execute('echo "preexec"')

    let args = vimproc#parser#split_args(a:cmdline)
    if len(args) > 0 && args[0] ==# 'diff'
      call vimshell#set_syntax('diff')
    endif

    return a:cmdline
  endfunction

  MyAutoCmd FileType vimshell call s:vimshell_init()
  function! s:vimshell_init() " {{{3
    setl textwidth=0
    "autocmd FileType vimshell
    call vimshell#altercmd#define('g'  , 'git')
    call vimshell#altercmd#define('i'  , 'iexe')
    call vimshell#altercmd#define('t'  , 'texe')
    " call vimshell#set_alias('l'  , 'll')
    " call vimshell#set_alias('ll' , 'ls -l')
    " call vimshell#set_alias('la' , 'ls -a')
    " call vimshell#set_alias('e' , 'vim')
    " call vimshell#set_alias('time' , 'exe time')

    if !s:is_win
      let g:vimshell_execute_file_list['zip'] = 'zipinfo'
      call vimshell#set_execute_file('tgz,gz', 'gzcat')
      call vimshell#set_execute_file('tbz,bz2', 'bzcat')
    endif
    if s:is_mac
      call vimshell#set_alias('gvim'  , 'gexe mvim')
      call vimshell#set_alias('mvim'  , 'gexe mvim')
    else
      call vimshell#set_alias('gvim'  , 'gexe gvim')
      call vimshell#set_alias('mvim'  , 'gexe gvim')
    endif
    if s:is_win
    elseif s:is_mac
      " call vimshell#set_execute_file('bmp,jpg,png,gif', 'gexe open')
      " call vimshell#set_execute_file('mp3,m4a,ogg', 'gexe open')
      let g:vimshell_use_terminal_command = 'open'
    else
      call vimshell#set_execute_file('bmp,jpg,png,gif', 'gexe eog')
      call vimshell#set_execute_file('mp3,m4a,ogg', 'gexe amarok')
      let g:vimshell_use_terminal_command = 'gnome-terminal -e'
    endif

    if executable('pry')
      call vimshell#set_alias('pry' , 'iexe irb')
      call vimshell#set_alias('irb' , 'iexe irb')
    endif

    call vimshell#hook#add('chpwd'     , 'my_chpwd', s:vimshell_hooks.chpwd)
    call vimshell#hook#add('emptycmd'  , 'my_emptycmd', s:vimshell_hooks.emptycmd)
    call vimshell#hook#add('preprompt' , 'my_preprompt', s:vimshell_hooks.preprompt)
    call vimshell#hook#add('preexec'   , 'my_preexec', s:vimshell_hooks.preexec)

    if s:bundle.is_installed('concealedyank.vim')
      nmap y <Plug>(operator-concealedyank)
      xmap y <Plug>(operator-concealedyank)
    endif

    nmap <buffer><nowait> q <Plug>(vimshell_exit)
    nmap <buffer> I G<Plug>(vimshell_append_enter)
    imap <silent> <buffer> <C-a> <C-o>:call cursor(line('.'), strlen(g:vimshell_prompt)+1)<CR>
    if s:bundle.is_installed('neocomplcache.vim')
      inoremap <expr><buffer> <C-j> pumvisible() ? neocomplcache#close_popup() : ""
    elseif s:bundle.is_installed('neocomplete.vim')
      inoremap <expr><buffer> <C-j> pumvisible() ? neocomplete#close_popup() : ""
    endif
  endfunction


  nmap [!space]vp :<C-u>VimShellPop<CR>
  nmap [!space]vv :<C-u>VimShellTab<CR>
  nmap [!space]ve :<C-u>VimShellExecute<Space>
  nmap [!space]vi :<C-u>VimShellInteractive<Space>
  nmap [!space]vt :<C-u>VimShellTerminal<Space>

  command! IRB VimShellInteractive irb
  LCAlias IRB
endif

" vimfiler {{{2
if s:bundle.is_installed('vimfiler.vim')
  let g:vimfiler_data_directory = $VIM_CACHE . '/vimfiler'
  let g:vimfiler_as_default_explorer=1
  let g:vimfiler_safe_mode_by_default=0
  " let g:vimfiler_edit_action = 'below'
  " let g:vimfiler_edit_action = 'tabopen'

  let g:vimfiler_file_icon = '-'
  let g:vimfiler_tree_leaf_icon = ' '
  if s:is_win
    let g:vimfiler_tree_opened_icon = '-'
    let g:vimfiler_tree_closed_icon = '+'
  else
    let g:vimfiler_tree_opened_icon = '▾'
    let g:vimfiler_tree_closed_icon = '▸'
  endif
  " let g:vimfiler_marked_file_icon = '*'
  if s:is_mac
    let g:vimfiler_readonly_file_icon = '✗'
    let g:vimfiler_marked_file_icon = '✓'
  else
    let g:vimfiler_readonly_file_icon = 'x'
    let g:vimfiler_marked_file_icon = 'v'
  endif

  " keymaps {{{3
  nnoremap <silent> [!space]f  :call <SID>vimfiler_tree_launch()<CR>
  nnoremap <silent> [!space]ff :call <SID>vimfiler_tree_launch()<CR>
  nnoremap <silent> [!space]fg :call <SID>vimfiler_tree_launch(fnameescape(expand('%:p:h')))<CR>
  command! -nargs=? -complete=file VimFilerTree call s:vimfiler_tree_launch(<f-args>)
  command! -nargs=? -complete=file FTree call s:vimfiler_tree_launch(<f-args>)

  function! s:vimfiler_tree_launch(...) "{{{4
    let fpath = a:0 > 0 ? a:1 : getcwd()
    execute 'VimFiler -toggle -split -direction=topleft -buffer-name=ftree -simple -winwidth=40 file:' . fpath
  endfunction

  function! s:vimfiler_smart_tree_h(...) "{{{4
    let file = vimfiler#get_file()
    let cmd = a:0 > 0 ? a:1 : ""
    "\<Plug>(vimfiler_smart_h)"
    if !empty(file)
      if file.vimfiler__is_opened
        let cmd = "\<Plug>(vimfiler_expand_tree)"
      elseif file.vimfiler__nest_level > 0
        let nest_level = file.vimfiler__nest_level
        while 1
          exe 'normal!' 'k'
          let file = vimfiler#get_file()
          if empty(file) || file.vimfiler__nest_level < nest_level
            " let cmd = "\<Plug>(vimfiler_expand_tree)" | break
            normal! ^
            return
          endif
        endwhile
      endif
    endif
    if !empty(cmd)
      exe 'normal' cmd
      normal! ^
    endif
  endfunction

  function! s:vimfiler_tree_up() "{{{4
    call s:vimfiler_smart_tree_h("\<Plug>(vimfiler_smart_h)")
  endfunction

  function! s:vimfiler_tree_edit(method, ...) "{{{4
    " let file = vimfiler#get_file()
    " if empty(file) || empty(a:method) | return | endif
    " let path = file.action__path
    " wincmd p
    " execute a:method
    " exe 'edit' path
    if empty(a:method) | return | endif
    let linenr = line('.')
    let context = s:vimfiler_create_action_context(a:method, linenr)
    let cur_nr = bufnr('%')
    " silent wincmd l
    silent wincmd p
    if cur_nr == bufnr('%')
      silent wincmd l
      if cur_nr == bufnr('%')
        silent wincmd v
      endif
    endif
    for cmd in a:000
      silent execute cmd
    endfor
    " call vimfiler#mappings#do_action(a:method, linenr)
    call context.execute()
    unlet context
  endfunction

  function! s:vimfiler_smart_tree_l(method, ...) "{{{4
    let file = vimfiler#get_file()
    if empty(file)
      if (a:0 > 0 && a:1 == 1)
        execute 'normal' "\<Plug>(vimfiler_smart_h)"
      endif
      return
    endif
    let path = file.action__path
    if file.vimfiler__is_directory
      if (a:0 > 0 && a:1 == 2)
        execute 'normal' "\<Plug>(vimfiler_smart_l)"
      else
        execute 'normal' "\<Plug>(vimfiler_expand_tree)"
      endif
      normal! ^
      return
    endif
    call s:vimfiler_tree_edit(a:method)
  endfunction "}}}
  function! s:vimfiler_do_action(action) " {{{4
    let bnr = bufnr('%')
    let linenr = line('.')
    let context = s:vimfiler_create_action_context(a:action, linenr)
    call context.execute()
    unlet context
  endfunction


  let s:vimfiler_context = {} " {{{4
  function! s:vimfiler_context.new(...)
    let dict = get(a:000, 0, {})
    return extend(dict, self)
  endfunction

  function! s:vimfiler_context.execute()
    call unite#mappings#do_action(self.action, self.files, {
          \ 'vimfiler__current_directory' : self.current_dir,
          \ })
  endfunction

  function! s:vimfiler_create_action_context(action, ...) " {{{4
    let cursor_linenr = get(a:000, 0, line('.'))
    let vimfiler = vimfiler#get_current_vimfiler()
    let marked_files = vimfiler#get_marked_files()
    if empty(marked_files)
      let marked_files = [ vimfiler#get_file(cursor_linenr) ]
    endif

    let context = s:vimfiler_context.new({
          \ 'action' : a:action,
          \ 'files' : marked_files,
          \ 'current_dir' : vimfiler.current_dir,
          \ })
    return context
  endfunction

  MyAutoCmd FileType vimfiler call s:vimfiler_init() "{{{3
  function! s:vimfiler_init() " {{{3
    nnoremap <silent><buffer> E :<C-u>call <SID>vimfiler_do_action('tabopen')<CR>
    nnoremap <silent><buffer> <C-e> :<C-u>call <SID>vimfiler_do_action('split')<CR>
    nmap <buffer> u <Plug>(vimfiler_move_to_history_directory)
    hi link ExrenameModified Statement
    "nnoremap <buffer> v V
    if exists('b:vimfiler') && !exists('b:my_vimfiler_init')
      let b:my_vimfiler_init=1
      if exists('b:vimfiler.context.explorer') && b:vimfiler.context.explorer "{{{4
        " nmap <silent><buffer> L <Plug>(vimfiler_smart_l)
        " nmap <silent><buffer> E :call <SID>vimfiler_tabopen()<CR>
        " " smart_h ができない…ｼｮﾎﾞﾝﾇ(´Д｀)
        " " nmap <silent><buffer> H <Plug>(vimfiler_smart_h)
        " if exists('g:scrolloff')
        "   nnoremap <silent><buffer> <LeftMouse>       <Esc>:set eventignore=all<CR><LeftMouse>:<C-u>execute "normal \<Plug>(vimfiler_expand_tree)"<CR>:set eventignore=<CR>
        "   nnoremap <silent><buffer> <2-LeftMouse>     <Esc>:set eventignore=all<CR><LeftMouse>:<C-u>execute "normal \<Plug>(vimfiler_execute_system_associated)"<CR>:set eventignore=<CR>
        " else
        "   nnoremap <silent><buffer> <LeftMouse> :call <SID>noscrolloff_leftmouse()<CR>:<C-u>execute "normal \<Plug>(vimfiler_expand_tree)"<CR>
        "   nnoremap <silent><buffer> <2-LeftMouse> :call <SID>noscrolloff_leftmouse()<CR>:<C-u>execute "normal \<Plug>(vimfiler_execute_system_associated)"<CR>
        " endif
      elseif exists('b:vimfiler.context') && b:vimfiler.context.profile_name == 'ftree' "{{{4
        nnoremap <silent><buffer> e :call <SID>vimfiler_tree_edit('open')<CR>
        nnoremap <silent><buffer> E :call <SID>vimfiler_tree_edit('open', 'wincmd s')<CR>
        nnoremap <silent><buffer> <C-e> :call <SID>vimfiler_do_action('tabopen')<CR>
        nnoremap <silent><buffer> l :call <SID>vimfiler_smart_tree_l('')<CR>
        if exists('g:scrolloff')
          nnoremap <silent><buffer> <LeftMouse>       <Esc>:set eventignore=all<CR><LeftMouse>:<C-u>:call <SID>vimfiler_smart_tree_l('', 1)<CR>:set eventignore=<CR>
          nnoremap <silent><buffer> <2-LeftMouse>     <Esc>:set eventignore=<CR><LeftMouse>:<C-u>:call <SID>vimfiler_smart_tree_l('open', 2)<CR>
        else
          nnoremap <silent><buffer> <LeftMouse> :call <SID>noscrolloff_leftmouse()<CR>:call <SID>vimfiler_smart_tree_l('', 1)<CR>
          nnoremap <silent><buffer> <2-LeftMouse> :call <SID>noscrolloff_leftmouse()<CR>:call <SID>vimfiler_smart_tree_l('open', 2)<CR>
        endif
        " nmap <buffer> l <Plug>(vimfiler_expand_tree)
        nmap <buffer> L <Plug>(vimfiler_smart_l)
        nnoremap <silent><buffer> h :call <SID>vimfiler_smart_tree_h()<CR>
        nnoremap <silent><buffer> gu :call <SID>vimfiler_tree_up()<CR>
      endif
    endif
  endfunction
endif

" vinarise {{{2
" let g:vinarise_enable_auto_detect = 1

" memolist {{{2
if s:bundle.is_installed('memolist.vim')
  let g:memolist_memo_suffix = "md"
  let g:memolist_path = $HOME . '/memo'
  " let g:memolist_vimfiler = 1

  if s:bundle.is_installed('unite.vim')
    nmap <silent> [!prefix]ml :<C-u>Unite memolist<CR>
    nmap <silent> [!prefix]mg :<C-u>call <SID>unite_grep(g:memolist_path)<CR>
  else
    nmap <silent> [!prefix]ml :MemoList<CR>
    nmap <silent> [!prefix]mg :MemoGrep<CR>
  endif
  nmap <silent> [!prefix]mc :MemoNew<CR>
endif

" etc functions & commands {{{1
" git "{{{2
" special git log viewer {{{3
function! s:git_log_viewer(commit)
  " vnew
  new
  setl buftype=nofile
  setl buflisted
  "VimProcRead git log -u 'HEAD@{1}..HEAD' --reverse
  let commit = empty(a:commit) ? 'ORIG_HEAD..HEAD' : a:commit . ' -n 1'
  execute 'VimProcRead git log -u ' commit
  " set filetype=git-log.git-diff
  set filetype=git
  setl foldmethod=expr
  " setl foldexpr=getline(v:lnum)!~'^commit'
  setlocal foldexpr=GitLogViewerFoldExpr(v:lnum)
  setlocal foldtext=GitLogViewerFoldText()
endfunction

function! GitLogViewerFoldExpr(lnum)
  let line = getline(a:lnum)
  let next_line = getline(a:lnum)
  if line =~ '^commit'
    return '>1'
  elseif next_line =~ '^commit'
    return '<1'
  elseif line =~ '^diff'
    return '>2'
  elseif next_line =~ '^diff'
    return '<2'
  endif
  return '='
endfunction

" git log表示時の折りたたみ用
function! GitLogViewerFoldText()
  let month_map = {
        \ 'Jan' : '01',
        \ 'Feb' : '02',
        \ 'Mar' : '03',
        \ 'Apr' : '04',
        \ 'May' : '05',
        \ 'Jun' : '06',
        \ 'Jul' : '07',
        \ 'Aug' : '08',
        \ 'Sep' : '09',
        \ 'Oct' : '10',
        \ 'Nov' : '11',
        \ 'Dec' : '12',
        \ }

  if getline(v:foldstart) !~ '^commit'
    return getline(v:foldstart)
  endif

  if getline(v:foldstart + 1) =~ '^Author:'
    let author_lnum = v:foldstart + 1
  elseif getline(v:foldstart + 2) =~ '^Author:'
    " commitの次の行がMerge:の場合があるので
    let author_lnum = v:foldstart + 2
  else
    " commitの下2行がどちらもAuthor:で始まらなければ諦めて終了
    return getline(v:foldstart)
  endif

  let date_lnum = author_lnum + 1
  let message_lnum = date_lnum + 2

  let author = matchstr(getline(author_lnum), '^Author: \zs.*\ze <.\{-}>')
  let date = matchlist(getline(date_lnum), ' \(\a\{3}\) \(\d\{1,2}\) \(\d\{2}:\d\{2}:\d\{2}\) \(\d\{4}\)')
  let message = getline(message_lnum)

  let month = date[1]
  let day = printf('%02s', date[2])
  let time = date[3]
  let year = date[4]

  let datestr = join([year, month_map[month], day], '-')

  return join([datestr, time, author, message], ' ')
endfunction

command! -nargs=? GitLogViewer call s:git_log_viewer(<q-args>)

" Git Diff -> The file {{{3
function! SGoDiff()
  let [maybe, fname] = s:latest_fname()
  if maybe ==# 'nothing'
    echoerr 'failed to find the filename'
    return
  endif

  let [maybe, linenum] = s:latest_linenum()
  if maybe ==# 'nothing'
    echoerr 'failed to find the linenum'
    return
  endif

  " execute "vnew" fname
  execute "new" fname
  execute linenum
  execute "normal! z\<Cr>"
endfunction

function! s:vimrc_init_sgodiff()
  nnoremap <silent><buffer> <C-d> :<C-u>call SGoDiff()<Cr>
  nnoremap <silent><buffer> <CR> :<C-u>call SGoDiff()<Cr>
endfunction

augroup vimrc-sgodiff
  autocmd!
  autocmd FileType git-diff call s:vimrc_init_sgodiff()
  autocmd FileType git-log.git-diff call s:vimrc_init_sgodiff()
augroup END

function! s:latest_fname()
  for i in reverse(range(1, line('.')))
    let line = getline(i)
    if line =~ '^+++ '
      return ['just', substitute(line[4:], '^b\/\|\t.*$', '', 'b')]
    endif
  endfor
  return ['nothing', '']
endfunction

function! s:latest_linenum()
  for i in reverse(range(1, line('.')))
    let line = getline(i)
    if line =~ '^@@ '
      let a = matchlist(line, '^@@ -.\{-},.\{-} +\(.\{-}\),')
      if exists('a[1]')
        return ['just', a[1]]
      endif
    endif
  endfor
  return ['nothing', '']
endfunction

" tiny snippets {{{2
let g:my_snippets_dir = $HOME . "/memos/tiny-snippets"

" if s:bundle.is_installed('unite.vim')
"   let s:unite_action_file_insert = {} " {{{3
"   function! s:unite_action_file_insert.func(candicate)
"     "echo a:candicate
"     let l:path = a:candicate.word
"     if isdirectory(l:path)
"       call unite#do_action('narrow')
"     elseif filereadable(l:path)
"       let linesread=line('$')
"       let l:old_cpoptions=&cpoptions
"       setlocal cpoptions-=a
"       :execute 'read '.l:path
"       let &cpoptions = l:old_cpoptions
"       let linesread=line('$')-linesread-1
"       if linesread >= 0
"         silent exe 'normal! ='.linesread.'+'
"       endif
"     endif
"   endfunction
"   call unite#custom_action('file', 'insert_file', s:unite_action_file_insert)
"   unlet! s:unite_action_file_insert
" endif

" }}}
" mapping for tiny-snippets
nnoremap [!unite]n <Nop>
nnoremap <silent> [!unite]nn :<C-u>execute printf('Unite file_rec:%s -start-insert', expand(g:my_snippets_dir))<CR>
nnoremap <silent> [!unite]ng :<C-u>call <SID>unite_grep(g:my_snippets_dir, '-no-quit')<CR>
nnoremap <silent> [!unite]nm :<C-u>execute 'Unite memolist_rec:'.expand(g:my_snippets_dir)<CR>
nnoremap <silent> [!unite]nv :<C-u>execute 'VimFiler' g:my_snippets_dir<CR>

" filetype command {{{2
command! EditFt execute expand(':e ~/.vim/after/ftplugin/'.&filetype.'.vim')

" buffer commands {{{2
command! ToUnixBuffer set fileformat=unix fileencoding=utf8
command! ToWindowsBuffer set fileformat=dos fileencoding=cp932
command! ToMacBuffer set fileformat=mac fileencoding=utf8
command! TrimRSpace %s/ \+$//
command! ConvChilder %s/〜/～/g
command! ToSass call my#util#newfile_with_text(expand('%:p:r').".sass",
      \ system(printf('sass-convert -F css -T sass "%s"', expand('%:p')))
      \ )
command! ToScss call my#util#newfile_with_text(expand('%:p:r').".scss",
      \ system(printf('sass-convert -F css -T scss "%s"', expand('%:p')))
      \ )
command! ToCoffee call my#util#newfile_with_text(expand('%:p:r').".coffee",
      \ system(printf('js2coffee < "%s"', expand('%:p')))
      \ )
      " \ system(printf('js2coffee "%s"', expand('%:p')))

" シェル起動系 {{{2
if s:is_mac "{{{3
  " Utility command for Mac
  command! Here silent execute '!open' shellescape(expand('%:p:h'))
  command! This silent execute '!open' shellescape(expand('%:p'))
  command! In silent execute '!osascript' '-e' "'tell application \"Terminal\" to do script \"cd ".expand('%:p:h')."; clear;\"'"
  command! -nargs=1 -complete=file That silent execute '!open' shellescape(expand(<f-args>), 1)
  command! SublimeEdit silent execute '!open' '-a' 'Sublime\ Text\ 2' shellescape(expand('%:p'))
  command! CotEdit silent execute '!open' '-a' 'CotEditor' shellescape(expand('%:p'))
  command! Mate silent execute '!open' '-a' 'TextMate' shellescape(expand('%:p'))
elseif s:is_win "{{{3
  " Utility command for Windows
  command! Here silent execute '!explorer' substitute(expand('%:p:h'), '/', '\', 'g')
  command! This silent execute '!start cmd /c "%"'
  command! In silent execute '!start cmd /k cd "'.substitute(expand('%:p:h'), '/', '\', 'g').'"'
  command! -nargs=1 -complete=file That silent execute '!explorer' shellescape(expand(<f-args>), 1)
else "{{{3
  " TODO
  " command! Here silent execute '!gnome-open' expand('%:p:h')
  command! Here silent execute '!xdg-open' expand('%:p:h') '&'
  command! This silent execute '!"%"'
  if executable('gnome-terminal')
    command! In silent execute '!gnome-terminal --working-directory="'.shellescape(expand('%:p:h')).'"' '&'
  elseif executable('konsole')
    command! In silent execute '!konsole --workdir="'.shellescape(expand('%:p:h')).'"' '&'
  else
    command! In silent execute '!kterm -e "cd '.shellescape(expand('%:p:h')).'; exec $SHELL"' '&'
  endif
  command! -nargs=1 -complete=file That silent execute '!xdg-open' shellescape(expand(<f-args>), 1) '&'
endif
"}}}
LCAlias Here This That

" chm launcher {{{2
if exists('g:my_chm_dir') && (s:is_win || (!s:is_win && !empty(g:my_chm_command)))
  command! -nargs=1 -complete=customlist,my#chm#complete
        \ Chm call my#chm#open("<args>")
  LCAlias Chm
endif

if exists('g:my_cheatsheets_dir')
  command! -nargs=1 -complete=customlist,my#cheatsheet#complete
        \ CheatSheet call my#cheatsheet#open("<args>")
  LCAlias CheatSheet
endif

" tail {{{2
if executable('tail')
  command! -nargs=1 -complete=file Tail VimShellExecute tail -f <args>
  LCAlias Tail
endif

" unique {{{2
command! -range -nargs=0 UniqueSort <line1>,<line2>sort u

" diff {{{2
command! -nargs=1 -complete=buffer DiffBuf vertical diffsplit <args>
command! -nargs=1 -complete=file DiffFile vertical diffsplit <args>
function! s:diff_execute(s)
  if &diff
    execute a:s
  endif
endfunction
command! -nargs=0 DiffQuit call <SID>diff_execute('diffoff')
command! -nargs=0 DQ call <SID>diff_execute('diffoff')

" rename {{{2
command! -nargs=? -complete=file Rename call my#ui#rename(<q-args>)
Alias ren Rename

command! -nargs=1 -complete=file Relcp call my#ui#relative_copy(<f-args>)
LCAlias Relcp

" win maximize toggle {{{3
nnoremap [!prefix]mm :call my#winmaximizer#get().toggle()<CR>
nnoremap [!prefix]mj :call my#winmaximizer#get().toggleDirection("v")<CR>
nnoremap [!prefix]mh :call my#winmaximizer#get().toggleDirection("h")<CR>

" fopen & encoding {{{2
command! -nargs=1 -complete=customlist,my#ui#complete_encodings Fenc setl fenc=<args>
command! -nargs=1 -complete=customlist,my#ui#complete_encodings Freopen e ++enc=<args> %

command! -nargs=? -bang -complete=file Utf8 edit<bang> ++enc=utf-8 <args>
command! -nargs=? -bang -complete=file Euc  edit<bang> ++enc=euc-jp <args>
command! -nargs=? -bang -complete=file Sjis edit<bang> ++enc=cp932 <args>
command! -nargs=? -bang -complete=file Jis  edit<bang> ++enc=iso-2022-jp <args>
command! -nargs=? -bang -complete=file Dos  edit<bang> ++ff=dos <args>
command! -nargs=? -bang -complete=file Mac  edit<bang> ++ff=mac <args>
command! -nargs=? -bang -complete=file Unix edit<bang> ++ff=unix <args>
command! Ccd if isdirectory(expand('%:p:h')) | execute ":lcd " . expand("%:p:h") | endif
LCAlias Utf8 Euc Sjis Jis Ccd
" }}}
" utility {{{2
" 選択範囲をブラウザで起動 {{{3
if s:is_win
  "let g:my_preview_browser_cmd = ' start chrome.exe'
  let g:my_preview_browser_cmd = ' start ' . expand('$LOCALAPPDATA/Google/Chrome/Application/chrome.exe')
elseif s:is_mac
  let g:my_preview_browser_cmd = 'open -a "Google Chrome"'
else
  let g:my_preview_browser_cmd = 'firefox'
endif
" }}}
command! -range Brpreview <line1>,<line2>call my#ui#preview_browser()

" browser {{{3
command! Ie call my#ui#launch_browser('ie')
command! Firefox call my#ui#launch_browser('firefox')
command! Opera call my#ui#launch_browser('opera')
command! Chrome call my#ui#launch_browser('chrome')
command! Safari call my#ui#launch_browser('safari')
LCAlias Ie Firefox Opera Chrome Safari

" TSV {{{3
command! -range Tsvtohtmltable     <line1>,<line2>call my#tsv#to_htmltable()
command! -range Tsvtosqlwhere      <line1>,<line2>call my#tsv#to_sqlwhere()
command! -range Tsvtosqlin         <line1>,<line2>call my#tsv#to_sqlin()
command! -range Tsvinvert          <line1>,<line2>call my#tsv#invert()
command! -range Tsvtosqlinsert     <line1>,<line2>call my#tsv#to_sqlinsert()
command! -range Tsvtosqlupdate     <line1>,<line2>call my#tsv#to_sqlupdate()
command! -range Tsvtocsv           <line1>,<line2>call my#tsv#to_csv()
command! -range Tsvtojson          <line1>,<line2>call my#tsv#to_json()
command! -range Tsvtoflatjson      <line1>,<line2>call my#tsv#to_flat_json()

" MySQL {{{3
command! -nargs=0 -range TMY <line1>,<line2>call my#mysql#to_tsv()
command! -nargs=0 -range MySQLToTsv <line1>,<line2>call my#mysql#to_tsv()

" text {{{3
command! -nargs=0 -range=0 Plain call s:text_to_plain(<count>, <line1>, <line2>)
function! s:text_to_plain(count, l1, l2)
  if a:count <= 0
    return
  endif
  silent! execute a:l1.','a:l2.'s/[｀]/`/g'
  silent! execute a:l1.','a:l2."s/[‘’]/'/g"
  silent! execute a:l1.','a:l2.'s/[“”]/"/g'
  silent! execute a:l1.','a:l2.'s/　/  /g'
endfunction

" padding {{{3
command! -nargs=? -range PadNumber <line1>,<line2>call my#padding#number(<f-args>)
command! -nargs=? -range PadString <line1>,<line2>call my#padding#string(<f-args>)
command! -nargs=? -range PadSprintf <line1>,<line2>call my#padding#sprintf(<f-args>)

" buffer grep {{{3
command! -nargs=? BGY call my#bufgrep#yank(<q-args>)
command! -nargs=? BG call my#bufgrep#enew(<q-args>)

" capture {{{3
command!
      \ -nargs=+ -complete=command
      \ Capture
      \ call my#ui#cmd_capture(<q-args>)

" help utils {{{3
let s:help_util = {}

function! s:help_util.tagfiles()
  let tagfiles = split(globpath(&runtimepath, 'doc/tags'), "\n")
  let tagfiles += split(globpath(&runtimepath, 'doc/tags-*'), "\n")
  return tagfiles
endfunction

function! s:help_util.docdirs()
  return split(globpath(&runtimepath, 'doc'), "\n")
endfunction

function! s:help_util.refresh()
  call self.clear()
  call self.tags()
endfunction

function! s:help_util.clear_bundles()
  let tagfiles = self.tagfiles()
  for f in tagfiles
    if stridx(f, $HOME) != -1
      call delete(f)
      " echo f
    endif
  endfor
endfunction

function! s:help_util.clear()
  let tagfiles = self.tagfiles()
  for f in tagfiles
    call delete(f)
  endfor
endfunction

function! s:help_util.tags()
  let dirs = self.docdirs()
  for d in dirs
    silent execute 'helptags' d
  endfor
endfunction

function! s:help_util.show_tags()
  echo join(self.tagfiles(), "\n")
endfunction

function! s:help_util.show_dirs()
  echo join(self.docdirs(), "\n")
endfunction

command! -nargs=0 Helptags call s:help_util.refresh()
command! -nargs=0 HelptagsShow call s:help_util.show_tags()
command! -nargs=0 HelpDirShow call s:help_util.show_dirs()

" Browser Control
if s:is_mac
  command! -bar ChromePageGo silent !osascript ~/.vim/bin/chrome_go.scpt 1
  command! -bar ChromePageBack silent !osascript ~/.vim/bin/chrome_go.scpt -1
  command! -bar ChromeScrollDown silent !osascript ~/.vim/bin/chrome_scroll.scpt next
  command! -bar ChromeScrollUp silent !osascript ~/.vim/bin/chrome_scroll.scpt previous
  command! -bar ChromeTabClose silent !osascript ~/.vim/bin/chrome_tabclose.scpt next
  command! -bar ChromeTabReload silent !osascript ~/.vim/bin/chrome_reload.scpt next
  command! -bar ChromeTabRight silent !osascript ~/.vim/bin/chrome_tabselect.scpt right
  command! -bar ChromeTabLeft silent !osascript ~/.vim/bin/chrome_tabselect.scpt left
else
  " TODO :
endif

" ginger {{{2
let s:ginger = {}
let s:ginger.endpoint = 'http://services.gingersoftware.com/Ginger/correct/json/GingerTheText'
let s:ginger.apikey = '6ae0c3a0-afdc-4532-a810-82ded0054236'

augroup vimrc-ginger
  autocmd!
  autocmd BufNewFile __Ginger__ call s:ginger.buffer_init()
augroup END

function! s:ginger.buffer_init() "{{{3
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  setlocal buflisted
  resize 8
endfunction

function! s:ginger.range() range  "{{{3
  let text = join(getline(a:firstline, a:lastline), "\n")
  let [mistake, correct] = self.get(text)

  let bufname = "__Ginger__"
  let bufnum = bufnr(bufname)
  if bufnum == -1
    execute 'new' bufname
  else
    let winnum = bufwinnr(bufnum)
    if winnum != -1 && winnr() != winnum
      execute winnum . "wincmd w"
    else
      silent execute 'split +buffer' bufname
    endif
  endif

  normal! "Gzz"
  call append(line('$'), "Original: ".text)
  call append(line('$'), "Correct : ".correct)
endfunction

function! s:ginger.echo(text)  "{{{3
  let [mistake, correct] = self.get(text)
  echon "Mistake: " . mistake
  echon "Correct: " . correct
endfunction

function! s:ginger.get(text)  "{{{3
  let res = webapi#json#decode(webapi#http#get(self.endpoint, {
        \ 'lang': 'US',
        \ 'clientVersion': '2.0',
        \ 'apiKey': self.apikey,
        \ 'text': a:text}).content)
  let i = 0
  let mistake = ''
  let correct = ''
  " echon "Mistake: "
  for rs in res['LightGingerTheTextResult']
    let [from, to] = [rs['From'], rs['To']]
    if i < from
      " echon a:text[i : from-1]
      let mistake .= a:text[i : from-1]
      let correct .= a:text[i : from-1]
    endif
    " echohl WarningMsg
    " echon a:text[from : to]
    let mistake .= a:text[from : to]
    " echohl None
    if exists("rs['Suggestions'][0]")
      let correct .= rs['Suggestions'][0]['Text']
    endif
    let i = to + 1
  endfor
  if i < len(a:text)
    " echon a:text[i :]
    let mistake .= a:text[i :]
    let correct .= a:text[i :]
  endif
  " echo "Correct: ".correct
  " return correct
  return [mistake, correct]
endfunction
" command define {{{3
command! -nargs=0 -range GingerRange call s:ginger.range()
command! -nargs=+ Ginger echo s:ginger.get(<q-args>)

" ctags {{{2
let s:ctagsutil = {}  "{{{3
function s:ctagsutil.parse(...) "{{{4
  let lines = split(system('ctags --list-kinds'), "\n")
  let langmap = {}
  let lang = ""
  let charmap = {}
  let definitions = []
  for line in lines
    let matches = matchlist(line, '^\(\w\+\)$')
    if empty(matches)
      if empty(lang)
        continue
      endif
      " call add(definitions, substitute(line, '^\s\+\([^ \t]\)\s\+([^ \t][^\[\]]*).*$', '\1:\2', ''))
      let matches = matchlist(line, '^\s*\([^ \t]\)\s*\([^ \t][^\[\]]\+\).*$')
      " echo matches
      if !empty(matches)
        let ch = matches[1]
        if !exists('charmap[ch]')
          let charmap[ch] = 1
          let desc = substitute(matches[2], '^\s*\|\s*$', '', 'g')
          " escape
          let desc = substitute(desc, "'", "''", 'g')
          call add(definitions, printf("%s:%s", ch, desc))
        endif
      endif
    else
      if !empty(lang)
        let langmap[lang] = definitions
      endif
      let lang = matches[1]
      let definitions = []
      let charmap = {}
    endif
  endfor
  if !empty(lang) && !exists('langmap[lang]')
    let langmap[lang] = definitions
  endif
  let self.langmap = langmap
endfunction

function! s:ctagsutil.show() "{{{4
  call self.parse()
  for lang in keys(self.langmap)
    call self.taglist_source(lang)
    call self.tagbar_source(lang)
  endfor
endfunction

function! s:ctagsutil.taglist_source(...) "{{{4
  let langs = empty(a:000) ? keys(self.langmap) : a:000
  let m = []
  for lang in langs
    if !exists('self.langmap[lang]')
      echoerr "not found:".lang
      continue
    endif
    call add(m, printf("let g:tlist_%s_settings='%s;%s'", tolower(lang), lang, join(self.langmap[lang], ";")))
  endfor
  echo join(m, "\n")
endfunction

function! s:ctagsutil.tagbar_source(...) "{{{4
  let langs = empty(a:000) ? keys(self.langmap) : a:000
  let m = []
  for lang in langs
    if !exists('self.langmap[lang]')
      echoerr "not found:".lang
      continue
    endif
    call add(m, printf("let g:tagbar_type_%s = {'ctagstype': '%s', 'kinds':\n\\   %s\n\\ }",
          \ tolower(lang), lang, string(self.langmap[lang])))
  endfor
  echo join(m, "\n")
endfunction
" TagsConfigExample {{{3
command! -nargs=0 TagsConfigExample call s:ctagsutil.show()

" for vim {{{3
command! -nargs=0 ThisSyntaxName echo synIDattr(synID(line("."), col("."), 1), "name")
command! -nargs=0 ThisSyntax echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
                        \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
                        \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"

" util {{{2
function! s:to_scratch() "{{{3
  if empty(expand('%:p'))
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal buflisted
  endif
endfunction " }}}
command! -nargs=0 ToScratch call s:to_scratch()

" errorformat tester {{{2
let g:efm_tester_fmt = '%f:%l:%c:%m'
let g:efm_tester_after_execute = 'cwindow'
function! s:efm_tester(msg) "{{{3
  let org_efm = &g:errorformat
  try
    let &g:errorformat = g:efm_tester_fmt
    cgetexpr a:msg
    if !empty(g:efm_tester_after_execute)
      execute g:efm_tester_after_execute
    endif
  finally
    let &g:errorformat = org_efm
  endtry
endfunction " }}}
function! s:efm_tester_exec(count, l1, l2, text) "{{{3
  if a:count == 0 && empty(a:text)
    let msg = join(getline(1, '$'), "\n")
  else
    let msg = a:count == 0 ? a:text : join(getline(a:l1, a:l2), "\n")
  endif
  call s:efm_tester(msg)
endfunction " }}}
function! s:efm_tester_set(count, l1, l2, text)
  let s = a:count == 0 ? a:text : join(getline(a:l1, a:l2), "\n")
  if empty(fmt)
    echo "set g:efm_tester_fmt=" . string(fmt)
    let g:efm_tester_fmt = fmt
  else
    echo "g:efm_tester_fmt=" . string(g:efm_tester_fmt)
  endif
endfunction
command! -nargs=? -range=0 EfmTest call s:efm_tester_exec(<count>, <line1>, <line2>, <q-args>)
command! -nargs=? -range=0 EfmSetFormat call s:efm_tester_set(<count>, <line1>, <line2>, <q-args>)

" after initializes {{{1
if !has('vim_starting')
  if has('gui_running')
    execute 'source' expand("~/.gvimrc")
  endif

  if has('gui_running')
    " doautocmd GUIEnter,BufRead
    doautocmd VimEnter,GUIEnter
  else
    doautocmd VimEnter
  endif

  if exists('s:restore_setlocal')
    execute s:restore_setlocal
    unlet s:restore_setlocal
  endif
endif
" __END__ {{{1
" vim: set ft=vim fdm=marker sw=2 ts=2 et:
