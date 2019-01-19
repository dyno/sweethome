" https://spacevim.org/documentation/#bootstrap-functions
" https://spacevim.org/conventions/

" ------------------------------------------------------------------------------

func! myspacevim#before() abort

  if v:version >= 800
    " https://github.com/ludovicchabant/vim-gutentags
    " https://github.com/skywind3000/gutentags_plus
    " used by layers.tags
    let g:gutentags_trace = 0
    "https://www.jianshu.com/p/110b27f8361b
    let g:gutentags_modules = []
    if executable('ctags')
      let g:gutentags_modules += ['ctags']
    endif
    if executable('gtags-cscope') && executable('gtags')
      let g:gutentags_modules += ['gtags_cscope']
    endif

    let g:gutentags_ctags_tagfile = 'tags'

    " https://github.com/liuchengxu/space-vim/blob/master/core/autoload/spacevim/autocmd/gutentags.vim
    " let s:tags_cache_dir = expand('~/.cache/tags')
    " if !isdirectory(s:tags_cache_dir)
    "   silent! call mkdir(s:tags_cache_dir, 'p')
    " endif
    " let g:gutentags_cache_dir = s:tags_cache_dir

    " generate in project directory so that tags layer and GscopeFind
    " (gutentags_plus) can share the same tags file.
    let g:gutentags_cache_dir = ''

    " let g:gutentags_project_root = ['.git', 'settings.gradle', 'Pipfile', 'pyproject.toml']
    let g:gutentags_add_default_project_roots = 1
    let g:gutentags_generate_on_missing = 1
    let g:gutentags_ctags_exclude = ['build', '.venv', 'zold', 'output', '.git', '.svn', '.hg', '.eggs', '*.egg-info']
    " GscopeAdd; cs show
    let g:gutentags_auto_add_gtags_cscope = 0

    let g:rainbow_active = 1
  endif

  " https://github.com/srstevenson/vim-picker
  let g:picker_find_executable = 'rg'
  let g:picker_find_flags = '--color never --files'

  " https://github.com/prabirshrestha/vim-lsp
  let g:lsp_log_verbose = 0
  let g:lsp_log_file = expand('~/tmp/vim-lsp.log')

  if has('macunix')
    let g:python3_host_prog = '/usr/local/bin/python3'
  elseif has('unix')
    let g:python3_host_prog = '/usr/bin/python3'
  endif
  if filereadable(expand('~/venvs/vim/.venv/bin/python3'))
    let g:python3_host_prog = expand('~/venvs/vim/.venv/bin/python3')
  endif

  " https://github.com/vim/vim/issues/3707, compiled python should not set `sys.executable` to vim
  if has('python3_compiled') && has('macunix') && v:version >= 800
    :py3 import os; sys.executable = os.path.join(sys.exec_prefix, 'bin/python3')
  endif

  augroup auto_filetype
    autocmd!
    autocmd BufRead,BufNewFile gitconfig  set filetype=gitconfig
    autocmd BufRead,BufNewFile *.gradle   set filetype=groovy
    autocmd BufRead,BufNewFile *.sc       set filetype=scala
    autocmd BufRead,BufNewFile *Pipfile*  set filetype=toml
    autocmd BufRead,BufNewFile *.py       set foldmethod=indent foldlevel=1 expandtab
    autocmd BufRead,BufNewFile *.vim      set foldmethod=indent foldlevel=1 expandtab
    autocmd BufRead,BufNewFile Makefile*  setlocal list tabstop=8 noexpandtab
    " arc diff buffers
    autocmd BufRead,BufNewFile differential-*,*-commit*,*commit-* set filetype=gitcommit
    " http://vim.wikia.com/wiki/Dictionary_completions
    " https://unix.stackexchange.com/questions/88976/vim-autocomplete-to-include-punctuation-between-words
    " :help i_CTRL-X_CTRL-K
    autocmd FileType gitcommit execute 'setlocal dictionary=' . globpath(&runtimepath,'words/' . &filetype . '.txt')
  augroup end

  " by default disable fold, zi to toggle foldenable
  :set nofoldenable

  " move away from a buffer does not have to save it first
  :set hidden

  " https://unix.stackexchange.com/questions/139578/copy-paste-for-vim-is-not-working-when-mouse-set-mouse-a-is-on
  :set mouse=r

  :set tabstop=8 softtabstop=4 shiftwidth=2

  " Really, just use :Rg
  :set grepprg=rg\ --vimgrep

  let g:java_highlight_java = 1

  " https://github.com/mtth/scratch.vim
  let g:scratch_autohide = 0
  let g:scratch_persistence_file = '~/tmp/vim_scratch.txt'

  ":help jedi-vim
  " https://github.com/davidhalter/jedi-vim/issues/567, option to disable autocompletion/auto-typing of "import" keyword
  let g:jedi#smart_auto_mappings = 0
  let g:jedi#auto_vim_configuration = 0
endf

" ------------------------------------------------------------------------------

func! myspacevim#after() abort
  " yank to clipboard
  " https://stackoverflow.com/questions/30691466/what-is-difference-between-vims-clipboard-unnamed-and-unnamedplus-settings
  " http://www.markcampbell.me/2016/04/12/setting-up-yank-to-clipboard-on-a-mac-with-vim.html
  if has('clipboard')
    set clipboard^=unnamed  " copy to the system clipboard
    let s:clipboard_register = '*'
  endif

  if has('unnamedplus')
    set clipboard^=unnamedplus
    let s:clipboard_register = '+'
  endif

  command! GitRepoUrl :call GitRepoUrl()
  nnoremap <Leader>l :call GitRepoUrl()<CR>
  nnoremap <Leader>o :execute ':OpenBrowser '.GitRepoUrl()<CR>

  nnoremap <Leader>e :call FzyCommand("rg --files", ":e")<CR>
  nnoremap <Leader>v :call FzyCommand("rg --files", ":vs")<CR>
  nnoremap <Leader>s :call FzyCommand("rg --files", ":sp")<CR>

  " :edit with "I'm feeling lucky"
  command! -nargs=1 E :call FuzzyEdit(<f-args>)

  noreabbrev Outline FzfOutline
  noreabbrev Messages FzfMessages

  " scala/scalac do not understand ammonite scripts
  " scalastyle needs a configuration file
  " https://github.com/w0rp/ale/blob/master/doc/ale-scala.txt
  " so disable all...
  let g:neomake_scala_enabled_makers = []

  " https://github.com/w0rp/ale#faq-disable-linters
  let g:ale_linters = {
        \   'python': ['pycodestyle', 'mypy', 'pyflakes'],
        \}
  let g:ale_linters_explicit = 1

  let g:ale_fixers = {
        \   '*': ['remove_trailing_lines', 'trim_whitespace'],
        \   'python': ['black', 'isort'],
        \}
  let g:ale_fix_on_save = 1

  let g:ale_python_mypy_options = '--ignore-missing-imports'
  " Don't want to install tools everywhere. if 1, from ALEInfo, it will do something like `pipenv run black ...`
  let g:ale_python_auto_pipenv = 0
  let g:ale_python_mypy_ignore_invalid_syntax = 1

  " https://stackoverflow.com/questions/24931088/disable-omnicomplete-or-ftplugin-or-something-in-vim
  ":help ft-sql
  let g:omni_sql_no_default_maps = 1

  " https://github.com/ambv/black#editor-integration
  " :Black
  let g:black_skip_string_normalization = 1
  let g:black_linelength = 120

  " https://github.com/Chiel92/vim-autoformat
  " :Autoformat
  let g:formatters_python = ['black']
  let g:formatdef_black = '"black --line-length=120 --skip-string-normalization --quiet -"'

  let g:autoformat_retab = 0
  let g:autoformat_remove_trailing_spaces = 1
  let g:autoformat_verbosemode = 0

  " https://github.com/sbdchd/neoformat
  " :Neoformat
  let g:neoformat_enabled_python = ['black', 'isort', 'docformatter']
  let g:neoformat_java_googlefmt = {
        \ 'exe': 'java',
        \ 'args': ['-jar', '~/.local/bin/google-java-format.jar', '-'],
        \ 'stdin': 1,
        \ }
  let g:neoformat_enabled_java = ['googlefmt']
  let g:neoformat_run_all_formatters = 1
  let g:neoformat_verbose = 0

  " http://vimdoc.sourceforge.net/htmldoc/cmdline.html#cmdline-completion
  set wildmode=longest,list:full

  ":set colorcolumn=120
  ":help highlight
  ":help highlight-groups
  ":highlight ColorColumn ctermbg=lightgrey guibg=lightgrey
  ":highlight Normal guibg=black
  ":highlight CursorLine guibg=black cterm=NONE
  ":highlight EndOfBuffer guibg=black cterm=NONE
endf

"-------------------------------------------------------------------------------
let s:repo_sep = {
      \ 'github.com': 'blob',
      \ 'bitbucket.org': 'src',
      \ }
let s:repo_linenum = {
      \ 'github.com': '#L',
      \ 'bitbucket.org': '#lines-',
      \}

function GitRepoUrl()
  let cmd = 'git rev-parse --symbolic-full-name --abbrev-ref @{u}'
  let arr = systemlist(cmd)
  if v:shell_error
    echom 'error find tracking remote branch. cmd=`' . cmd . '`'
    return
  endif
  let arr = split(arr[0], '/')  "origin/master
  let remote = arr[0]
  let branch = arr[1]

  let cmd = 'git ls-files --full-name ' . expand('%')
  let arr = systemlist(cmd)
  if v:shell_error || empty(arr)
    echom 'current file not in repo? cmd=`' . cmd . '`'
    return
  endif
  let filepath = arr[0]  "SpaceVim.d/autoload/myspacevim.vim

  let cmd = 'git config --get remote.' . remote . '.url'
  let arr = systemlist(cmd)
  " https://dyno@bitbucket.org/dyno/sweathome.git
  " https://github.com/dyno/sweathome.git
  " git@github.com:dyno/sweathome.git
  let arr = matchlist(arr[0], '\(.\{-}://\)\?\(.\{-}@\)\?\([^:/]*\)[:/]\(.*\)\.git')
  let host = arr[3]  "github.com
  let repo = arr[4]  "dyno/sweathome

  " https://github.com/dyno/sweathome/blob/master/SpaceVim.d/autoload/myspacevim.vim#L237
  let url = 'https://' . host . '/'. repo . '/' . s:repo_sep[host] . '/' . branch . '/' . filepath . s:repo_linenum[host] . line('.')

  call setreg(s:clipboard_register, url)
  return url
endfunction

"-------------------------------------------------------------------------------

" https://github.com/jhawthorn/fzy
function FzyCommand(choice_command, vim_command)
  try
    let output = system(a:choice_command . ' | fzy ')
  catch /Vim:Interrupt/
    " Swallow errors from ^C, allow redraw! below
  endtry
  redraw!
  if v:shell_error == 0 && !empty(output)
    execute a:vim_command . ' ' . output
  endif
endfunction

"-------------------------------------------------------------------------------

function FuzzyEdit(fuzzy_query)
  let cmd = 'rg --files | fzf -f "' . a:fuzzy_query . '"'
  let output = systemlist(cmd)
  if v:shell_error == 0 && !empty(output)
    execute ':edit ' . output[0]
  else
    echom 'something wrong... please check `' . cmd . '`'
  endif
endfunction
