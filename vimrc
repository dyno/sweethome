"https://github.com/uarun/vim-protobuf
"http://www.vim.org/scripts/script.php?script_id=2332
execute pathogen#infect()

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
autocmd FileType flexwiki   setlocal expandtab
autocmd FileType mako       :syntax sync minlines=200

"----------------------------------------------------------
"cmdalias.vim : Create aliases for Vim commands.
"http://www.vim.org/scripts/script.php?script_id=746
source $HOME/.vim/plugin/cmdalias.vim
":call CmdAlias('q', 'qa')

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
:endfunction

autocmd FileWritePre   *.{py,mako,sh,wiki,txt} :call TrimSpaces()
autocmd FileAppendPre  *.{py,mako,sh,wiki,txt} :call TrimSpaces()
autocmd FilterWritePre *.{py,mako,sh,wiki,txt} :call TrimSpaces()
autocmd BufWritePre    *.{py,mako,sh,wiki,txt} :call TrimSpaces()

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

"----------------------------------------------------------
"The NERD tree : A tree explorer plugin for navigating the filesystem
"http://www.vim.org/scripts/script.php?script_id=1658

let NERDTreeIgnore = ['\~$', '\.swp$', '\.pyc$', '\.pyo$']
"autocmd VimEnter * NERDTree
"autocmd VimEnter * wincmd p

:Alias q qa
:Alias wq wqa

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

:call CmdAlias('bd', 'call SafeBufferDelete(0)')
:call CmdAlias('bdf', 'call SafeBufferDelete(1)')

"TODO: won't it be more elegant if we can skip the buffer/windows manager?
"autocmd BufDelete * SkipNERD_TreeBuffer()

"----------------------------------------------------------
"buftabs : Minimalistic buffer tabs saving screen space
"http://www.vim.org/scripts/script.php?script_id=1664
set laststatus=2
:let g:buftabs_in_statusline=1
:let g:buftabs_only_basename=1

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

autocmd SessionLoadPost * call NERDTree_Reload()

"----------------------------------------------------------
":help DiffOrig
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis

:Alias idiff DiffOrig

"----------------------------------------------------------
":help expand()
autocmd BufEnter * lcd %:p:h

"----------------------------------------------------------
"http://stackoverflow.com/questions/406230/regular-expression-to-match-string-not-containing-a-word
"http://vimdoc.sourceforge.net/htmldoc/pattern.html
"^\(.\(hostCPUID\)\@!\)*$

"----------------------------------------------------------
set history=1024
