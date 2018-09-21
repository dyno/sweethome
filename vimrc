"----------------------------------------------------------
"Vundle - Plugin manager setup

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
" git submodule init
" :PluginInstall
set runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

"---
" Plugin from github

"
Plugin 'uarun/vim-protobuf'
Plugin 'dcharbon/vim-flatbuffers'
"Plugin 'vim-scripts/Windows-PowerShell-Syntax-Plugin'
"
"buftabline : Use the tabline to render buffer tabs
"http://www.vim.org/scripts/script.php?script_id=5057
Plugin 'ap/vim-buftabline'

Plugin 'derekwyatt/vim-scala'
Plugin 'cespare/vim-toml'

"---
"Plugin from http://vim-scripts.org/vim/scripts.html

"Create aliases for Vim commands.
"http://www.vim.org/scripts/script.php?script_id=746
Plugin 'cmdalias.vim'
":call CmdAlias('q', 'qa')

"The NERD tree : A tree explorer plugin for navigating the filesystem
"http://www.vim.org/scripts/script.php?script_id=1658
Plugin 'The-NERD-tree'

Plugin 'Chiel92/vim-autoformat'

call vundle#end()            " required
filetype plugin indent on    " required

"----------------------------------------------------------
autocmd BufRead,BufNewFile *{vimrc}         set filetype=vim
autocmd BufRead,BufNewFile /etc/apache2/*   set filetype=apache
"
autocmd BufRead,BufNewFile *.tsc            set filetype=tsc
autocmd BufRead,BufNewFile *.sql,afiedt.buf set filetype=plsql
autocmd BufRead,BufNewFile vm.cfg           set filetype=python
"
autocmd BufRead,BufNewFile *.sc,SCons*      set filetype=scons
autocmd BufRead,BufNewFile *.mako           set filetype=mako
autocmd BufRead,BufNewFile *.dump.txt       set filetype=java
autocmd BufRead,BufNewFile *.wiki           set filetype=creole
"
autocmd BufRead,BufNewFile *.gradle         set filetype=groovy

":PluginInstall
"https://vi.stackexchange.com/questions/388/what-is-the-difference-between-the-vim-plugin-managers

"----------------------------------------------------------
"Plugin 'The-NERD-tree'
"
let NERDTreeIgnore = ['\~$', '\.swp$', '\.pyc$', '\.pyo$']

"SafeBufferDelete() is a revised version of CleanClose() in
"http://stackoverflow.com/questions/256204/vim-close-file-without-quiting-vim-application/290110#290110
"Below link seems to do something similar but I did not try it.
"Delete buffer while keeping window layout (don't close buffer's windows).
"http://vim.wikia.com/wiki/VimTip165
":help :bar
function! SafeBufferDelete(force)
  let bufToBeDel = bufnr("%")
  " If this is an unlisted buffer, simply bd
  if !buflisted(bufToBeDel) | bd | return | endif

  if !a:force && getbufvar(bufToBeDel, "&modified")
    echohl ErrorMsg | echo "Save buffer first!" | echohl None
    return
  endif

  let bufAlt = bufnr("#")
  " Try alternative "#" if it is listed, or try next listed
  if ((bufAlt != -1) && (bufAlt != bufToBeDel) && buflisted(bufAlt))
    execute "b" . bufAlt
  else
    bnext
  endif

  " If this is the last listed buffer (bnext stays in current buffer),
  " create a new buffer first
  if (bufnr("%") == bufToBeDel) | new | endif

  " Finally do the real bd job
  if a:force
    execute "bd! " . bufToBeDel
  else
    execute "bd " . bufToBeDel
  endif
endfunction

"TODO: won't it be more elegant if we can skip the buffer/windows manager?
"autocmd BufDelete * SkipNERD_TreeBuffer()

"When restore a session, an empty NERD_Tree window is not desirable.
function! NERDTree_GetBuffers()
  let vBufList = []
  let l:i = 1
  while(l:i <= bufnr('$'))
    let vBufName = bufname(l:i)
    if vBufName =~ "NERD_tree_.*"
      call add(vBufList, vBufName)
    endif
    let l:i = l:i + 1
  endwhile
  return vBufList
endfunction

function! NERDTree_Reload()
  let vBufList = NERDTree_GetBuffers()
  for vBufName in vBufList
    let vBufNr = bufnr(vBufName)
    if (vBufNr != -1) && getbufline(vBufNr, 1)[0] == ""
      execute "bwipeout".vBufNr
    endif
  endfor

  if !empty(vBufList) && empty(NERDTree_GetBuffers())
    "Put debug message in register @e
    ":help line-continuation, new-line-continuation
    let @e = "@" . substitute(system('date'),"\n","", "g")
	  \ . " NERDTree Reloaded!\n"
    :NERDTree
  endif
endfunction

autocmd VimEnter * if exists(':Alias') | call CmdAlias('bd', 'call SafeBufferDelete(0)') | endif
autocmd VimEnter * if exists(':Alias') | call CmdAlias('bdf', 'call SafeBufferDelete(1)') | endif
"autocmd VimEnter * NERDTree
autocmd SessionLoadPost * call NERDTree_Reload()
"autocmd VimEnter * wincmd p


"----------------------------------------------------------
" Global

syntax on

if has('gui_running')
  "set guioptions-=T  " no toolbar
  "colorscheme desert
  colorscheme koehler

  if has("gui_macvim")
    set guifont=Monaco:h12
  endif

else
  "colorscheme darkblue
  "colorscheme elflord
  colorscheme desert
endif

"----------------------------------------------------------
"backspace behavior
noremap Bs Del
noremap Del Bs
noremap!Bs Del
noremap!Del Bs
:set backspace=2

"move one screen line previous/next
map <Up> gk
imap <Up> <C-o>gk
map <Down> gj
imap <Down> <C-o>gj

"----------------------------------------------------------
set showcmd            " Show (partial) command in status line.
set showmatch          " Show matching brackets.
set ignorecase         " Do case insensitive matching
set smartcase          " Do smart case matching
set incsearch          " Incremental search
set autowrite          " Automatically save before commands like :next and :make

""----------------------------------------------------------
"tab setting
set tabstop=8
""set tabstop=4
set softtabstop=4
set shiftwidth=2
set smarttab
""set expandtab
"":retab "to expand existing tab
set list listchars=tab:»·,trail:§

autocmd FileType make       setlocal noexpandtab
autocmd FileType python     setlocal expandtab

"----------------------------------------------------------
"remove trailing spaces
"http://www.vim.org/tips/tip.php?tip_id=878
function! TrimSpaces()
  :mark '
  "except:
  "   ISF=<space> in bash scripts
  "   --<space> in mail signature
  :% s/\(^\(--\|ISF=\)\)\@<!\s\+$//e
  "go back to where we were
  :''
endfunction

autocmd FileWritePre   *.{py,sh,wiki,txt} :call TrimSpaces()
autocmd FileAppendPre  *.{py,sh,wiki,txt} :call TrimSpaces()
autocmd FilterWritePre *.{py,sh,wiki,txt} :call TrimSpaces()
autocmd BufWritePre    *.{py,sh,wiki,txt} :call TrimSpaces()

"----------------------------------------------------------
autocmd BufRead,BufNewFile *{vimrc}         set filetype=vim
autocmd BufRead,BufNewFile /etc/apache2/*   set filetype=apache

"
"autocmd BufRead,BufNewFile *.tsc            set filetype=tsc
"autocmd BufRead,BufNewFile *.sql,afiedt.buf set filetype=plsql
"autocmd BufRead,BufNewFile vm.cfg           set filetype=python

"
"autocmd BufRead,BufNewFile *.sc,SCons*      set filetype=scons
"autocmd BufRead,BufNewFile *.mako           set filetype=mako
"autocmd BufRead,BufNewFile *.dump.txt       set filetype=java
"autocmd BufRead,BufNewFile *.wiki           set filetype=creole

"
autocmd BufRead,BufNewFile *.gradle         set filetype=groovy

autocmd BufRead,BufNewFile *.sc             set filetype=scala
autocmd BufRead,BufNewFile Pipfile          set filetype=toml

"----------------------------------------------------------
":help DiffOrig
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis

autocmd VimEnter * if exists(':Alias') | call CmdAlias('idiff', 'DiffOrig') | endif

"----------------------------------------------------------
":help expand()
autocmd BufEnter * lcd %:p:h
autocmd VimEnter * if exists(':Alias') | call CmdAlias('q', 'qa') | endif
autocmd VimEnter * if exists(':Alias') | call CmdAlias('wq', 'wqa') | endif

"----------------------------------------------------------
"http://stackoverflow.com/questions/406230/regular-expression-to-match-string-not-containing-a-word
"http://vimdoc.sourceforge.net/htmldoc/pattern.html
"^\(.\(hostCPUID\)\@!\)*$

"----------------------------------------------------------
set history=1024

"----------------------------------------------------------
" scalafmt settings
" https://github.com/Chiel92/vim-autoformat/issues/184
let g:formatdef_scalafmt = '"scalafmt --config ~/.scalafmt.conf --assume-filename=a.sc --stdin 2>/dev/null"'
let g:formatters_scala = ['scalafmt']
