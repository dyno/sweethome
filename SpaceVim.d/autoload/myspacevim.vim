" https://spacevim.org/documentation/#bootstrap-functions
" https://spacevim.org/conventions/

func! myspacevim#before() abort

  " https://github.com/ambv/black#editor-integration
  let g:black_skip_string_normalization = 1
  let g:black_linelength = 120

  " https://github.com/Chiel92/vim-autoformat
  let g:formatters_python = ['black']
  let g:formatdef_black = '"black --line-length=120 --skip-string-normalization --quiet -"'

  let g:autoformat_retab = 0
  let g:autoformat_remove_trailing_spaces = 1
  let g:autoformat_verbosemode = 0

  " https://github.com/airblade/vim-rooter
  let g:rooter_change_directory_for_non_project_files = 'current'

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
    let g:gutentags_ctags_exclude = ['build', '.venv', 'zold', 'output', '.git', '.eggs', '*.egg-info']
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

  " scala/scalac do not understand ammonite scripts
  " scalastyle needs a configuration file
  " https://github.com/w0rp/ale/blob/master/doc/ale-scala.txt
  " so disable all...
  let g:neomake_scala_enabled_makers = []

  " https://stackoverflow.com/questions/24931088/disable-omnicomplete-or-ftplugin-or-something-in-vim
  ":help ft-sql
  let g:omni_sql_no_default_maps = 1

  "
  if has('macunix')
    let g:python3_host_prog = '/usr/local/bin/python3'
  elseif has('unix')
    let g:python3_host_prog = '/usr/bin/python3'
  endif

  augroup auto_filetype
    autocmd!
    autocmd BufRead,BufNewFile gitconfig  set filetype=gitconfig
    autocmd BufRead,BufNewFile *.gradle   set filetype=groovy
    autocmd BufRead,BufNewFile *.sc       set filetype=scala
    autocmd BufRead,BufNewFile Pipfile    set filetype=toml
    autocmd BufRead,BufNewFile *.py       set foldmethod=indent foldlevel=1 expandtab
    autocmd BufRead,BufNewFile *.vim      set foldmethod=indent foldlevel=1 expandtab
    autocmd BufRead,BufNewFile Makefile*  setlocal list tabstop=8 noexpandtab

    " arc diff buffers
    autocmd BufRead,BufNewFile differential-update-comment*,new-commit*,differential-edit-revision-info set filetype=gitcommit
    " http://vim.wikia.com/wiki/Dictionary_completions
    " https://unix.stackexchange.com/questions/88976/vim-autocomplete-to-include-punctuation-between-words
    autocmd FileType gitcommit execute 'setlocal complete+=k'.globpath(&runtimepath,'words/'.&filetype.'.txt').' iskeyword+=. complete-=t ignorecase'
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
endf

func! myspacevim#after() abort
  " yank to clipboard
  " https://stackoverflow.com/questions/30691466/what-is-difference-between-vims-clipboard-unnamed-and-unnamedplus-settings
  " http://www.markcampbell.me/2016/04/12/setting-up-yank-to-clipboard-on-a-mac-with-vim.html
  if has('clipboard')       " mac
    set clipboard^=unnamed  " copy to the system clipboard
    if has('unnamedplus')   " X11 support
      set clipboard^=unnamedplus
    endif
  endif

  nnoremap <leader>e :call FzyCommand("rg --files", ":e")<cr>
  nnoremap <leader>v :call FzyCommand("rg --files", ":vs")<cr>
  nnoremap <leader>s :call FzyCommand("rg --files", ":sp")<cr>

  " https://github.com/w0rp/ale#faq-disable-linters
  let g:ale_linters = {
        \   'python': ['black', 'isort', 'mypy', 'pyflakes'],
        \}
  let g:ale_linters_explicit = 1

  let g:ale_fixers = {
        \   '*': ['remove_trailing_lines', 'trim_whitespace'],
        \}
  let g:ale_fix_on_save = 1

  noreabbrev Outline FzfOutline
  noreabbrev Messages FzfMessages

  command! Gcp :let @*='https://github.com/dyno/sweathome/tree/master/'.(systemlist('git ls-files --full-name '.expand('%'))[0]).'#L'.(line('.')+1)

  "":set colorcolumn=120
  ":help highlight
  ":help highlight-groups
  "":highlight ColorColumn ctermbg=lightgrey guibg=lightgrey
  ":highlight Normal guibg=black
  ":highlight CursorLine guibg=black cterm=NONE
  ":highlight EndOfBuffer guibg=black cterm=NONE
endf

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
    exec a:vim_command . ' ' . output
  endif
endfunction
