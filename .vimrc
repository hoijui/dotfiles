" init setup {{{1
" platform detection {{{2
let s:is_mac = has('mac') || has('macunix') || has('gui_macvim') ||
      \ (executable('uname') && system('uname') =~? '^darwin')
let s:is_win = has('win16') || has('win32') || has('win64')
function! s:nop(...)
endfunction

" reset settings & restore runtimepath {{{2
let s:configured_runtimepath = &runtimepath
set all&

if has('vim_starting')
  set runtimepath^=$HOME/.vim
  set runtimepath+=$HOME/.vim/after
else
  if has('gui') | execute 'source' expand("~/.gvimrc") | endif
  let &runtimepath=s:configured_runtimepath
endif
unlet s:configured_runtimepath

" for win shell {{{2
if s:is_win
  let $HOME=substitute($HOME, '\\', '/', 'ge')
  function! s:init_cmd()
    set shell=$COMSPEC
    set shellcmdflag=/c
    set shellpipe=>%s\ 2>&1
    set shellxquote=\"
  endfunction
  if executable('nyacus')
    function! s:init_nyacus()
      " Use NYACUS.
      set shell=nyacus.exe
      set shellcmdflag=-e
      if executable('tee') | set shellpipe=\|&\ tee | endif
      set shellredir=>%s\ 2>&1
      set shellxquote=\"
    endfunction
    call s:init_nyacus()
  else
    call s:init_cmd()
  endif
endif

" preexec for runtimepath {{{1
set nocompatible
filetype off

" vundle {{{1
" load {{{2
let g:my_bundle_dir = expand("$HOME/.vim/neobundle")
if has('vim_starting')
  " pathogen
  call pathogen#infect()

  set runtimepath+=~/.vim/neobundle.vim
  call neobundle#rc(g:my_bundle_dir)

  syntax enable
endif

augroup my-neobundle-lazy-group
  autocmd!
augroup END
function s:my_neobundle_lazy_on(modes, sources)
  let sources = type(a:sources) == type([]) ? a:sources : [a:sources]
  let mode = type(a:modes) == type([]) ? join(a:modes, ",") : a:modes
  for uri in sources
    execute 'NeoBundleLazy' uri
    let name = fnamemodify(uri, ':te')
    let name = substitute(name, '^[''"]*\|\.git[''"]*$\|[''"]*$', '', 'g')
    execute 'autocmd' 'my-neobundle-lazy-group' 'FileType' mode 'silent' 'NeoBundleSource' name
  endfor
endfunction
command! -nargs=+ NeoBundleLazyOn call <SID>my_neobundle_lazy_on(<f-args>)

" vundles {{{2
NeoBundle 'Lokaltog/vim-powerline'
" colorscheme {{{3
NeoBundle 'tomasr/molokai'
NeoBundle 'mrkn/mrkn256.vim'
NeoBundle 'tpope/vim-vividchalk'
NeoBundle 'depuracao/vim-darkdevel'
NeoBundle 'goatslacker/mango.vim'
NeoBundle 'jpo/vim-railscasts-theme'
NeoBundle 'fmoralesc/vim-vitamins'
NeoBundle 'jnurmine/Zenburn'
NeoBundle 'gregsexton/Atom'
NeoBundle 'vim-scripts/rdark'
NeoBundle 'vim-scripts/Lucius'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'StanAngeloff/vim-zend55'
NeoBundle 'w0ng/vim-hybrid'

" lang {{{3
" basic {{{4
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'osyo-manga/shabadou.vim'
NeoBundle 'osyo-manga/vim-watchdogs'
NeoBundle 'kien/rainbow_parentheses.vim'
NeoBundle 'vim-scripts/matchit.zip'
NeoBundle 'vim-scripts/ruby-matchit'
NeoBundle 'vim-scripts/matchparenpp'
NeoBundle 'AndrewRadev/splitjoin.vim'
NeoBundle 'AndrewRadev/inline_edit.vim'
NeoBundle 'gregsexton/MatchTag'
" NeoBundle 'Raimondi/delimitMate'
NeoBundle 'kana/vim-smartinput'
NeoBundle 'acustodioo/vim-enter-indent'
" NeoBundle 'dahu/vim-fanfingtastic'

NeoBundle 'tpope/vim-unimpaired'
NeoBundle 'vim-scripts/ShowMultiBase'
NeoBundle 'tyru/current-func-info.vim'
" NeoBundle 'vim-scripts/taglist.vim'
NeoBundle 'majutsushi/tagbar'
" NeoBundle 'abudden/TagHighlight'
NeoBundle 'tomtom/tcomment_vim'
" NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'thinca/vim-template'
NeoBundle 'mattn/sonictemplate-vim'
NeoBundle 'ciaranm/detectindent'
" NeoBundle 'ujihisa/shadow.vim'
"NeoBundle 'motemen/git-vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'int3/vim-extradite'
NeoBundle 'Shougo/vim-vcs'
NeoBundle 'sjl/splice.vim'
NeoBundle 'vim-scripts/DirDiff.vim'
NeoBundleLazy 'mbadran/headlights'
NeoBundle 'thinca/vim-ft-diff_fold'

" help {{{4
NeoBundle 'thinca/vim-ref'
NeoBundle 'pekepeke/ref-javadoc'
NeoBundle 'soh335/vim-ref-jquery'
" NeoBundle 'mojako/ref-sources.vim'

" vim-help {{{4
NeoBundle 'mattn/learn-vimscript'
" git://gist.github.com/997811.git
" git://gist.github.com/1046979.git

" neocomplcache {{{4
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neocomplcache-snippets-complete'
NeoBundle 'basyura/csharp_complete'
NeoBundle 'osyo-manga/neocomplcache-jsx'

" ruby {{{4
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'tpope/vim-rails'
NeoBundle 'tpope/vim-cucumber'
NeoBundleLazyOn ruby 'ecomba/vim-ruby-refactoring'
NeoBundle 'vim-scripts/eruby.vim'
NeoBundle 'tobiassvn/vim-gemfile'
"NeoBundle 'astashov/vim-ruby-debugger'
NeoBundle 't9md/vim-chef'
NeoBundle 'taq/vim-rspec'

" html {{{4
NeoBundle 'othree/html5.vim'
" NeoBundle 'mattn/zencoding-vim'
NeoBundle 'tpope/vim-haml'
NeoBundle 'digitaltoad/vim-jade'
NeoBundleLazyOn html 'mattn/zencoding-vim'
NeoBundleLazyOn html,haml,jade 'vim-scripts/indenthtml.vim'

" css {{{4
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'cakebaker/scss-syntax.vim'
NeoBundle 'wavded/vim-stylus'
NeoBundle 'groenewege/vim-less'
NeoBundle 'bbommarito/vim-slim'
NeoBundleLazyOn css,sass,scss,less 'miripiruni/CSScomb-for-Vim'
" NeoBundle 'ap/vim-css-color'
NeoBundle 'Rykka/colorv.vim'
" if !(s:is_mac && has('gui'))
"   NeoBundle 'ap/vim-css-color'
" else
"   NeoBundleLazy 'ap/vim-css-color'
" endif
NeoBundle 'vim-scripts/cssbaseline.vim'
NeoBundleLazyOn css,sass,scss,less 'bae22/prefixer'

" javascript {{{4
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'teramako/jscomplete-vim'
NeoBundle 'myhere/vim-nodejs-complete'
" NeoBundle 'drslump/vim-syntax-js'
NeoBundle 'vim-scripts/jQuery'
" NeoBundle 'lukaszb/vim-web-indent'
" NeoBundle 'vim-scripts/IndentAnything'
" NeoBundle 'itspriddle/vim-javascript-indent'
" NeoBundle 'jiangmiao/simple-javascript-indenter'
NeoBundle 'vim-scripts/Dart'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'pekepeke/titanium-vim'
NeoBundle 'jeyb/vim-jst'
NeoBundle 'pekepeke/ref-jsextra-vim'
NeoBundle 'chikatoike/sourcemap.vim'

" python {{{4
" http://rope.sourceforge.net/
" NeoBundle 'klen/python-mode'
NeoBundleLazyOn python 'vim-scripts/python_match.vim'
NeoBundleLazyOn python 'lambdalisue/vim-python-virtualenv'
" NeoBundle 'lambdalisue/vim-django-support'
NeoBundleLazyOn python 'gerardo/vim-django-support'
" NeoBundle 'sontek/rope-vim'
" if executable('ipython')
"   NeoBundleLazy 'ivanov/vim-ipython'
" endif

" perl {{{4
NeoBundle 'petdance/vim-perl'

" OSX {{{4
NeoBundle 'nanki/vim-objj'
NeoBundle 'pekepeke/cocoa.vim'
NeoBundle 'vim-scripts/applescript.vim'

" android {{{4
NeoBundle 'thinca/vim-logcat'

" scala {{{4
NeoBundle 'derekwyatt/vim-scala'

" texts {{{4
NeoBundle 'plasticboy/vim-markdown'
NeoBundle 'thinca/vim-ft-markdown_fold'
NeoBundle 'timcharper/textile.vim'
NeoBundle 'chrisbra/csv.vim'
NeoBundle 'henrik/vim-yaml-flattener'

NeoBundle 'motemen/hatena-vim'
NeoBundle 'nvie/vim-rst-tables'
NeoBundle 'vim-scripts/DrawIt'
NeoBundle 'vim-scripts/sequence'

" haskell {{{4
" NeoBundle 'ehamberg/haskellmode-vim'
NeoBundleLazyOn haskell 'ujihisa/ref-hoogle'
NeoBundleLazyOn haskell 'ujihisa/neco-ghc'

" php {{{4
NeoBundle 'beyondwords/vim-twig'
NeoBundle 'tokutake/twig-indent'
NeoBundleLazyOn php 'violetyk/cake.vim'
NeoBundleLazyOn php 'justinrainbow/php-doc.vim'
NeoBundleLazyOn php 'vim-scripts/phpcomplete.vim'

" sql {{{4
NeoBundle 'mattn/vdbi-vim'
NeoBundle 'vim-scripts/dbext.vim'
NeoBundle 'vim-scripts/SQLUtilities'
"NeoBundle 'OmniCppComplete'
" shell {{{4
NeoBundle 'Shougo/vim-nyaos'
" etc {{{4
NeoBundle 'sophacles/vim-processing'
NeoBundle 'pekepeke/ref-processing-vim'
NeoBundle 'sjl/strftimedammit.vim'
NeoBundle 'tangledhelix/vim-octopress'
NeoBundle 'jcfaria/Vim-R-plugin'
NeoBundle 'smerrill/vcl-vim-plugin'
NeoBundle 'qqshfox/vim-tmux'
NeoBundle 'vim-scripts/nginx.vim'
NeoBundle 'glidenote/keepalived-syntax.vim'
NeoBundle 'uggedal/go-vim'
if executable('gocode')
  NeoBundle 'undx/vim-gocode'
endif
if has('ruby') && executable('sprout-as3')
  NeoBundle 'endel/flashdevelop.vim'
  NeoBundle 'tomtom/tlib_vim'
  NeoBundle 'airblade/vim-rooter'
endif
if executable('loga')
  NeoBundle 'tacahiroy/vim-logaling'
endif

" unite.vim {{{3
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-build'
NeoBundle 'Shougo/unite-help'
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'sgur/unite-git_grep'
" NeoBundle 'sgur/unite-qf'
NeoBundle 'osyo-manga/unite-quickfix'
NeoBundle 'tacroe/unite-mark'
NeoBundle 'thinca/vim-unite-history'
NeoBundle 'tsukkee/unite-tag'
" NeoBundle 'ujihisa/unite-launch'
NeoBundle 'ujihisa/quicklearn'
NeoBundle 'ujihisa/unite-gem'
NeoBundle 'ujihisa/unite-rake'
" NeoBundle 'basyura/unite-rails'
" NeoBundle 'oppara/vim-unite-cake'
" NeoBundle 'heavenshell/unite-zf'
" NeoBundle 'heavenshell/unite-sf2'
NeoBundle 'basyura/unite-yarm'
NeoBundle 'pasela/unite-webcolorname'
NeoBundle 'ujihisa/unite-colorscheme'
" NeoBundle 'ujihisa/unite-font'
" NeoBundle 'tacroe/unite-alias'
" NeoBundle 'hakobe/unite-script'
" NeoBundle 'mattn/unite-remotefile'
" NeoBundle 'pekepeke/unite-fileline'
NeoBundle 'zhaocai/unite-scriptnames'
NeoBundle 'daisuzu/unite-grep_launcher'

if s:is_win
  "NeoBundle 'sgur/unite-everything'
else
  if s:is_mac
    NeoBundle 'choplin/unite-spotlight'
  else
    NeoBundle 'ujihisa/unite-locate'
  endif
  NeoBundle 'ujihisa/neco-look'
endif

" common {{{3
NeoBundle 'mattn/benchvimrc-vim'
NeoBundle 'Shougo/vimfiler', {'depends': 'Shougo/unite.vim'}
if s:is_win && !has('win32unix')
  if executable('gcc')
    if has('win64')
      NeoBundle 'Shougo/vimproc', { 'build' : {
          \     'windows' : 'make -f make_mingw64.mak',
          \   } }
    else " if has('win32')
      NeoBundle 'Shougo/vimproc', { 'build' : {
          \     'windows' : 'make -f make_mingw32.mak',
          \   } }
    endif
  elseif has('win32') && executable('cl') && executable('make')
    NeoBundle 'Shougo/vimproc', { 'build' : {
        \     'windows' : 'make -f make_msvc32.mak',
        \   } }
  else
    NeoBundle 'Shougo/vimproc'
  endif
else
  NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac'    : 'make -f make_mac.mak',
      \     'unix'   : 'make -f make_gcc.mak',
      \   }
      \ }
endif
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/vinarise'
NeoBundle 'kana/vim-altr'
NeoBundle 'kana/vim-fakeclip'
NeoBundle 'kana/vim-smartchr'
NeoBundle 'kana/vim-submode'
NeoBundle 'tyru/vim-altercmd'
NeoBundle 'vim-scripts/ShowMarks7'
NeoBundle 'dannyob/quickfixstatus'
NeoBundle 'jceb/vim-hier'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-endwise'
NeoBundle 't9md/vim-surround_custom_mapping'
NeoBundle 't9md/vim-textmanip'
NeoBundle 'ujihisa/camelcasemotion'
NeoBundle 'h1mesuke/vim-alignta'
" NeoBundle 'vim-scripts/YankRing.vim'
" NeoBundle 'chrismetcalf/vim-yankring'
NeoBundle 'the-isz/MinYankRing.vim'
NeoBundleLazy 'kien/ctrlp.vim'
NeoBundle 'glidenote/memolist.vim'

NeoBundle 'othree/eregex.vim'
NeoBundle 'sjl/gundo.vim'
NeoBundle 'kana/vim-smartword'
" NeoBundle 'pekepeke/golden-ratio'
" NeoBundle 'scrooloose/nerdtree'
NeoBundle 'thinca/vim-qfreplace'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'c9s/cascading.vim'
NeoBundle 'mileszs/ack.vim'
NeoBundle 'vim-scripts/MultipleSearch'
NeoBundle 'vim-scripts/sudo.vim'
if s:is_mac
  NeoBundle 'gmarik/sudo-gui.vim'
endif

" web {{{3
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'mattn/webapi-vim'
if executable('python')
  NeoBundle 'mattn/mkdpreview-vim'
  let plugin_path = g:my_bundle_dir . "/mkdpreview-vim/static/mkdpreview.py"
  if !s:is_win && filereadable(plugin_path) && !executable(plugin_path)
    exe "!chmod u+x" plugin_path
  endif
  unlet plugin_path
endif
NeoBundle 'mattn/googletranslate-vim'
NeoBundle 'thinca/vim-ambicmd'
NeoBundle 'mattn/gist-vim'
" NeoBundle 'mattn/vimplenote-vim'
" NeoBundle 'pekepeke/vimplenote-vim'
if !has('gui') || has('python') || s:is_windows || s:is_mac
  NeoBundle 'tsukkee/lingr-vim'
else
  NeoBundleLazy 'tsukkee/lingr-vim'
endif

" gf-user {{{3
NeoBundle 'kana/vim-gf-user'
NeoBundle 'kana/vim-gf-diff'

" operator {{{3
NeoBundle 'kana/vim-operator-replace'
NeoBundle 'kana/vim-operator-user'
NeoBundle 'tyru/operator-camelize.vim'
NeoBundle 'tyru/operator-html-escape.vim'
NeoBundle 'pekepeke/vim-operator-shuffle'

" textobj {{{3
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'kana/vim-textobj-datetime'
NeoBundle 'kana/vim-textobj-diff'
NeoBundle 'kana/vim-textobj-entire'
NeoBundle 'kana/vim-textobj-fold'
NeoBundle 'kana/vim-textobj-function'
NeoBundle 'kana/vim-textobj-jabraces'
NeoBundle 'kana/vim-textobj-lastpat'
NeoBundle 'kana/vim-textobj-syntax'
NeoBundle 'kana/vim-textobj-line'
NeoBundle 'thinca/vim-textobj-between'
" NeoBundle 'thinca/vim-textobj-comment'
NeoBundle 'thinca/vim-textobj-function-javascript'
NeoBundle 'thinca/vim-textobj-function-perl'
NeoBundle 't9md/vim-textobj-function-ruby'
NeoBundle 'nelstrom/vim-textobj-rubyblock'
NeoBundle 'vim-scripts/textobj-indent'
NeoBundle 'sgur/vim-textobj-parameter'
NeoBundle 'h1mesuke/textobj-wiw'
NeoBundle 'coderifous/textobj-word-column.vim'

" metarw {{{3
" NeoBundle "mattn/vim-metarw.git"
" NeoBundle "mattn/vim-metarw-gist.git"
" NeoBundle "mattn/vim-metarw-git.git"
" NeoBundle "sorah/metarw-simplenote.vim.git"

" libs {{{3
NeoBundle 'vim-scripts/cecutil'

" afterexec for runtimepath {{{1
filetype plugin indent on

" etc settings {{{2
if filereadable(expand('~/.vimrc.personal'))
  execute 'source' expand('~/.vimrc.personal')
endif
if isdirectory(expand('~/.vim/bin/'))
  let $PATH.=(s:is_win ? ';' : ':').expand('~/.vim/bin/')
endif
" }}}

" color settings "{{{1
"set t_Co=256
set background=dark

function s:my_highlight_defines() "{{{2
  highlight NonText term=underline ctermfg=darkgray guifg=darkgray
  highlight SpecialKey term=underline ctermfg=darkgray guifg=darkgray
  " highlight link IdeographicSpace Error
  highlight IdeographicSpace term=underline ctermbg=darkgreen guibg=darkgreen
  " highlight link TrailingSpaces Error
  highlight TrailingSpaces ctermbg=darkgray guibg=#222222
  " highlight clear CursorLine
  "hi CursorLine gui=underline term=underline cterm=underline
  " highlight CursorLine ctermbg=black guibg=black
  highlight link VimShellError WarningMsg
  " highlight qf_error_ucurl term=underline ctermfg=red gui=undercurl guisp=red
endfunction

function s:my_additional_syntaxes() "{{{2
  syntax match IdeographicSpace containedin=ALL /　/
  syntax match TrailingSpaces containedin=ALL /\s\+$/
endfunction

augroup my-additional-colors "{{{2
  autocmd!
  autocmd ColorScheme * call <SID>my_highlight_defines()
  autocmd Syntax * call <SID>my_additional_syntaxes()
  autocmd Syntax eruby highlight link erubyRubyDelim Label
  autocmd VimEnter,WinEnter * call <SID>my_additional_syntaxes()
augroup END

if has('gui')
  augroup my-gui-colorscheme "{{{2
    autocmd!
    autocmd GUIEnter * colorscheme vividchalk
    if has('gui_macvim')
      " macvim .... -_-###
      autocmd GUIEnter * call <SID>my_highlight_defines()
    endif
  augroup END
elseif &t_Co == 256 || s:is_win "{{{2
  colorscheme vividchalk
else
  " colorscheme wombat
  colorscheme desert
endif

"" カーソル行 {{{2
" http://d.hatena.ne.jp/thinca/20090530/1243615055
augroup vimrc-auto-cursorline
  autocmd!
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
" MyAutocmd WinLeave * set nocursorline
" MyAutocmd WinEnter,BufRead * set cursorline


" defun macros {{{1
augroup MyAuGroup
  autocmd!
augroup END
command! -bang -nargs=* MyAutocmd autocmd<bang> MyAuGroup <args>
command! -nargs=* Lazy autocmd MyAuGroup VimEnter * <args>


" for filetypes {{{1
" shebang {{{2
if !s:is_win
  MyAutocmd BufWritePost *
        \ if getline(1) =~ "^#!"
        \ | exe "silent !chmod +x %"
        \ | endif
  MyAutocmd BufEnter *
        \ if bufname("") !~ "^\[A-Za-z0-9\]*://"
        \ | silent! exe '!echo -n "k%\\"'
        \ | endif
endif
" create directory automatically {{{2
augroup vimrc-auto-mkdir
    autocmd!
    autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
    function! s:auto_mkdir(dir, force)
        if !isdirectory(a:dir) && (a:force ||
            \ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
            call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
        endif
    endfunction
augroup END

" etc hacks {{{2
" http://vim-users.jp/2009/10/hack84/
MyAutocmd BufWritePost * if expand('%') != '' && &buftype !~ 'nofile' | mkview | endif
MyAutocmd BufRead * if expand('%') != '' && &buftype !~ 'nofile' | silent loadview | endif
set viewoptions=cursor

" http://vim-users.jp/2009/12/hack112/
MyAutocmd BufNewFile,BufReadPost * call s:vimrc_local(expand('<afile>:p:h'))
function! s:vimrc_local(loc)
  let files = findfile('vimrc_local.vim', escape(a:loc, ' '). ';', -1)
  for i in reverse(filter(files, 'filereadable(v:val)'))
    source `=i`
  endfor
endfunction

if has('vim_starting')
  call s:vimrc_local(getcwd())
endif

" setfiletype {{{2
" override default filetypedetect
augroup filetypedetect
  " html for E127 error
  autocmd! BufNewFile,BufRead *.html,*.htm,*.htm,*.shtml,*.stm
  autocmd BufNewFile,BufRead *.html,*.htm,*.htm,*.shtml,*.stm  call <SID>detect_ft_html()
  function! s:detect_ft_html() " {{{3
    let n = 1
    let lines = []
    while n < 10 && n < line("$")
      let a_line = getline(n)
      if a_line =~ '{%\|{{\|{#'
        set filetype=htmldjango
        return
      elseif a_line =~ '<?php\s\+'
        set filetype=php
        return
      endif
      call add(lines, a_line)
      let n = n + 1
    endwhile

    for a_line in lines
      if a_line =~ '\<DTD\s\+XHTML\s'
        set filetype=xhtml
        return
      endif
    endfor

    set filetype=html
  endfunction "}}}3
augroup END

" alias
MyAutocmd FileType js set filetype=javascript
" MySQL
MyAutocmd BufNewFile,BufRead *.sql set filetype=mysql
" IO
MyAutocmd BufNewFile,BufRead *.io set filetype=io
" MSBuild
MyAutocmd BufNewFile,BufRead *.proj,*.xaml set filetype=xml
MyAutocmd BufNewFile,BufRead *.proj,*.cs,*.xaml compiler msbuild
" command
MyAutocmd BufNewFile,BufRead *.command set filetype=sh

MyAutocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
      \ | exe "normal! g`\""
      \ | endif

" indent {{{2
MyAutocmd FileType coffee,ruby,scheme,sh,zsh,vim,yaml,xml,javascript
      \ setl tabstop=2 shiftwidth=2 textwidth=0 expandtab
MyAutocmd FileType html
      \ setl noexpandtab tabstop=2 shiftwidth=2 textwidth=0
" haskell
MyAutocmd FileType lisp,perl
      \ setl expandtab
MyAutocmd FileType objc,php,markdown
      \ setl noexpandtab
MyAutocmd FileType help
      \ setl noexpandtab tabstop=8 shiftwidth=8
MyAutocmd FileType python
      \ setl textwidth=80 tabstop=8 softtabstop=4 shiftwidth=4 expandtab

function! s:cmdwin_my_settings() "{{{3
  noremap <buffer> q :q<CR>
  noremap <buffer> <Esc> :q<CR>
  inoremap <buffer><expr> kk col('.') == 1 ? '<Esc>k' : 'kk'
  inoremap <buffer><expr> <BS> col('.') == 1 ? '<Esc>:quit<CR>' : '<BS>'
  startinsert!
endfunction " }}}
MyAutocmd CmdwinEnter * call s:cmdwin_my_settings()

" vim -b : edit binary using xxd-format! "{{{3
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | silent %!xxd -g 1
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | silent %!xxd -g 1
  au BufWritePost *.bin set nomod | endif
augroup END

" basic settings {{{1
" 文字コード周り {{{2
set encoding=utf-8
if s:is_win && (!has('win32unix') || !has('gui_running'))
  set termencoding=cp932
else
  set termencoding=utf-8
endif
set fileencoding=utf-8
set fileformat=unix
scriptencoding utf-8
set fileencodings=ucs-bom,utf-8,iso-2022-jp,euc-jp,cp932
set fileformats=unix,dos,mac

set display=lastline
set clipboard=unnamed
" if has('unnamedplus') set clipboard+=unnamedplus endif
" set mouse=a
set mouse=nv
set nomousefocus
set mousehide

set shellslash
set directory=~/.tmp,/var/tmp,/tmp

" IME の設定 {{{2
if has('kaoriya') | set iminsert=0 imsearch=0 | endif

MyAutocmd BufEnter * call LcdCurrentOrProjDir()
if !exists('g:my_lcd_autochdir')
  let g:my_lcd_autochdir = 1
endif

function! LcdCurrentOrProjDir() "{{{3
  if (&filetype == "vimfiler" || &filetype == "unite" || &filetype == "vimshell"
        \ || &filetype == "quickrun" )
    return
  elseif g:my_lcd_autochdir && !exists('b:my_lcd_current_or_prj_dir')
    let b:my_lcd_current_or_prj_dir = my#util#find_proj_dir()
    if b:my_lcd_current_or_prj_dir != '' && isdirectory(b:my_lcd_current_or_prj_dir)
      execute 'lcd' fnameescape(b:my_lcd_current_or_prj_dir)
    endif
  endif
endfunction

" diff {{{2
set diffopt& diffopt-=filler diffopt+=iwhite

" 表示周り {{{2
set lazyredraw
set ttyfast
set scrolloff=10000000         " 中央に表示
set sidescrolloff=999
set number                     " 行番号の表示
set ruler

set mouse=nch                  " use mouse normal/command/help
set timeoutlen=1000
set ttimeoutlen=50

set showmatch                  " 対応する括弧の表示
set showcmd                    " 入力中のコマンドを表示
set backspace=indent,eol,start " BSでなんでも削除
set nolinebreak
set textwidth=1000
set formatoptions& formatoptions+=mM
set whichwrap=b,s,h,l,<,>,[,]  " 行頭・行末間移動を可能に
if exists('&colorcolumn') | set colorcolumn=+1 | endif
set splitbelow                 " 横分割は下に
set splitright                 " 縦分割は右に
set switchbuf=useopen          " 再利用
set background=dark
set title

set hidden                     " 編集中でも他のファイルを開けるように
set sidescroll=5
set viminfo& viminfo+=!
set visualbell
set noerrorbells

set guioptions& guioptions-=mT
let did_install_default_menus = 1
let did_install_syntax_menu = 1
set noequalalways
set langmenu=none
set helplang=ja,en
set foldmethod=marker
" http://d.hatena.ne.jp/thinca/20110523/1306080318
augroup foldmethod-expr
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
set listchars=tab:^\ ,trail:~,nbsp:%,extends:>,precedes:<
set smarttab             " インテリジェンスなタブ入力
set expandtab
"set softtabstop=4 tabstop=4 shiftwidth=4
set softtabstop=0 tabstop=4 shiftwidth=4

if exists('&ambiwidth')
  set ambiwidth=double
endif " }}}

"set wm=2
set nowrap     " 折り返しなし
set nrformats=hex
set updatetime=1000

" sticky shift {{{2
" http://vim-users.jp/2009/08/hack-54/
let g:sticky_shift_enable = 0
command! -nargs=0 StickyShift let g:sticky_shift_enable=1
command! -nargs=0 NoStickyShift let g:sticky_shift_enable=0

inoremap <expr> ;  g:sticky_shift_enable ? <SID>sticky_func() : ";"

function! s:sticky_func() "{{{3
  " let l:sticky_table = {
  " \',' : '<', '.' : '>', '/' : '?',
  " \'1' : '!', '2' : '@', '3' : '#', '4' : '$', '5' : '%',
  " \'6' : '^', '7' : '&', '8' : '*', '9' : '(', '0' : ')', '-' : '_', '=' : '+',
  " \';' : ':', '[' : '{', ']' : '}', '`' : '~', "'" : "\"", '\' : '|',
  " \}
  "'\' : '|',
  let l:sticky_table = {
        \',' : '<', '.' : '>', '/' : '?', '\' : '_', 
        \'1' : '!', '2' : '"', '3' : '#', '4' : '$', '5' : '%',
        \'6' : '&', '7' : "'", '8' : '(', '9' : ')', '0' : '|', '-' : '=', '^' : '~',
        \'@' : '`', '[' : '{', ';' : '+', ':' : '*', ']' : '}'
        \}
  let l:special_table = {
        \"\<ESC>" : "\<ESC>", "\<Space>" : ';', "\<CR>" : ";\<CR>"
        \}

  let l:key = getchar()
  if nr2char(l:key) =~ '\l'
    return toupper(nr2char(l:key))
  elseif has_key(l:sticky_table, nr2char(l:key))
    return l:sticky_table[nr2char(l:key)]
  elseif has_key(l:special_table, nr2char(l:key))
    return l:special_table[nr2char(l:key)]
  else
    return ''
  endif
endfunction

" statusline {{{2
set laststatus=2  " ステータス表示用変数
"set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']['.&ft.']'}%=%l,%c%V%8P
let &statusline="%<%f %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']['.&ft.']'
      \ }%=%l,%c%V%8P"
      " \ .'['.cfi#format('%s()','no func').']'

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
set backupdir=$HOME/.tmp/vim-backups
set viewdir=$HOME/.tmp/vim-views
set backupcopy=yes
set backupskip=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*.tmp,crontab.*
if has('persistent_undo')
    set undodir=~/.vimundo
    set undofile
endif
call my#util#mkdir(&backupdir)
call my#util#mkdir(&viewdir)


" 補完 {{{2
set wildmenu                                 " 補完候補を表示する
set wildmode=list:longest,list:full          " zsh like complete
set wildchar=<tab>
set wildignore+=*.o,*.obj,.git,*.rbc,.class,.svn
" set completeopt=menu,preview,longest,menuone
" set complete=.,w,b,u,t,i,k                   " 補完候補の設定
" set completeopt=menuone,preview
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

" alias commands {{{1
" basic {{{2
command! -nargs=0 -bang MyQ
      \ if tabpagenr('$') == 1 && winnr('$') == 1 | enew
      \ | else | quit<bang> | endif

command! -nargs=0 -bang MyWQ write<bang> | MyQ<bang>

function! s:toggle_option(opt)
  exe "setl inv".a:opt
  let sts = eval('&'.a:opt)
  echo printf("set %s : %s", a:opt, sts ? "ON" : "OFF")
endfunction

function! s:initialize_global_dict(prefix, names)
  if type(a:prefix) == type([])
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

function! s:bulk_dict_variables(defines)
  for var in a:defines
    for name in var.names
      let var.dict[name] = var.value
    endfor
  endfor
endfunction

" textobj {{{2
function! s:map_textobj(key, cmd)
  silent exe 'omap' a:key a:cmd
  silent exe 'vmap' a:key a:cmd
endfunction

command! -nargs=+ Tmap call s:map_textobj(<f-args>)

" altercmd "{{{2
if neobundle#is_installed('vim-altercmd')
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
noremap [space] <Nop>
nnoremap g<Space> <Space>
vnoremap g<Space> <Space>
nmap <Space> [space]
vmap <Space> [space]

noremap [t] <Nop>
nmap t [t]
nnoremap <silent> [t]e t

noremap [s] <Nop>
nmap s [s]

nnoremap [prefix] <Nop>
vnoremap [prefix] <Nop>
nmap , [prefix]
vmap , [prefix]
" nnoremap [prefix], ,
" vnoremap [prefix], ,

noremap [edit] <Nop>
nmap <C-e> [edit]
vmap <C-e> [edit]

noremap [comment-doc] <Nop>
map     [prefix]c     [comment-doc]

nnoremap q <Nop>
nnoremap Q q

" 行単位で移動 {{{2
nnoremap j gj
nnoremap k gk
" nmap gb :ls<CR>:buf

" disable danger keymaps {{{2
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
if $TERM =~ 'screen'
  map <C-z> <Nop>
endif

" useful keybinds {{{2
nnoremap gs :<C-u>setf<Space>
nnoremap <C-h> :<C-u>help<Space>
nmap Y y$

" S をつぶしてみる
noremap [SW] <Nop>
nmap S [SW]

nnoremap <silent> [SW]s S
nnoremap <silent> [SW]S "_dd
nnoremap <silent> [SW]d "_d
nnoremap <silent> [SW]D "_D

nnoremap <silent> x "_x
nnoremap <silent> X "_X
" x はたまに使う
nnoremap <silent> [s]x x
nnoremap <silent> [s]X X

" http://vim-users.jp/2009/10/hack91/
cnoremap <expr> /  getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ?  getcmdtype() == '?' ? '\?' : '?'

" indent whole buffer
nnoremap [space]= call my#ui#indent_whole_buffer()

" insert timestamp
nmap <silent> [t]w :exe "normal! i" . strftime("%Y-%m-%d\T%H:%M:%S+09:00")<CR>

" redraw map
nmap <silent> [s]r :redraw!<CR>

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

function! s:show_mapping()
  let key = getchar()
  let c = nr2char(key)
  let s = strtrans(c)
  if stridx(s, "^") == 0
    let c = "<C-".substitute(s, '^\^', "", "").">"
  endif
  if strlen(c) > 0
    exe 'map' c
  endif
endfunction

nnoremap <silent> [space]hk :<C-u>call <SID>show_mapping()<CR>
nnoremap [space]/ :<C-u>nohlsearch<CR>
nnoremap [space]w :<C-u>call <SID>toggle_option("wrap")<CR>

" replace & grep {{{2
nnoremap [space]r :<C-u>%S/
vnoremap [space]r :S/

" grep
if executable('ack')
  set grepprg=ack\ -a\ --nocolor\ --nogroup\ --nopager
  set grepformat=%f:%l:%m
elseif executable('ack-grep')
  set grepprg=ack-grep\ -a\ --nocolor\ --nogroup\ --nopager
  set grepformat=%f:%l:%m
  let g:ackprg="ack-grep -H --nocolor --nogroup --column --nopager"
else
  set grepprg=grep\ -n\ $*\ /dev/null
  "set grepprg=grep\ -n\ $*\ /dev/null\ --exclude\ \"\*\.svn\*\"
  let Grep_Skip_Dirs = 'RCS CVS SCCS .svn .git .hg BIN bin LIB lib Debug debug Release release'
  let Grep_Skip_Files = '*~ *.bak *.v *.o *.d *.deps tags TAGS *.rej *.orig'
  let Grep_Default_Filelist = '*' "join(split('* '.Grep_Skip_Files, ' '), ' --exclude=')
endif
command! TodosBuffer silent exe 'GrepBuffer TODO' | silent exe 'GrepBufferAdd FIXME' | silent exe 'GrepBufferAdd XXX'

let Grep_Default_Options = '-i'
let Grep_OpenQuickfixWindow = 1

let MyGrep_ExcludeReg = '[~#]$\|\.bak$\|\.o$\|\.obj$\|\.exe$\|\.dll$\|\.pdf$\|\.doc$\|\.xls$\|[/\\]tags$\|^tags$'
let MyGrepcmd_useropt = '--exclude="*\.\(svn\|git\|hg)*"'

" mygrep.vim…
"nmap [space]gg :EGrep<CR>
"nmap [space]gr :RGrep<CR>
" nnoremap [space]gg :Grep<CR>
" nnoremap [space]gr :REGrep<CR>
nnoremap [space]g  :Ack<Space>-i<Space>''<Left>
nnoremap [space]gg :Ack<Space>-i<Space>''<Left>


function! s:my_quickfix_settings()
  " nnoremap <buffer> < :<C-u><CR>
endfunction

" quickfix のエラー箇所を波線でハイライト
" let g:hier_highlight_group_qf  = "qf_error_ucurl"
function! s:my_make_settings()
  HierUpdate
  QuickfixStatusEnable
endfunction

MyAutocmd FileType qf call s:my_quickfix_settings()
MyAutocmd QuickfixCmdPost make call s:my_make_settings()
" MyAutocmd QuickfixCmdPost make,grep,grepadd,vimgrep copen
" MyAutocmd QuickfixCmdPost l* lopen


" tags-and-searches {{{2
nnoremap [t]r t
nnoremap <silent> [t]t <C-]>
nnoremap <silent> [t]j :<C-u>tag<CR>
nnoremap <silent> [t]k :<C-u>pop<CR>
nnoremap <silent> [t]l :<C-u>tags<CR>

" nmaps {{{2
autocmd FileType help,ref,git-status,git-log nnoremap <buffer> q <C-w>c
" win move
nnoremap [space]. :source ~/.vimrc<CR>

"nnoremap [edit]<C-o> :copen<CR><C-w><C-w>
nnoremap [space]q :<C-u>call <SID>toggle_quickfix_window()<CR>
function! s:toggle_quickfix_window() "{{{3
  let n = winnr('$')
  cclose
  if n == winnr('$')
    copen
  endif
endfunction "}}}

" nnoremap [space]f :NERDTreeToggle<CR>

nnoremap / :<C-u>nohlsearch<CR>/
nnoremap ? :<C-u>nohlsearch<CR>?

nnoremap <C-w><Space> <C-w>p

nnoremap [prefix]ds :call <SID>replace_at_caret_data_scheme()<CR>
function! s:replace_at_caret_data_scheme() " {{{3
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
    let errmsg = "vm not found : ruby|php"
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

if 0 " {{{3 http://vim-users.jp/2011/04/hack213/
  let g:scrolloff = &scrolloff
  set scrolloff=0
  " Hack for <LeftMouse> not to adjust ('scrolloff') when single-clicking.
  " Implement 'scrolloff' by auto-command to control the fire.
  MyAutocmd CursorMoved * call s:reinventing_scrolloff()
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
else " {{{3 altanative
  augroup vimfiler-mouse
    autocmd!

    let s:org_scrolloff=-1
    function! s:noscrolloff_leftmouse()
      if s:org_scrolloff < 0
        let s:org_scrolloff = &scrolloff
      endif
      let &scrolloff = 0
      exe 'normal!' "\<LeftMouse>"
      " let &scrolloff = org_scrolloff
      autocmd CursorMoved * call s:restore_noscrolloff()
    endfunction
    function! s:restore_noscrolloff()
      autocmd!
      if s:org_scrolloff < 0
        return
      endif
      let &scrolloff = s:org_scrolloff
      let s:org_scrolloff = -1
    endfunction
    " autocmd CursorMoved * call s:restore_noscrolloff()
    nnoremap <silent> <LeftMouse>       <Esc>:set eventignore=all<CR>:call <SID>noscrolloff_leftmouse()<CR>:set eventignore=<CR>
    nnoremap          <2-LeftMouse>     g*
  augroup END
endif "}}}
" vmap              <LeftMouse> <Plug>(visualstar-g*)

" imaps {{{2
inoremap <C-t> <C-v><Tab>

inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <C-d> <Delete>

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

" cmaps {{{2
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-d> <Delete>
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

Lazy cnoremap <C-x> <C-r>=expand('%:p:h')<CR>/

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

" vmaps {{{2
vnoremap tj    :GoogleTranslate ja<CR>
vnoremap te    :GoogleTranslate en<CR>
vnoremap <Tab>   >gv
vnoremap <S-Tab> <gv
"nnoremap : q:

" mouse {{{2
if s:is_mac
  nnoremap <MiddleMouse> <Nop>
  inoremap <MiddleMouse> <Nop>
  vnoremap <MiddleMouse> <Nop>
endif

" plugin settings {{{1
" dirdiff.vim {{{2
let g:DirDiffExcludes = "CVS,*.class,*.exe,.*.swp,*.log,.git,.svn,.hg"
let g:DirDiffIgnore = "Id:,Revision:,Date:"
map ;dg <Plug>DirDiffGet
map ;dp <Plug>DirDiffPut
map ;dj <Plug>DirDiffNext
map ;dk <Plug>DirDiffPrev

" splitjoin.vim {{{2
nmap [prefix],j :<C-u>SplitjoinJoin<CR>
nmap [prefix],k :<C-u>SplitjoinSplit<CR>

" rainbow_parentheses {{{2
MyAutocmd VimEnter * RainbowParenthesesToggleAll

" vim-smartinput {{{2
function! s:sminput_define_rules()
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
endfunction
if neobundle#is_installed('vim-smartinput')
  command! SmartinputOff call smartinput#clear_rules()
  command! SmartinputOn call <SID>sminput_define_rules()
  call s:sminput_define_rules()
  " clear auto cmaps(for altercmd.vim)
  cunmap <CR>
endif

" golden-ratio {{{2
" let g:golden_ratio_ignore_ftypes=['unite', 'vimfiler']
", 'quickrun']
" nmap [space]s <Plug>(golden_ratio_toggle)

" ambicmd {{{2
cnoremap <expr> <C-l> ambicmd#expand("\<Space>")
" cnoremap <expr> <Space> ambicmd#expand("\<Space>")
" cnoremap <expr> <CR> ambicmd#expand("\<CR>")

" camelcasemotion {{{2
nmap <silent> [prefix]w <Plug>CamelCaseMotion_w
nmap <silent> [prefix]e <Plug>CamelCaseMotion_e
nmap <silent> [prefix]b <Plug>CamelCaseMotion_b
vmap <silent> [prefix]w <Plug>CamelCaseMotion_w
vmap <silent> [prefix]e <Plug>CamelCaseMotion_e
vmap <silent> [prefix]b <Plug>CamelCaseMotion_b

omap <silent> i,w <Plug>CamelCaseMotion_iw
xmap <silent> i,w <Plug>CamelCaseMotion_iw
omap <silent> i,b <Plug>CamelCaseMotion_ib
xmap <silent> i,b <Plug>CamelCaseMotion_ib
omap <silent> i,e <Plug>CamelCaseMotion_ie
xmap <silent> i,e <Plug>CamelCaseMotion_ie

" indent-guides {{{2
let g:indent_guides_enable_on_vim_startup = 1
if has('gui')
  let g:indent_guides_auto_colors = 1
else
  let g:indent_guides_auto_colors = 0
  augroup indentguides
    autocmd!
    autocmd VimEnter,Colorscheme * :highlight IndentGuidesEven ctermbg=236 ctermfg=white
    autocmd VimEnter,Colorscheme * :highlight IndentGuidesOdd ctermbg=235 ctermfg=white
  augroup END
endif

" smartword {{{2
if neobundle#is_installed('vim-smartword')
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
if neobundle#is_installed('vim-altr')
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

  nmap [space]j <Plug>(altr-forward)
  nmap [space]k <Plug>(altr-back)
endif

" vim-template "{{{2
let g:template_basedir = expand('$HOME/.vim')
let g:template_files = 'template/**'
let g:template_free_pattern = 'template'

call my#util#vars(['g:email', 'g:author', 'g:homepage_url'], '')

"autocmd BufNewFile * execute 'TemplateLoad'
MyAutocmd User plugin-template-loaded call s:template_keywords()

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

" sonictemplate-vim {{{2
let g:sonictemplate_vim_template_dir = expand('$HOME/.vim/sonictemplate/')

" http://vim-users.jp/2010/11/hack181/
" Open junk file. {{{3
function! s:open_junk_file()
  let l:junk_dir = $HOME . '/.vim_junk'. strftime('/%Y/%m')
  if !isdirectory(l:junk_dir)
    call mkdir(l:junk_dir, 'p')
  endif

  let l:filename = input('Junk Code: ', l:junk_dir.strftime('/%Y-%m-%d-%H%M%S.'))
  if l:filename != ''
    execute 'edit ' . l:filename
  endif
endfunction "}}}

command! -nargs=0 JunkFile call s:open_junk_file()
command! -nargs=0 EnewNofile enew | setl buftype=nofile

nnoremap [prefix]ss :<C-u>JunkFile<CR>
nmap [prefix]se :<C-u>EnewNofile<CR>

" alignta {{{2
let g:alignta_confirm_for_retab = 0
" let g:Align_xstrlen=3
" vmap [prefix]a :Align
vnoremap [prefix]a :Alignta
vnoremap [prefix],a :Alignta<< [:=><\-)}\]]\+
vnoremap [prefix],r :Alignta<< [=><\-)}\]]\+
vnoremap [prefix],t :Alignta \|<CR>
vnoremap [prefix],c :Alignta<< \(//\|#\|\/\*\)/1<CR>

" repeat.vim {{{2
silent! repeat#set() " for loading

" submode {{{2
" http://d.hatena.ne.jp/tyru/20100502/vim_mappings
if neobundle#is_installed('vim-submode')
  " Change current window size {{{3
  call submode#enter_with('winsize', 'n', '', '[s]w', '<Nop>')
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
  call submode#enter_with('tabwalker', 'n', '', '[s]t', '<Nop>')
  call submode#enter_with('tabwalker', 'n', '', '[s]e', '<Nop>')
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
  call submode#enter_with('winmove', 'n', '', '[s]j', '<C-w>j')
  call submode#enter_with('winmove', 'n', '', '[s]k', '<C-w>k')
  call submode#enter_with('winmove', 'n', '', '[s]h', '<C-w>h')
  call submode#enter_with('winmove', 'n', '', '[s]l', '<C-w>l')
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
  call submode#enter_with('quickfix', 'n', '', '[s]q', '<Nop>')
  call submode#leave_with('quickfix', 'n', '', '<Esc>')
  call submode#map       ('quickfix', 'n', '', 'j', ':cn<CR>')
  call submode#map       ('quickfix', 'n', '', 'k', ':cp<CR>')
  call submode#map       ('quickfix', 'n', '', 'n', ':cn<CR>')
  call submode#map       ('quickfix', 'n', '', 'p', ':cp<CR>')
  call submode#map       ('quickfix', 'n', '', 'c', ':cclose<CR>')
  call submode#map       ('quickfix', 'n', '', 'o', ':copen<CR>')
  call submode#map       ('quickfix', 'n', '', 'w', ':cwindow<CR>')
endif

" open-browser.vim {{{2
nmap [space]u <Plug>(openbrowser-open)
vmap [space]u <Plug>(openbrowser-open)

" netrw {{{2
let g:netrw_home = expand("$HOME/.tmp/")

" yankring {{{2
let g:yankring_history_dir = "$HOME/.tmp"

" rails.vim {{{2
let g:rails_some_option = 1
let g:rails_level = 4
let g:rails_syntax = 1
let g:rails_statusline = 1
let g:rails_url='http://localhost:3000'
let g:rails_subversion=0
let g:rails_default_file='config/database.yml'

" pydiction {{{2
let g:pydiction_location = '~/.vim/dict/pydiction-complete-dict'

" html5.vim {{{2
let g:event_handler_attributes_complete = 1
let g:rdfa_attributes_complete = 1
let g:microdata_attributes_complete = 1
let g:aria_attributes_complete = 1

" sudo.vim {{{2
if s:is_mac && has('gui') && neobundle#is_installed('sudo-gui.vim')
  command! -bang SW SudoWriteMacGUI
else
  command! SW w sudo:%
endif

" hatena.vim {{{2
let g:hatena_base_dir = $HOME . '/.tmp/vim-hatena/'
call my#util#mkdir(g:hatena_base_dir.'/cookies')

" dbext.vim {{{2
let g:dbext_default_prompt_for_parameters=0
let g:dbext_default_history_file = expand('~/.tmp/dbext_sql_history.txt')

" zen-coding.vim {{{2
let g:user_zen_leader_key='<C-y>'

" endtagcomment https://gist.github.com/411828 {{{2
nmap [prefix]/ <Plug>(endtagcomment)

" smartchr "{{{2
if neobundle#is_installed('vim-smartchr')
  inoremap <expr>, smartchr#one_of(', ', ',')
endif

" MyAutocmd FileType
"       \ c,cpp,javascript,ruby,python,java,perl,php
"       \ call s:smartchr_my_settings()

function! s:smartchr_my_settings() "{{{3
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
if neobundle#is_installed('unite.vim')
  nnoremap [unite] <Nop>
  nmap     f       [unite]
  nnoremap [unite]f f
endif

" unite basic settings {{{3
let g:unite_source_history_yank_enable=1
"let g:unite_enable_start_insert=1
let g:unite_enable_start_insert=0
let g:unite_source_file_mru_limit=200
let g:unite_source_file_mru_time_format = ''
"let g:unite_source_file_mru_time_format = '%Y-%m-%d %H:%M:%S'
let g:unite_winheight = 20
"let g:unite_split_rule = 'botright'
let g:unite_source_file_ignore_pattern = '\%(^\|/\)\.$\|\~$\|\.\%(o|exe|dll|bak|sw[po]\)$\|/chalice_cache/\|/-Tmp-/'

" unite buffers {{{3
if neobundle#is_installed('unite.vim')
  call unite#set_substitute_pattern('file', '\$\w\+', '\=eval(submatch(0))', 200)

  call unite#set_substitute_pattern('file', '[^~.]\zs/', '*/*', 20)
  call unite#set_substitute_pattern('file', '/\ze[^*]', '/*', 10)

  call unite#set_substitute_pattern('file', '^@@', '\=fnamemodify(expand("#"), ":p:h")."/*"', 2)
  call unite#set_substitute_pattern('file', '^@', '\=getcwd()."/*"', 1)
  call unite#set_substitute_pattern('file', '^\\', '~/*')
  call unite#set_substitute_pattern('file', '^\~', escape($HOME, '\'), -2)

  call unite#set_substitute_pattern('file', '^;v', '~/.vim/*')
  call unite#set_substitute_pattern('file', '^;ft', '~/.vim/after/ftplugin/')
  call unite#set_substitute_pattern('file', '^;r', '\=$VIMRUNTIME."/*"')
  if s:is_win
    call unite#set_substitute_pattern('file', '^;p', 'C:/Program Files/*')
    if isdirectory(expand('$USERPROFILE/Desktop'))
      call unite#set_substitute_pattern('file', '^;d', '\=expand("$USERPROFILE/Desktop/")."*"')
    else
      call unite#set_substitute_pattern('file', '^;d', '\=expand("$USERPROFILE/デスクトップ/")."*"')
    endif
  else
    call unite#set_substitute_pattern('file', '^;d', '\=$HOME."/Desktop/*"')
  endif
endif

" unite-grep {{{3
" let g:unite_source_grep_default_opts = '-iRHn'
let g:unite_source_grep_command = 'ack-grep'
let g:unite_source_grep_default_opts = '--no-heading --no-color -a --nogroup --nopager'
let g:unite_source_grep_recursive_opt = ''

" unite-grep_launcher {{{3
if !exists('g:grep_launcher_words')
  let g:grep_launcher_words = {}
endif
call extend(g:grep_launcher_words, {
      \ 'TODO' : 'TODO\|FIXME\|XXX',
      \ })

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
  let fmt = "%snoremap <silent> [unite]%s :<C-u>Unite %s %s<CR>"

  exe printf(fmt, a:prefix, key, "", cmdargs)
  exe printf(fmt, a:prefix, bang_key, "-no-quit", cmdargs)
endfunction " }}}
command! -nargs=* -bang UniteNMap call s:unite_map("<bang>", "n", <f-args>)

nmap [unite]u  :<C-u>Unite<Space>

UniteNMap   s         source
UniteNMap   <Space>   buffer
UniteNMap   j         buffer_tab
UniteNMap   k         tab
UniteNMap   l         file
UniteNMap   m         file_mru directory_mru -default-action=open -buffer-name=file
UniteNMap   t         sonictemplate
UniteNMap   c         webcolorname
UniteNMap   o         tag outline
UniteNMap!  gg        grep:<C-r>=getcwd()<CR> -buffer-name=grep
UniteNMap!  gr        grep -buffer-name=grep
UniteNMap!  gt        grep:<C-r>=getcwd()<CR>::TODO\|FIXME\|XXX -buffer-name=todo
UniteNMap   gl        grep_launcher
UniteNMap!  gi        git_grep -buffer-name=git_grep
UniteNMap!  q         quickfix -buffer-name=qfix
UniteNMap   y         history/yank
UniteNMap   :         history/command command
UniteNMap   /         history/search
UniteNMap   ?         mapping
UniteNMap   bb        bookmark -default-action=open
nnoremap <silent> [unite]ba :<C-u>UniteBookmarkAdd<CR>
" UniteNMap   rr        quicklearn -immediately
nnoremap <Space>R :<C-u>Unite quicklearn -immediately<CR>


" if my#util#has_plugin('vimproc')
" if neobundle#is_installed('vimproc')
"   UniteNMap a file_rec/async -start-insert
" else
UniteNMap a file_rec -start-insert
" endif

" nnoremap <silent> [unite]h  :<C-u>UniteWithCursorWord help:ja help<CR>
nnoremap <silent> [unite]h :<C-u>call <SID>smart_unite_ref_launch()<CR>

function! s:smart_unite_ref_launch() " {{{4
  let ft = &ft
  let names = []

  let isk = &l:isk
  setlocal isk& isk+=- isk+=. isk+=:
  let kwd = expand('<cword>')
  let &l:isk = isk

  " let tilang = ['timobileref', 'tidesktopref']
  " if ft == 'php'
  "   let names = ['phpmanual'] + tilang
  " elseif ft == 'ruby'
  "   let names = ['refe'] + tilang
  " elseif ft == 'python'
  "   let names = ['pydoc'] + tilang
  " elseif ft == 'perl'
  "   let names = ['perldoc']
  " elseif ft == 'javascript'
  "   let names = ['jsref'] + tilang
  " elseif ft == 'java'
  "   let names = ['javadoc', 'androiddoc']
  " elseif ft == 'erlang'
  "   let names = ['erlang']
  " endif
  " let ref_names = ref#available_source_names()
  " execute 'Unite'
  "       \ '-input='.kwd
  "       \ join(map(filter(names, 'index(ref_names, v:val)') + ['man'],
  "       \ '"ref/".v:val'), ' ')
  let s = ref#detect()
  if s == ""
    let s = "man"
  endif
  execute 'Unite' '-input='.kwd 'ref/'.s
endfunction "}}}

nnoremap          [unite]rr :<C-u>UniteResume<Space>
nnoremap <silent> [unite]re :<C-u>UniteResume<CR>
nnoremap <silent> [unite]ri :<C-u>UniteResume git<CR>
nnoremap <silent> [unite]rg :<C-u>UniteResume grep<CR>
nnoremap <silent> [unite]rt :<C-u>UniteResume todo<CR>
nnoremap <silent> [unite]rq :<C-u>UniteResume qfix<CR>

inoremap <C-x><C-j> <C-o>:Unite neocomplcache -buffer-name=noocompl -start-insert<CR>

command! Todos silent! exe 'Unite' printf("grep:%s::TODO\\|FIXME\\|XXX", getcwd()) '-buffer-name=todo' '-no-quit'

" cmd-t {{{3
function! s:get_cmd_t_key(key)
  return printf("<%s-%s>", has('gui_macvim') ? "D" : "A", a:key)
endfunction
function! s:unite_project(...)
  let opts = (a:0 ? join(a:000, ' ') : '')
  let dir = unite#util#path2project_directory(expand('%'))
  execute 'Unite' opts 'file_rec:' . dir
endfunction
" if neobundle#is_installed('vimproc')
"   execute 'nnoremap' '<silent>' s:get_cmd_t_key("t") ':<C-u>Unite file_rec/async -start-insert<CR>'
" else
" execute 'nnoremap' '<silent>' s:get_cmd_t_key("t") ':<C-u>Unite file_rec -start-insert<CR>'
execute 'nnoremap' '<silent>' s:get_cmd_t_key("t") ":<C-u>call <SID>unite_project('-start-insert')<CR>"
" endif
execute 'nnoremap' '<silent>' s:get_cmd_t_key("r") ':<C-u>Unite outline -start-insert<CR>'

MyAutocmd FileType unite call s:unite_my_settings() "{{{3
function! s:unite_my_settings()
  imap <buffer> jj <Plug>(unite_insert_leave)j
  imap <buffer> qq <Plug>(unite_exit)
  imap <buffer> ]] <C-o><Plug>(unite_rotate_next_source)
  imap <buffer> [[ <C-o><Plug>(unite_rotate_previous_source)
  imap <buffer> <ESC> <ESC><ESC>

  nnoremap <silent><buffer><expr> <C-j> unite#do_action('split')
  inoremap <silent><buffer><expr> <C-j> unite#do_action('split')
  nmap <buffer> t <Plug>(unite_choose_action)
  nmap <buffer> l <Plug>(unite_do_default_action)
endfunction

" git-vim {{{2
" let g:git_no_map_default = 1
" let g:git_command_edit = 'rightbelow vnew'
" nnoremap [space]gd :<C-u>GitDiff --cached<Enter>
" nnoremap [space]gD :<C-u>GitDiff<Enter>
" nnoremap [space]gs :<C-u>GitStatus<Enter>
" nnoremap [space]gl :<C-u>GitLog<Enter>
" nnoremap [space]gL :<C-u>GitLog -u \| head -10000<Enter>
" nnoremap [space]ga :<C-u>GitAdd<Enter>
" nnoremap [space]gA :<C-u>GitAdd <cfile><Enter>
" nnoremap [space]gc :<C-u>GitCommit<Enter>
" nnoremap [space]gC :<C-u>GitCommit --amend<Enter>
" nnoremap [space]gp :<C-u>Git push

" fugitive.vim {{{2
nnoremap [space]gd :<C-u>Gdiff --cached<CR>
nnoremap [space]gD :<C-u>Gdiff<CR>
nnoremap [space]gs :<C-u>Gstatus<CR>
nnoremap [space]gl :<C-u>Glog<CR>
nnoremap [space]gL :<C-u>Glog -u \| head -10000<CR>
nnoremap [space]ga :<C-u>Gwrite<CR>
nnoremap [space]gA :<C-u>Gwrite <cfile><CR>
nnoremap [space]gc :<C-u>Gcommit<CR>
nnoremap [space]gC :<C-u>Gcommit --amend<CR>
nnoremap [space]gr :<C-u>Ggrep<Space>
nnoremap [space]gb :<C-u>Gblame<CR>
nnoremap [space]gp :<C-u>Git push

" TOhtml {{{2
let g:html_number_lines = 0
let g:html_use_css = 1
let g:use_xhtml = 1
let g:html_use_encoding = 'utf-8'

" tagbar taglist {{{2
" basic options {{{3
set tags+=tags;$HOME
if filereadable($HOME."/.bin/tags/java6") | set tags+=$HOME/.bin/tags/java6 | endif
if filereadable($HOME."/.bin/tags/android-base") | set tags+=$HOME/.bin/tags/android-base | endif

if 0 "{{{4
  let g:Tlist_Auto_Update = 1
  let g:Tlist_Show_One_File = 0
  let g:Tlist_Exit_OnlyWindow = 1
  let g:Tlist_Use_Right_Window = 0
  let g:Tlist_WinWidth = 25

  let g:tlist_objc_settings='objc;P:protocols;i:interfaces;I:implementations;M:instance methods;C:implementation methods;Z:protocol methods;v:property'
  let g:tlist_javascript_settings='javascript;v:var;c:class;p:prototype;m:method;f:function;o:object'
  let g:tlist_scala_settings = 'scala;t:trait;c:class;T:type;m:method;C:constant;l:local;p:package;o:object'
  let g:tlist_actionscript_settings = 'actionscript;c:class;f:method;p:property;v:variable'
  let g:tlist_tex_settings   = 'latex;s:sections;g:graphics;l:labels'
else "{{{4
  if executable('coffeetags')
    let g:tagbar_type_coffee = {
          \ 'ctagsbin' : 'coffeetags',
          \ 'ctagsargs' : '',
          \ 'kinds' : [
          \ 'f:functions',
          \ 'o:object',
          \ ],
          \ 'sro' : ".",
          \ 'kind2scope' : {
          \ 'f' : 'object',
          \ 'o' : 'object',
          \ }
          \ }
  endif
  let g:tagbar_type_scala = {
      \ 'ctagstype' : 'Scala',
      \ 'kinds'     : [
          \ 'p:packages:1',
          \ 'V:values',
          \ 'v:variables',
          \ 'T:types',
          \ 't:traits',
          \ 'o:objects',
          \ 'a:aclasses',
          \ 'c:classes',
          \ 'r:cclasses',
          \ 'm:methods'
      \ ]
  \ }
endif "}}}

if s:is_mac && executable('/Applications/MacVim.app/Contents/MacOS/ctags')
  " let g:Tlist_Ctags_Cmd='/Applications/MacVim.app/Contents/MacOS/ctags'
  let g:tagbar_ctags_bin='/Applications/MacVim.app/Contents/MacOS/ctags'
endif
" }}}3
nnoremap <silent> [prefix]tt :<C-u>TagbarToggle<CR>1<C-w>h
nnoremap <silent> [space]t   :<C-u>TagbarToggle<CR>
nnoremap <silent> [prefix]tr :<C-u>TagbarOpen<CR>
nnoremap          [prefix]tc :Ctags<CR>
command! -nargs=? Ctags call s:exec_ctags(<q-args>)

function! s:exec_ctags(path) "{{{3
  let path = a:path
  let ctags_cmd = "ctags -R"
  if empty(path)
    let path = input("input base dir : ", expand('%:p:h'))
  endif
  if empty(path)
    return
  endif
  let cwd = getcwd()
  if !empty(a:path) && isdirectory(a:path)
    exe 'lcd' a:path
  endif
  if neobundle#is_installed('vimproc')
    call vimproc#system_bg(ctags_cmd)
  else
    execute "!" ctags_cmd
    NeoComplCacheCachingTags
  endif
  if !empty(a:path) && isdirectory(a:path)
    exe 'lcd' cwd
  endif
endfunction

" surround.vim {{{2
nmap [s]s <Plug>Ysurround

let g:surround_custom_mapping = {}
let g:surround_custom_mapping._ = {
      \ 'g':  "_('\r')",
      \ 'G':  "_(\"\r\")",
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
      \ }
let g:surround_custom_mapping.php = {
      \ '-':  "<?php \r ?>", 
      \ '=':  "<?php echo $\r; ?>", 
      \ 'h':  "<?php echo h( $\r ); ?>", 
      \ 'e':  "<?php echo $\r; ?>", 
      \ 'f':  "<?php foreach ($\r as $val): ?>\n<?php endforeach; ?>", 
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
if neobundle#is_installed('vim-operator-user')
  call operator#user#define('excelize', 'OperatorExcelize')
  function! OperatorExcelize(motion_wise)
    let b = line("'[")
    let e = line("']")
    execute b ',' e 'substitute/\v(\''?)(\$?\u+\$?\d+)(\''?)/\1" \& \2 \& "\3/g'
    execute b 'substitute/^/="/'
    execute e 'substitute/$/"/'
  endfunction

  map _ <Plug>(operator-replace)
  map ;e <Plug>(operator-excelize)
  map ;h <Plug>(operator-html-escape)
  map ;H <Plug>(operator-html-unescape)
  map ;c <Plug>(operator-camelize)
  map ;C <Plug>(operator-decamelize)
endif

" textobj {{{2
" Tmap i<Space>f <Plug>(textobj-function-i)
" Tmap a<Space>f <Plug>(textobj-function-a)
" Tmap i<Space>i <Plug>(textobj-indent-i)
" Tmap a<Space>i <Plug>(textobj-indent-a)
Tmap i<Space>p <Plug>(textobj-parameter-i)
Tmap a<Space>p <Plug>(textobj-parameter-a)
" Tmap i<Space>l <Plug>(textobj-line-i)
" Tmap a<Space>l <Plug>(textobj-line-a)
Tmap i<Space>b <Plug>(textobj-between-i)
Tmap a<Space>b <Plug>(textobj-between-a)
let g:textobj_between_no_default_key_mappings=1
" Tmap i<Space>w <Plug>(textobj-wiw-i)
" Tmap a<Space>w <Plug>(textobj-wiw-a)
" let g:textobj_wiw_no_default_key_mappings=1

" ref.vim {{{2
" options {{{3
if isdirectory($HOME.'/.bin/apps/phpman/')
  let g:ref_phpmanual_path=$HOME.'/.bin/apps/phpman/'
endif
if isdirectory($HOME.'/.bin/apps/jdk-6-doc/ja')
  let g:ref_javadoc_path = $HOME.'/.bin/apps/jdk-6-doc/ja'
endif
if isdirectory($HOME.'/.bin/apps/jqapi-latest')
  let g:ref_jquery_path = $HOME.'/.bin/apps/jqapi-latest/docs'
  "let g:ref_jquery_use_cache = 1
endif
if isdirectory($HOME."/.nodebrew")
  let g:ref_nodejsdoc_dir = my#dir#find("~/.nodebrew/src/node-v*").last() . "/doc"
elseif isdirectory($HOME."/.nvm")
  let g:ref_nodejsdoc_dir = my#dir#find("~/.nvm/src/node-v*").last() . "/doc"
endif

if s:is_win
  let g:ref_refe_encoding = 'cp932'
else
  let g:ref_refe_encoding = 'utf-8'
  if exists('$RSENSE_HOME') && executable($RSENSE_HOME.'/bin/rsense')
    let g:ref_refe_rsense_cmd = $RSENSE_HOME.'/bin/rsense'
  endif
endif
let g:ref_perldoc_complete_head = 1
let g:ref_alc_use_cache = 1
let g:ref_alc_start_linenumber = 43
let g:ref_use_vimproc = 0

if exists('*ref#register_detection')
  call ref#register_detection('_', 'alc')
endif
" }}}

LCAlias Ref
for src in ['alc', 'refe', 'ri', 'perldoc', 'man'
      \ , 'pydoc', 'jsref', 'jquery'
      \ , 'cppref', 'cheat', 'nodejs', ]
  silent! exe 'Alias' src 'Ref' src
endfor
Alias mr Ref alc
Alias php[manual] Ref phpmanual
Alias timo Ref timobileref
Alias tide Ref tidesktopref

nnoremap [space]hh :Ref alc <C-r>=expand("<cWORD>")<CR><CR>

if !exists('g:ref_jsextra_defines')
  let g:ref_jsextra_defines = {}
endif
call extend(g:ref_jsextra_defines, {
      \ 'EaselJS' : { 
      \   'type' : 'yui', 
      \   'command' : 'zip', 
      \   'relative' : '', 
      \   'url' : 'https://github.com/CreateJS/EaselJS/raw/master/docs/EaselJS_docs-0.4.2.zip',
      \ },
      \ 'TweenJS' : { 
      \   'type' : 'yui', 
      \   'command' : 'zip', 
      \   'relative' : '', 
      \   'url' : 'https://github.com/CreateJS/TweenJS/raw/master/docs/TweenJS_docs-0.2.0.zip',
      \ },
      \ 'PreloadJS' : { 
      \   'type' : 'yui', 
      \   'command' : 'zip', 
      \   'relative' : '', 
      \   'url' : 'https://github.com/CreateJS/PreloadJS/raw/master/docs/PreloadJS_docs-0.1.0.zip',
      \ },
      \ 'SoundJS' : { 
      \   'type' : 'yui', 
      \   'command' : 'zip', 
      \   'relative' : '', 
      \   'url' : 'https://github.com/CreateJS/SoundJS/raw/master/docs/SoundJS_docs-0.2.0.zip',
      \ },
      \ })

" quickrun {{{2
"silent! nmap <unique> <Space> <Plug>(quickrun)
if !exists('g:quickrun_config')
  let g:quickrun_config={}
endif
let g:quickrun_config._ = {
      \   'runner' : 'vimproc',
      \   'runner/vimproc/updatetime' : 100,
      \   'outputter/buffer/split' : ':botright 8sp',
      \   'hook/inu/enable' : 1,
      \   'hook/inu/redraw' : 1,
      \   'hook/inu/wait' : 20,
      \ }
let g:quickrun_config.cat = {
      \  'command' : 'cat',
      \  'exec' : ['%c %s'],
      \ }
nnoremap <Leader><Leader>r :<C-u>QuickRun cat<CR>

" for lang "{{{3
let g:quickrun_config.go = {
      \  'command': '8g',
      \  'exec': ['8g %s', '8l -o %s:p:r %s:p:r.8', '%s:p:r %a', 'rm -f %s:p:r'],
      \ }
let g:quickrun_config.diag = {
      \  'exec': [
      \     '%c -a %s -o %{expand("%:r")}.png',
      \     printf("%s %{expand(%:r)}.png", 
      \      s:is_win ? 'explorer' : (s:is_mac ? 'open -g' : 'gnome-open'))
      \    ],
      \  'outputter': 'message',
      \ }
if s:is_mac
  let g:quickrun_config.processing = {
        \   'command': 'osascript',
        \   'exec' : ['osascript ' . globpath(&runtimepath, 'bin/runPSketch.scpt'). ' %s:p:h:t']
        \ }
  let g:quickrun_config.applescript = {
        \    'command' : 'osascript',
        \    'output' : '_',
        \ }
endif
" for testcase {{{3
MyAutocmd BufWinEnter,BufNewFile *_spec.rb setl filetype=ruby.rspec
MyAutocmd BufWinEnter,BufNewFile *test.php,*Test.php setl filetype=php.phpunit
MyAutocmd BufWinEnter,BufNewFile */Test/Case/*test.php,*/Test/Case/*Test.php setl filetype=php.phpunit.caketest
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
MyAutocmd BufWinEnter,BufNewFile test_*.py setl filetype=python.nosetests
MyAutocmd BufWinEnter,BufNewFile *.t setl filetype=perl.prove
if exists('*ref#register_detection')
  call ref#register_detection('ruby.rspec', 'refe', 'append')
  call ref#register_detection('php.phpunit', 'phpmanual', 'append')
  call ref#register_detection('php.phpunit.caketest', 'phpmanual', 'append')
  call ref#register_detection('python.nosetests', 'pydoc', 'append')
  call ref#register_detection('perl.prove', 'perldoc', 'append')
endif

let g:quickrun_config['ruby.rspec'] = {'command' : 'rspec', 'exec' : '%c -l {line(".")}'}
let g:quickrun_config['php.phpunit'] = {'command' : 'phpunit'}
let g:quickrun_config['php.phpunit.caketest'] = {'command' : 'caketest'}
let g:quickrun_config['python.nosetests'] = {'command': 'nosetests', 'cmdopt': '-s -vv'}
let g:quickrun_config['perl.prove'] = {'command': 'prove'}

" html {{{3
if s:is_mac
  let g:quickrun_config['html'] = {'exec' : 'open %s'}
  let g:quickrun_config['xhtml'] = {'exec' : 'open %s'}
else
endif

" objc {{{3
if executable('gcc') && s:is_mac
  let g:quickrun_config['objc'] = {
        \ 'command' : 'gcc',
        \ 'exec' : ['%c %s -o %s:p:r -framework Foundation', '%s:p:r %a', 'rm -f %s:p:r'],
        \ 'tempfile': '{tempname()}.m'
        \ }
        "\ 'exec' : ['%c %s -o %s:p:r -framework Cocoa', '%s:p:r %a', 'rm -f %s:p:r'],
endif
" text markups {{{3
if !executable('pandoc') && executable('markdown') "{{{4
  if executable('ruby') && filereadable($HOME.'/bin/mkd2html.rb')
          " \ 'command' : 'ruby ' . $HOME . '/bin/mkd2html.rb' ,
          " \   '%c %s',
    let g:quickrun_config['markdown'] = {
          \ 'command' : 'ruby' ,
          \ 'exec' : [
          \   '%c ' . $HOME . '/bin/mkd2html.rb' . ' %s',
          \ ],
          \ 'outputter': 'browser',
          \ }
  else
    let g:quickrun_config['markdown'] = {
          \ 'command' : 'markdown',
          \ 'exec' : [
          \   'echo "<html><head><meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\"></head>"',
          \   '%c %s',
          \ ],
          \ 'outputter': 'browser',
          \ }
  endif
else
  let g:quickrun_config['markdown'] = {
        \ 'type' : 'markdown/pandoc',
        \ 'outputter' : 'browser',
        \ 'cmdopt' : '-s'
        \ }
endif
if executable('redcloth') "{{{4
  let g:quickrun_config['textile'] = {
        \ 'command' : 'redcloth',
        \ 'exec' : [
        \   '%c %s',
        \ ],
        \ }
endif

function! s:quickrun_my_settings() "{{{4
  nmap <buffer> q :quit<CR>
endfunction "}}}
MyAutocmd FileType quickrun call s:quickrun_my_settings()

" watchdogs {{{2
if neobundle#is_installed('vim-watchdogs')
  call extend(g:quickrun_config, {
        \  'watchdogs_checker/_' : {
        \    'hook/close_quickfix/enable_failure' : 1,
        \    'hook/close_quickfix/enable_success' : 1,
        \    'hook/hier_update/enable' : 1,
        \    'hook/quickfix_stateus_enable/enable' : 1,
        \  },
        \  'perl/watchdogs_checker' : {
        \    'type' : 'watchdogs_checker/vimparse.pl',
        \  },
        \  'coffee/watchdogs_checker' : {
        \    'type' : 'watchdogs_checker/coffee',
        \  },
        \  'watchdogs_checker/coffee' : {
        \    'command' : 'coffee',
        \    'exec'    : '%c -c %o %s:p',
        \    'quickfix/errorformat' : 'Error:\ In\ %f\\,\ %m\ on\ line\ %l,'
        \                           . 'Error:\ In\ %f\\,\ Parse\ error\ on\ line\ %l:\ %m,'
        \                           . 'SyntaxError:\ In\ %f\\,\ %m,'
        \                           . '%-G%.%#',
        \  },
        \  'applescript/watchdogs_checker' : {
        \    'type' : 'watchdogs_checker/osacompile',
        \  },
        \  'watchdogs_checker/osacompile' : {
        \    'command' : 'osacompile',
        \     'exec'    : '%c -o %o %s:p',
        \     'quickfix/errorformat' : '%f:%l:%m',
        \  },
        \  'csharp/watchdogs_checker' : {
        \    'type' : 'watchdogs_checker/mcs',
        \  },
        \  'watchdogs_checker/mcs' : {
        \    'command' : 'mcs',
        \     'exec'    : '%c --parse %o %s:p',
        \     'quickfix/errorformat' : '%f(%l\,%c): %trror %m',
        \  },
        \  'haml/watchdogs_checker' : {
        \    'type' : 'watchdogs_checker/haml',
        \  },
        \  'watchdogs_checker/haml' : {
        \    'command' : 'haml',
        \     'exec'    : '%c -c %o %s:p',
        \     'quickfix/errorformat' : 'Haml error on line %l: %m,Syntax error on line %l: %m,%-G%.%#',
        \  },
        \  'objc/watchdogs_checker' : {
        \    'type' : 'watchdogs_checker/gcc_objc',
        \  },
        \  'watchdogs_checker/gcc_objc' : {
        \    'command' : 'gcc',
        \     'exec'    : '%c -fsyntax-only -lobjc %o %s:p',
        \     'quickfix/errorformat' : '%-G%f:%s:,'
        \                            . '%f:%l:%c: %trror: %m,'
        \                            . '%f:%l:%c: %tarning: %m,'
        \                            . '%f:%l:%c: %m,'
        \                            . '%f:%l: %trror: %m,'
        \                            . '%f:%l: %tarning: %m,'
        \                            . '%f:%l: %m',
        \  },
        \  'cucumber/watchdogs_checker' : {
        \    'type' : 'watchdogs_checker/cucumber',
        \  },
        \  'watchdogs_checker/cucumber' : {
        \    'command' : 'cucumber',
        \     'exec'    : '%c --dry-run --quiet --strict --format pretty %o %s:p',
        \     'quickfix/errorformat' : '%f:%l:%c:%m,%W      %.%# (%m),%-Z%f:%l:%.%#,%-G%.%#',
        \  },
        \  'lua/watchdogs_checker' : {
        \    'type' : 'watchdogs_checker/luac',
        \  },
        \  'watchdogs_checker/luac' : {
        \    'command' : 'luac',
        \     'exec'    : '%c -p %o %s:p',
        \     'quickfix/errorformat' : 'luac: %#%f:%l: %m',
        \  },
        \  'eruby/watchdogs_checker' : {
        \    'type' : 'watchdogs_checker/ruby_erb',
        \  },
        \  'watchdogs_checker/erubis' : {
        \    'command' : 'erubis',
        \     'exec'    : '%c -z %o %s:p',
        \     'quickfix/errorformat' : '%f:%l:%m',
        \  },
        \  'watchdogs_checker/ruby_erb' : {
        \    'command' : 'ruby',
        \     'exec'    : '%c  -rerb -e "puts ERB.new('
        \            . 'File.read(''%s:p'').gsub(''<\%='', ''<\%'')'
        \            . ', nil, ''-'').src" | %c -c %o',
        \     'quickfix/errorformat' : '%-GSyntax OK,%E-:%l: syntax error\, %m,%Z%p^,%W-:%l: warning: %m,%Z%p^,%-C%.%#',
        \  },
        \ })
        " ruby_erb => does not run well " \     'quickfix/errorformat' : '-:%l: %m',

        " \  '/watchdogs_checker' : {
        " \    'type' : 'watchdogs_checker/',
        " \  },
        " \  'watchdogs_checker/' : {
        " \    'command' : '',
        " \     'exec'    : '%c -c %o %s:p',
        " \     'quickfix/errorformat' : '',
        " \  },

  call watchdogs#setup(g:quickrun_config)
  let g:watchdogs_check_BufWritePost_enable = 1
endif

" echodoc {{{2
let g:echodoc_enable_at_startup=0

" neocomplcache {{{2
" options {{{3
let g:neocomplcache_snippets_dir                        = $HOME . '/.vim/snippets'
let g:neocomplcache_enable_at_startup                   = 1
let g:neocomplcache_cursor_hold_i_time                  = 500
if !has('vim_starting') | silent exe 'NeoComplCacheEnable' | endif

let g:neocomplcache_max_list = 100  " 補完候補の数
let g:neocomplcache_enable_auto_select = 1   " 一番目の候補を自動選択

let g:neocomplcache_enable_smart_case                   = 1
let g:neocomplcache_enable_camel_case_completion        = 0 " camel case off
let g:neocomplcache_enable_underbar_completion          = 1
" let g:neocomplcache_enable_auto_delimiter               = 1
let g:neocomplcache_disable_caching_file_path_pattern = "\.log$\|_history$\|\.howm$\|\.jax$\|\.snippets$"
let g:neocomplcache_lock_buffer_name_pattern            = '\*ku\*\|\.log$\|\.jax$\|\.log\.'

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
      \ 'omni_patterns', 'delimiter_patterns',
      \ 'same_filetype_lists', 'member_prefix_patterns',
      \ 'next_keyword_patterns',
      \ 'include_exprs',
      \ 'include_paths',
      \ ])

let g:neocomplcache_keyword_patterns.default = '\h\w*' " 日本語をキャッシュしない

call extend(g:neocomplcache_source_disable, {
      \ 'syntax_complete' : 1,
      \ })
call extend(g:neocomplcache_dictionary_filetype_lists, {
  \ 'default'     : '',
  \ 'vimshell'    : $HOME . '/.vimshell/command-history',
  \ 'javascript'  : $HOME . '/.vim/dict/node.dict',
  \ 'ruby'        : $HOME . '/.vim/dict/ruby.dict',
  \ 'eruby'       : $HOME . '/.vim/dict/ruby.dict',
  \ 'perl'        : $HOME . '/.vim/dict/perl.dict',
  \ 'php'         : $HOME . '/.vim/dict/php.dict',
  \ 'objc'        : $HOME . '/.vim/dict/objc.dict',
  \ 'actionscript': $HOME . '/.vim/dict/actionscript.dict',
  \ 'autohotkey'  : $HOME . '/.vim/dict/autohotkey.dict'
  \ })
  " \ 'javascript'  : $HOME . '/.vim/dict/javascript.dict',

let g:use_zen_complete_tag=1

let g:neocomplcache_vim_completefuncs.Ref = 'ref#complete'

let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'

let g:neocomplcache_include_patterns.scala = '^import'

" let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_delimiter_patterns.php = ['->', '::', '\']
let g:neocomplcache_member_prefix_patterns.php = '->\|::'

let g:neocomplcache_include_paths.autohotkey = '.,,'
let g:neocomplcache_include_patterns.autohotkey = '^\s*#\s*include'
let g:neocomplcache_include_exprs.autohotkey = ''

call s:bulk_dict_variables([{
      \   'dict' : g:neocomplcache_omni_patterns,
      \   'names' : ['twig', 'smarty'],
      \   'value' : '<[^>]*'
      \ }, {
      \   'dict' : g:neocomplcache_next_keyword_patterns,
      \   'names' : ['twig', 'smarty'],
      \   'value' : '[[:alnum:]_:-]*>\|[^"]*"'
      \ }])
" }}}

if neobundle#is_installed('neocomplcache')
  " SuperTab like snippets behavior.
  "imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

  " Recommended key-mappings.
  " <CR>: close popup and save indent.
  " inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
  inoremap <silent> <Cr> <C-R>=neocomplcache#smart_close_popup()<CR><CR>

  " <TAB>: completion.
  " inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  function! s:is_snip_file()
    return &filetype == "snippet"
  endfunction
  imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable()
        \ && !<SID>is_snip_file()
        \ ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"
  smap <expr><TAB> neocomplcache#sources#snippets_complete#expandable()
        \ && !<SID>is_snip_file()
        \ ? "\<Plug>(neocomplcache_snippets_expand)" : "\<TAB>"
  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h>  neocomplcache#smart_close_popup()."\<C-h>"
  inoremap <expr><BS>   neocomplcache#smart_close_popup()."\<C-h>"
  inoremap <expr><C-y>  neocomplcache#close_popup()
  inoremap <expr><C-e>  neocomplcache#cancel_popup()

  inoremap <expr> <C-j> pumvisible() ? neocomplcache#close_popup() : "\<CR>"

  imap <C-l> <Plug>(neocomplcache_snippets_expand)
  smap <C-l> <Plug>(neocomplcache_snippets_expand)
  imap <C-s> <Plug>(neocomplcache_start_unite_complete)
  " imap <expr><C-l> (pumvisible() ? neocomplcache#close_popup():"") ."\<Plug>(neocomplcache_snippets_expand)"
  " smap <expr><C-l> (pumvisible() ? neocomplcache#close_popup():"") ."\<Plug>(neocomplcache_snippets_expand)"

  nnoremap [space]ne :NeoComplCacheEnable<CR>
  nnoremap [space]nd :NeoComplCacheDisable<CR>
endif

" completes {{{3
if exists("+omnifunc") " {{{4
  MyAutocmd FileType php          setl omnifunc=phpcomplete#CompletePHP
  MyAutocmd FileType html,markdown setl omnifunc=htmlcomplete#CompleteTags
  MyAutocmd FileType python       setl omnifunc=pythoncomplete#Complete
  " MyAutocmd FileType javascript   setl omnifunc=javascriptcomplete#CompleteJS
  MyAutocmd FileType javascript   setl omnifunc=jscomplete#CompleteJS
  MyAutocmd FileType xml          setl omnifunc=xmlcomplete#CompleteTags
  MyAutocmd FileType css          setl omnifunc=csscomplete#CompleteCSS
  MyAutocmd FileType c            setl omnifunc=ccomplete#Complete
  MyAutocmd FileType actionscript setl omnifunc=actionscriptcomplete#CompleteAS
  MyAutocmd FileType *
        \ if &l:omnifunc == ''
        \ | setlocal omnifunc=syntaxcomplete#Complete
        \ | endif
endif

if exists('$RSENSE_HOME') " {{{4
  let g:rsenseHome=$RSENSE_HOME
  let g:rsenseUseOmniFunc=1
elseif exists('+omnifunc')
  "MyAutocmd FileType ruby setl omnifunc=rubycomplete#Complete
endif

" vimshell {{{2

let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
if exists('*vcs#info')
  let g:vimshell_right_prompt = 'vimshell#vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'
endif
let g:vimshell_enable_smart_case = 1
let g:vimshell_enable_auto_slash = 1

function! s:setup_vimproc_dll() " {{{3
  let path = ""
  if s:is_win
    if has('unix')
      let path = expand(g:my_bundle_dir . '/vimproc/autoload/proc_cygwin.dll')
    else
      let path = expand(g:my_bundle_dir . '/vimproc/autoload/proc_' . (has('win64') ? 'win64' : 'win32') .'.dll')
      if !filereadable(path)
        if has('win64')
          let path = expand('~/.vim/lib/vimproc/vimproc_win64.dll')
        elseif has('win32')
          let path = expand('~/.vim/lib/vimproc/vimproc_win32.dll')
        elseif has('win16')
          let path = expand('~/.vim/lib/vimproc/vimproc_win16.dll')
        endif
      endif
    endif
  elseif s:is_mac
    let path = expand(g:my_bundle_dir . '/vimproc/autoload/proc_mac.so')
  else
    let path = expand(g:my_bundle_dir . '/vimproc/autoload/proc_unix.so')
  endif
  if filereadable(path)
    let g:vimproc_dll_path = path
  endif
endfunction " }}}

call s:setup_vimproc_dll()

if s:is_win " {{{3
  " Display user name on Windows.
  let g:vimshell_prompt = $USERNAME."% "
  let g:vimshell_use_ckw = 1
  "let g:vimproc_dll_path = expand("~/.vim/lib/vimproc/win32/proc.dll")
else " {{{3
  " Display user name
  let g:vimshell_prompt = $USER."$ "

  MyAutocmd VimEnter
        \ call vimshell#set_execute_file('bmp,jpg,png,gif', 'gexe eog')
        \ call vimshell#set_execute_file('mp3,m4a,ogg', 'gexe amarok')
        \ let g:vimshell_execute_file_list['zip'] = 'zipinfo'
        \ call vimshell#set_execute_file('tgz,gz', 'gzcat')
        \ call vimshell#set_execute_file('tbz,bz2', 'bzcat')
endif

MyAutocmd FileType vimshell call s:vimshell_my_settings() " {{{3
function! s:vimshell_my_settings() " {{{3
  setl textwidth=0
  "autocmd FileType vimshell
  call vimshell#altercmd#define('g'  , 'git')
  call vimshell#altercmd#define('i'  , 'iexe')
  call vimshell#altercmd#define('l'  , 'll')
  call vimshell#altercmd#define('ll' , 'ls -l')
  call vimshell#altercmd#define('la' , 'ls -a')
  call vimshell#altercmd#define('e' , 'vim')
  for cmd in ['irb', 'termtter']
    if executable(cmd) | call vimshell#altercmd#define(cmd, 'iexe '.cmd) | endif
  endfor
  call vimshell#hook#set('chpwd'     , ['g:my_chpwd'])
  call vimshell#hook#set('emptycmd'  , ['g:my_emptycmd'])
  call vimshell#hook#set('preprompt' , ['g:my_preprompt'])
  call vimshell#hook#set('preexec'   , ['g:my_preexec'])

  imap <silent> <buffer> <C-a> <C-o>:call cursor(line('.'), strlen(g:vimshell_prompt)+1)<CR>
  inoremap <expr><buffer> <C-j> pumvisible() ? neocomplcache#close_popup() : ""
endfunction

function! g:my_chpwd(args, context) " {{{3
  call vimshell#execute('ls')
endfunction

function! g:my_emptycmd(cmdline, context) " {{{3
  "call vimshell#execute('echo "emptycmd"')
  call vimshell#set_prompt_command('ls')
  return 'ls'
endfunction

function! g:my_preprompt(args, context) " {{{3
  "call vimshell#execute('echo "preprompt"')
endfunction

function! g:my_preexec(cmdline, context) " {{{3
  "call vimshell#execute('echo "preexec"')

  if a:cmdline =~# '^\s*diff\>'
    call vimshell#set_syntax('diff')
  endif
  return a:cmdline
endfunction " }}}

nmap [space]vp :<C-u>VimShellPop<CR>
nmap [space]vv :<C-u>VimShellTab<CR>
nmap [space]ve :<C-u>VimShellExecute<Space>
nmap [space]vi :<C-u>VimShellInteractive<Space>
nmap [space]vt :<C-u>VimShellTerminal<Space>

command! IRB VimShellInteractive irb
LCAlias IRB

" vimfiler {{{2
let g:vimfiler_as_default_explorer=1
let g:vimfiler_safe_mode_by_default=0
let g:vimfiler_edit_action = 'below'

let g:vimfiler_tree_leaf_icon = ' '
let g:vimfiler_tree_opened_icon = '▾'
let g:vimfiler_tree_closed_icon = '▸'
let g:vimfiler_file_icon = '-'
let g:vimfiler_marked_file_icon = '*'

MyAutocmd FileType vimfiler call s:vimfiler_my_settings()
" keymaps {{{3
" nnoremap <silent> [space]f :VimFiler -toggle -split -direction=topleft -buffer-name=ftree -simple -winwidth=40 file:<C-r>=getcwd()<CR><CR>
" nnoremap <silent> [space]ff :VimFiler -toggle -split -direction=topleft -buffer-name=ftree -simple -winwidth=40 file:<C-r>=getcwd()<CR><CR>
" nnoremap <silent> [space]fg :VimFiler -toggle -split -direction=topleft -buffer-name=ftree -simple -winwidth=40 file:<C-r>=fnameescape(expand('%:p:h'))<CR><CR>
" command! -nargs=? VFTree VimFiler -toggle -split -direction=topleft -buffer-name=ftree -simple -winwidth=40 file:
nnoremap <silent> [space]f  :call <SID>vimfiler_tree_launch()<CR>
nnoremap <silent> [space]ff :call <SID>vimfiler_tree_launch()<CR>
nnoremap <silent> [space]fg :call <SID>vimfiler_tree_launch(fnameescape(expand('%:p:h')))<CR>
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

function! s:vimfiler_tree_edit(method) "{{{4
  " let file = vimfiler#get_file()
  " if empty(file) || empty(a:method) | return | endif
  " let path = file.action__path
  " wincmd p
  " execute a:method
  " exe 'edit' path
  if empty(a:method) | return | endif
  let linenr = line('.')
  let context = s:vimfiler_create_action_context(a:method, linenr)
  "wincmd p
  let cur_nr = bufnr('%')
  silent wincmd l
  if cur_nr == bufnr('%')
    silent wincmd v
  endif
  " call vimfiler#mappings#do_action(a:method, linenr)
  call context.execute()
  unlet context
endfunction

function! s:vimfiler_smart_tree_l(method, ...) "{{{4
  let file = vimfiler#get_file()
  if empty(file) 
    if (a:0 > 0 && a:1 == 1)
      exe 'normal' "\<Plug>(vimfiler_smart_h)"
    endif
    return
  endif
  let path = file.action__path
  if file.vimfiler__is_directory
    if (a:0 > 0 && a:1 == 2)
      exe 'normal' "\<Plug>(vimfiler_smart_l)"
    else
      exe 'normal' "\<Plug>(vimfiler_expand_tree)"
    endif
    normal! ^
    return
  endif
  call s:vimfiler_tree_edit(a:method)
endfunction "}}}
function! s:vimfiler_tabopen() " {{{4
  let bnr = bufnr('%')
  let linenr = line('.')
  let context = s:vimfiler_create_action_context('tabopen', linenr)
  call context.execute()
  unlet context
endfunction

function! s:vimfiler_tree_tabopen() " {{{4
  call s:vimfiler_tabopen()
  silent! exe printf('vsplit +wincmd\ H\|wincmd\ l #%d', bnr)
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
function! s:vimfiler_my_settings() " {{{3
  nmap <buffer> u <Plug>(vimfiler_move_to_history_directory)
  hi link ExrenameModified Statement
  "nnoremap <buffer> v V
  if exists('b:vimfiler')
    if exists('b:vimfiler.context.explorer') && b:vimfiler.context.explorer "{{{4
      nmap <silent><buffer> L <Plug>(vimfiler_smart_l)
      nmap <silent><buffer> E :call <SID>vimfiler_tabopen()<CR>
      " smart_h ができない…ｼｮﾎﾞﾝﾇ(´Д｀)
      " nmap <silent><buffer> H <Plug>(vimfiler_smart_h)
      nnoremap <silent><buffer> <LeftMouse> <Esc>:set eventignore=all<CR>:call <SID>noscrolloff_leftmouse()<CR>:<C-u>execute "normal \<Plug>(vimfiler_expand_tree)"<CR>:set eventignore=<CR>^
      nnoremap <silent><buffer> <2-LeftMouse> <Esc>:set eventignore=all<CR>:call <SID>noscrolloff_leftmouse()<CR>::set eventignore=<CR>:<C-u>execute "normal \<Plug>(vimfiler_execute_system_associated)"<CR>
    elseif exists('b:vimfiler.context') && b:vimfiler.context.profile_name == 'ftree' "{{{4
      " nmap <buffer> e <Plug>(vimfiler_split_edit_file)
      " nmap <buffer> e <Plug>(vimfiler_tab_edit_file)
      nnoremap <silent><buffer> e :call <SID>vimfiler_tree_edit('open')<CR>
      nnoremap <silent><buffer> E :call <SID>vimfiler_tree_tabopen()<CR>
      nnoremap <silent><buffer> l :call <SID>vimfiler_smart_tree_l('')<CR>
      " nnoremap <silent><buffer> <LeftMouse> <LeftMouse>:call <SID>vimfiler_smart_tree_l('')<CR>
      " nnoremap <silent><buffer> <LeftMouse> <Esc>:set eventignore=all<CR><LeftMouse>:call <SID>vimfiler_smart_tree_l('')<CR>:set eventignore=<CR>
      " nnoremap <silent><buffer> <2-LeftMouse> <Esc>:set eventignore=all<CR><LeftMouse>:set eventignore=<CR>:call <SID>vimfiler_smart_tree_l('new')<CR>
      nnoremap <silent><buffer> <LeftMouse> <Esc>:set eventignore=all<CR>:call <SID>noscrolloff_leftmouse()<CR>:call <SID>vimfiler_smart_tree_l('', 1)<CR>:set eventignore=<CR>
      nnoremap <silent><buffer> <2-LeftMouse> <Esc>:set eventignore=all<CR>:call <SID>noscrolloff_leftmouse()<CR>::set eventignore=<CR>:call <SID>vimfiler_smart_tree_l('open', 2)<CR>
      " nmap <buffer> l <Plug>(vimfiler_expand_tree)
      nmap <buffer> L <Plug>(vimfiler_smart_l)
      nnoremap <silent><buffer> h :call <SID>vimfiler_smart_tree_h()<CR>
      nnoremap <silent><buffer> gu :call <SID>vimfiler_tree_up()<CR>
    endif
  endif
endfunction

" vinarise {{{2
" let g:vinarise_enable_auto_detect = 1

" memolist {{{2
let g:memolist_suffix = "md"
let g:memolist_path = $HOME . '/memo'
nmap <silent> [prefix]mf :exe 'Unite' 'file:'.g:memolist_path<CR>
nmap <silent> [prefix]mc :MemoNew<CR>
nmap <silent> [prefix]ml :MemoList<CR>
nmap <silent> [prefix]mg :MemoGrep<CR>

" etc functions & commands {{{1
" tiny snippets {{{2
let g:my_snippets_dir = "$HOME/memos/tiny-snippets"

if neobundle#is_installed('unite.vim')
  let s:unite_action_file_insert = {} " {{{3
  function! s:unite_action_file_insert.func(candicate)
    "echo a:candicate
    let l:path = a:candicate.word
    if isdirectory(l:path)
      call unite#do_action('narrow')
    elseif filereadable(l:path)
      let linesread=line('$')
      let l:old_cpoptions=&cpoptions
      setlocal cpoptions-=a
      :execute 'read '.l:path
      let &cpoptions = l:old_cpoptions
      let linesread=line('$')-linesread-1
      if linesread >= 0
        silent exe 'normal! ='.linesread.'+'
      endif
    endif
  endfunction
  call unite#custom_action('file', 'insert_file', s:unite_action_file_insert)
  unlet! s:unite_action_file_insert
endif

function! MyFilerecLauncher(mode, option) " {{{3
  if g:my_snippets_dir == ''
    return
  endif
  if a:mode == 'r'
    let l:snippets_dir = g:my_snippets_dir
  else
    let l:delm=(strpart(g:my_snippets_dir, strlen(g:my_snippets_dir) -1) == '/' ? '' : '/')
    let l:snippets_dir = expand(g:my_snippets_dir . l:delm . &filetype . (&filetype == '' ? '' : "/"))

    if ! isdirectory(l:snippets_dir)
      let l:snippets_dir=expand(g:my_snippets_dir.l:delm)
    endif
  endif
  if a:option == 'i'
    let l:option = ' -default-action=insert_file'
  else
    let l:option = ''
  endif
  exe "Unite file_rec:".fnameescape(l:snippets_dir).l:option
endfunction 
" }}}
" mapping for tiny-snippets
nnoremap [unite]n <Nop>
nnoremap [unite]nr :<C-u>call MyFilerecLauncher('f', 'i')<CR>
nnoremap [unite]ne :<C-u>call MyFilerecLauncher('f', 'o')<CR>
nnoremap [unite]no :<C-u>call MyFilerecLauncher('r', 'o')<CR>
nnoremap [unite]nn :execute 'new' g:my_snippets_dir<CR>
nnoremap [unite]nm :execute 'new $HOME/memos'<CR>

" buffer commands {{{2
command! ToUnixBuffer set fileformat=unix fileencoding=utf8
command! ToWindowsBuffer set fileformat=dos fileencoding=cp932
command! ToMacBuffer set fileformat=mac fileencoding=utf8
command! TrimRSpace %s/ \+$//
command! ConvChilder %s/〜/～/g
command! Tosass call my#util#newfile_with_text(expand('%:p:r').".sass",
      \ system(printf('sass-convert -F css -T sass "%s"', expand('%:p')))
      \ )
command! Toscss call my#util#newfile_with_text(expand('%:p:r').".scss",
      \ system(printf('sass-convert -F css -T scss "%s"', expand('%:p')))
      \ )
command! Tocoffee call my#util#newfile_with_text(expand('%:p:r').".coffee",
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
elseif s:is_win "{{{3
  " Utility command for Windows
  command! Here silent execute '!explorer' substitute(expand('%:p:h'), '/', '\', 'g')
  command! This silent execute '!start cmd /c "%"'
  command! In silent execute '!start cmd /k cd "'.substitute(expand('%:p:h'), '/', '\', 'g').'"'
  command! -nargs=1 -complete=file That silent execute '!explorer' shellescape(expand(<f-args>), 1)
else "{{{3
  " TODO
  command! Here silent execute '!gnome-open' expand('%:p:h')
  command! This silent execute '!"%"'
  command! In silent execute '!gnome-terminal -e "cd '.shellescape(expand('%:p:h')).'"'
  command! -nargs=1 -complete=file That silent execute '!gnome-open' shellescape(expand(<f-args>), 1)
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

" rename {{{2
command! -nargs=? -complete=file Rename call my#ui#rename(<q-args>)
Alias ren Rename

command! -nargs=1 -complete=file Relcp call my#ui#relative_copy(<f-args>)
LCAlias Relcp

" win maximize toggle {{{3
nnoremap [prefix]mm :call my#winmaximizer#get().toggle()<CR>
nnoremap [prefix]mj :call my#winmaximizer#get().toggleDirection("v")<CR>
nnoremap [prefix]mh :call my#winmaximizer#get().toggleDirection("h")<CR>

" fopen & encoding {{{2
command! -nargs=1 -complete=customlist,my#ui#complete_encodings Fenc setl fenc=<args>
command! -nargs=1 -complete=customlist,my#ui#complete_encodings Freopen e ++enc=<args> %

command! Utf8 e ++enc=utf-8 %
command! Euc e ++enc=euc-jp %
command! Sjis e ++enc=cp932 %
command! Jis e ++enc=iso-2022-jp %
command! Dos e ++ff=dos %
command! Mac e ++ff=mac %
command! Unix e ++ff=unix %
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
command! -range Tsvtosqlwhere      <line1>,<line2>call my#tsv#to_sqlwhere()
command! -range Tsvtosqlin         <line1>,<line2>call my#tsv#to_sqlin()
command! -range Tsvexchangematrix <line1>,<line2>call my#tsv#exchange_matrix()
command! -range Tsvtosqlinsert     <line1>,<line2>call my#tsv#to_sqlinsert()
command! -range Tsvtosqlupdate     <line1>,<line2>call my#tsv#to_sqlupdate()

" MySQL {{{3
command! -nargs=0 -range TMY <line1>,<line2>call my#mysql#to_tsv()
command! -nargs=0 -range MySQLToTsv <line1>,<line2>call my#mysql#to_tsv()

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

" }}}1
" __END__ {{{1
" vim: set ft=vim fdm=marker sw=2 ts=2 et:
