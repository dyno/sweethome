" https://spacevim.org/documentation/#bootstrap-functions
" https://spacevim.org/conventions/

" ------------------------------------------------------------------------------

" https://stackoverflow.com/questions/18321538/vim-error-e474-invalid-argument-listchars-tab-trail
set encoding=utf-8
scriptencoding utf-8

func! myspacevim#before() abort
  " > The bootstrap_before will be called after custom configuration file is loaded.
  " https://spacevim.org/documentation/#bootstrap-functions

  if v:version >= 800
    " https://github.com/ludovicchabant/vim-gutentags
    " https://github.com/skywind3000/gutentags_plus
    let g:gutentags_define_advanced_commands = 1
    let g:gutentags_trace = 1

    let g:gutentags_file_list_command = {
      \   'markers': {
      \   '.git': 'git ls-files',
      \   },
      \ }

    " > Error detected while processing function <SNR>270_nvim_job_exit_wrapper[1]..gutentags#ctags#on_job_exit[1]..gutentags#remove_job_by_data[2]..gutentags#remove_job:
    " It's like kill ctags takes time... disable auto update.
    " with these flag set to 0, have to run :GutentagsUpdate manually.
    let g:gutentags_generate_on_missing = 0
    let g:gutentags_generate_on_new = 0
    let g:gutentags_generate_on_write = 0

    " https://github.com/liuchengxu/space-vim/blob/master/core/autoload/spacevim/autocmd/gutentags.vim
    " generate in project directory so that tags layer and GscopeFind
    " (gutentags_plus) can share the same tags file.
    let g:gutentags_cache_dir = ''

    " https://github.com/ludovicchabant/vim-gutentags/issues/168
    let g:gutentags_exclude_filetypes = ['yaml', 'markdown', 'toml', 'text', 'javascript']

    "https://www.jianshu.com/p/110b27f8361b
    let g:gutentags_modules = []

    " https://stackoverflow.com/questions/12922526/tags-for-emacs-relationship-between-etags-ebrowse-cscope-gnu-global-and-exub
    " XXX: prefer ctags over gtags for better integration with other plugins, e.g. vim-preview, etc.
    " XXX: there is no exclude option, try g:gutentags_gtags_options_file?
    if executable('ctags')
      let g:gutentags_modules += ['ctags']
      let g:gutentags_ctags_tagfile = 'tags'
      let g:gutentags_ctags_exclude_wildignore = 1
      " https://github.com/universal-ctags/ctags/issues/759, How to exclude a directory specified with parent dirs?
      let g:gutentags_ctags_exclude = [
          \ '*build/*', '*.venv/*', '*tmp/*', '*zold/*', '*output/*', '*workspace/*', '*target/*', '*classes/*', '*mecha/*',
          \ '.git', '.svn', '.hg',
          \ '.eggs', '.cache*', '*_cache', '*.egg-info',
          \ '*.tar.*', '*.gz', '*.zip',
          \ '*.txt', '*.md', '*.markdown', '*.csv', '*.js',
          \ 'x.*', 'y.*', 'z.*', 'a.*', 'b.*', 'c.*'
          \]
    endif

    if executable('gtags-cscope') && executable('gtags')
      let g:gutentags_modules += ['gtags_cscope']
      " GscopeAdd; cs show
      let g:gutentags_auto_add_gtags_cscope = 1
      " https://github.com/skywind3000/gutentags_plus#configuration
      let g:gutentags_plus_switch = 1
      " https://stackoverflow.com/questions/28475573/can-gtags-navigate-back
      set cscopetag
      " https://stackoverflow.com/questions/42315741/how-gtags-exclude-some-specific-subdirectories
      " edit ~/.globalrc to exclude files
    endif
  endif

  " https://github.com/prabirshrestha/vim-lsp
  let g:lsp_log_verbose = 0
  let g:lsp_log_file = expand('~/tmp/vim-lsp.log')

  if has('macunix')
    let g:python3_host_prog = '/usr/local/bin/python3'
  elseif has('unix')
    let g:python3_host_prog = '/usr/bin/python3'
  endif

  let output = systemlist('pyenv which python3')
  if v:shell_error == 0 && !empty(output)
    let g:python3_host_prog = output[0]
  endif

  " https://github.com/vim/vim/issues/3707, compiled python should not set `sys.executable` to vim
  if has('python3_compiled') && has('macunix') && v:version >= 800
    :py3 import os; sys.executable = os.path.join(sys.exec_prefix, 'bin/python3')
  endif

  " by default disable fold, zi to toggle foldenable
  :set nofoldenable

  " move away from a buffer does not have to save it first
  :set hidden

  " https://unix.stackexchange.com/questions/139578/copy-paste-for-vim-is-not-working-when-mouse-set-mouse-a-is-on
  :set mouse=nvi

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

  " https://github.com/w0rp/ale#faq-disable-linters
  let g:ale_linters = {
        \   'java': ['arc'],
        \   'python': ['flake8'],
        \   'sh': ['shellcheck'],
        \}
  let g:ale_linters_explicit = 1

  let g:ale_fixers = {
        \   '*': ['remove_trailing_lines', 'trim_whitespace'],
        \   'python': ['black', 'isort'],
        \   'sh': ['shfmt'],
        \}
  let g:ale_fix_on_save = 1

  let g:ale_python_mypy_options = '--ignore-missing-imports'
  " Don't want to install tools everywhere. if 1, from ALEInfo, it will do something like `pipenv run black ...`
  let g:ale_python_auto_pipenv = 0
  let g:ale_python_mypy_ignore_invalid_syntax = 1
  let g:ale_python_pylint_options = '--max-line-length=120'

  " https://github.com/tomasr/molokai/issues/74, MatchParen highlighting makes it look like cursor jumped to matching parenthesis
  " : help DoMatchParen
  augroup matchup_matchparen_highlight
    autocmd!
    autocmd ColorScheme * hi MatchParen cterm=NONE,bold gui=NONE,bold guibg=bg guifg=lightblue ctermbg=bg ctermfg=lightblue
    autocmd BufReadPost,BufNewFile * hi MatchParen cterm=NONE,bold gui=NONE,bold guibg=bg guifg=lightblue ctermbg=bg ctermfg=lightblue
  augroup END

endf

" ------------------------------------------------------------------------------

func! myspacevim#after() abort
  " > And the bootstrap_after will be called after Vim Enter autocmd.
  " https://spacevim.org/documentation/#bootstrap-functions

  " https://github.com/luochen1990/rainbow
  let g:rainbow_active = 1

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
  " :edit with "I'm feeling lucky"
  command! -nargs=1 E :call FuzzyEdit(<f-args>)

  nnoremap <Leader>s :Clap files<CR>
  nnoremap <Leader>l :call GitRepoUrl()<CR>
  nnoremap <Leader>o :execute ':OpenBrowser '.GitRepoUrl()<CR>
  nmap <leader>h :call <SID>SynStack()<CR>

  noreabbrev Outline FzfOutline
  noreabbrev Messages FzfMessages

  " https://www.bugsnag.com/blog/tmux-and-vim
  " http://kana.github.io/config/vim/arpeggio.html
  Arpeggio inoremap jk <ESC>:VimuxPromptCommand<CR>
  Arpeggio nnoremap jk :VimuxPromptCommand<CR>
  map <Leader>vi :VimuxInspectRunner<CR>
  map <Leader>vz :VimuxZoomRunner<CR>
  " https://github.com/benmills/vimux/blob/master/plugin/vimux.vim#L35
  " Always run vimux in pane 2 - the REPL pane.
  let g:VimuxRunnerIndex = 2

  " scala/scalac do not understand ammonite scripts
  " scalastyle needs a configuration file
  " https://github.com/w0rp/ale/blob/master/doc/ale-scala.txt
  " so disable all...
  let g:neomake_scala_enabled_makers = []

  " https://stackoverflow.com/questions/24931088/disable-omnicomplete-or-ftplugin-or-something-in-vim
  ":help ft-sql
  let g:omni_sql_no_default_maps = 1

  " https://github.com/ambv/black#editor-integration
  " :Black
  let g:black_skip_string_normalization = 1
  let g:black_linelength = 120

  " https://github.com/sbdchd/neoformat
  " :Neoformat
  let g:neoformat_sql_sqlformat = {
        \ 'exe': 'sqlformat',
        \ 'args': ['--reindent', '--keywords', 'upper', '-'],
        \ 'stdin': 1,
        \ }
  let g:neoformat_enabled_sql = ['sqlformat']

  let g:neoformat_enabled_python = ['black', 'isort', 'docformatter']

  let g:neoformat_java_googlefmt = {
        \ 'exe': 'java',
        \ 'args': ['-jar', '~/.local/bin/google-java-format.jar', '-'],
        \ 'stdin': 1,
        \ }
  let g:neoformat_enabled_java = ['googlefmt']

  let g:neoformat_scala_scalafmt = {
        \ 'exe': 'scalafmt',
        \ 'args': ['--stdin', '--assume-filename=scala.sc', '--config=${HOME}/.scalafmt.conf'],
        \ 'stdin': 1,
        \ }
  let g:formatters_scala = ['scalafmt']
  let g:neoformat_enabled_scala = ['scalafmt']

  let g:neoformat_xml_tidy = {
        \ 'exe': 'tidy',
        \ 'args': ['-xml', '-wrap', 120, '--indent', 'auto', '--indent-spaces', 2, '--vertical-space', 'yes'],
        \ 'stdin': 1,
        \ }
  let g:neoformat_enabled_xml = ['tidy']

  let g:neoformat_run_all_formatters = 1
  let g:neoformat_verbose = 0

  " http://vimdoc.sourceforge.net/htmldoc/cmdline.html#cmdline-completion
  set wildmode=longest,list:full

  " Hack 11 on Linux looks like the same as 13 on Mac
  if has('gui_gtk3')
    set guifont=Hack\ 11
    set linespace=0
  endif
  if has('gui_macvim')
    set linespace=1
  endif
  set guioptions=agikmrt

  " https://github.com/janko/vim-test#strategies
  let g:test#strategy = 'dispatch'
  "let g:test#strategy = 'vimux'
  let g:test#preserve_screen = 1

  if exists(':Tabularize')
    "  Roman 1:16-2:30
    "  John  8:32,9:32
    "  Luke  10:10
    AddTabularPipeline! align_chapter /\d:/ tabular#TabularizeStrings(a:lines, ' \(\d\+:\)\@=', 'l0')

    " echo what ever       \
    "   | xargs -i echo {} \
    " # END
    AddTabularPipeline! align_continuation /\\$/ tabular#TabularizeStrings(a:lines, '\\$', 'l1')
  endif

  augroup auto_filetype
    autocmd!
    autocmd BufRead,BufNewFile gitconfig  set filetype=gitconfig
    autocmd BufRead,BufNewFile *.gradle   set filetype=groovy
    autocmd BufRead,BufNewFile *.sc       set filetype=scala
    autocmd BufRead,BufNewFile *Pipfile*  set filetype=toml
    autocmd BufRead,BufNewFile *.sqlt     set filetype=sql
    autocmd BufRead,BufNewFile *.hivet    set filetype=sql
    autocmd BufRead,BufNewFile *.py       set foldmethod=indent foldlevel=1 expandtab
    autocmd BufRead,BufNewFile *.vim      set foldmethod=indent foldlevel=1 expandtab
    autocmd BufRead,BufNewFile Makefile*,*.mk  setlocal listchars=tab:→\ ,trail:·,extends:↷,precedes:↶ filetype=make tabstop=8 noexpandtab list

    " arc diff buffers
    autocmd BufRead,BufNewFile differential-*,*-commit*,*commit-* set filetype=gitcommit
    " http://vim.wikia.com/wiki/Dictionary_completions
    " https://unix.stackexchange.com/questions/88976/vim-autocomplete-to-include-punctuation-between-words
    " :help i_CTRL-X_CTRL-K
    autocmd FileType gitcommit execute 'setlocal dictionary=' . globpath(&runtimepath,'words/' . &filetype . '.txt')
  augroup end

  " https://github.com/jpalardy/vim-slime
  let g:slime_target = "tmux"
  let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": ":.4"}
  let g:slime_python_ipython = 1
  " https://github.com/plasticboy/vim-markdown#options
  let g:vim_markdown_conceal = 0
  let g:vim_markdown_conceal_code_blocks = 0

  "let g:gutentags_add_default_project_roots = 1
  let g:gutentags_project_root += ['pyproject.toml']

  ":set cursorcolumn
  ":set colorcolumn=120
  ":help highlight
  ":help highlight-groups
  ":highlight ColorColumn ctermbg=lightgrey guibg=lightgrey
  ":highlight Normal guibg=black
  ":highlight CursorLine guibg=black cterm=NONE
  ":highlight EndOfBuffer guibg=black cterm=NONE
endf


"-------------------------------------------------------------------------------
" copied from https://jordanelver.co.uk/blog/2015/05/27/working-with-vim-colorschemes/
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

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
  " https://dyno@bitbucket.org/dyno/sweethome.git
  " https://github.com/dyno/sweethome.git
  " git@github.com:dyno/sweethome.git
  let arr = matchlist(arr[0], '\(.\{-}://\)\?\(.\{-}@\)\?\([^:/]*\)[:/]\(.*\)\.git')
  let host = arr[3]  "github.com
  let repo = arr[4]  "dyno/sweethome

  " https://github.com/dyno/sweethome/blob/master/SpaceVim.d/autoload/myspacevim.vim#L237
  let url = 'https://' . host . '/'. repo . '/' . get(s:repo_sep, host, 'blob') . '/' . branch . '/' . filepath . get(s:repo_linenum, host, '#L') . line('.')

  call setreg(s:clipboard_register, url)
  return url
endfunction

"-------------------------------------------------------------------------------

function FuzzyEdit(fuzzy_query)
  let cmd = 'rg --files 2>/dev/null | fzf -f "' . a:fuzzy_query . '"'
  let output = systemlist(cmd)
  if v:shell_error == 0 && !empty(output)
    execute ':edit ' . output[0]
  else
    echom 'something wrong... please check `' . cmd . '`'
  endif
endfunction
