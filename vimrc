syntax on

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
autocmd FileType flexwiki   setlocal expandtab

"----------------------------------------------------------
"remove trailing spaces
"http://www.vim.org/tips/tip.php?tip_id=878
function TrimSpaces()
:mark '
"except:
"   ISF=<space> in bash scripts
"   --<space> in mail signature
:% s/\(^\(--\|ISF=\)\)\@<!\s\+$//e
"go back to where we were
:''
:endfunction

"autocmd FileWritePre   *.{py,sh,wiki,txt} :call TrimSpaces()
"autocmd FileAppendPre  *.{py,sh,wiki,txt} :call TrimSpaces()
"autocmd FilterWritePre *.{py,sh,wiki,txt} :call TrimSpaces()
"autocmd BufWritePre    *.{py,sh,wiki,txt} :call TrimSpaces()

"----------------------------------------------------------
autocmd BufRead,BufNewFile *{vimrc}         set filetype=vim
autocmd BufRead,BufNewFile *.tsc            set filetype=tsc
autocmd BufRead,BufNewFile *.sql,afiedt.buf set filetype=plsql
autocmd BufRead,BufNewFile vm.cfg           set filetype=python
autocmd BufRead,BufNewFile /etc/apache2/*   set filetype=apache
autocmd BufRead,BufNewFile *.sc,SCons*      set filetype=scons

"----------------------------------------------------------
"help expand()
autocmd BufEnter * lcd %:p:h
