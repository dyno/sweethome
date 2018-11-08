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

  " https://github.com/ludovicchabant/vim-gutentags
  " used by layer:tags
  let g:gutentags_trace = 0
  let g:gutentags_project_root = ['.git', 'Pipfile', '.project']
  let g:gutentags_generate_on_missing = 0
  " produce tags file in project directory
  let g:gutentags_cache_dir = ''

  " https://github.com/prabirshrestha/vim-lsp
  let g:lsp_log_verbose = 0
  let g:lsp_log_file = expand('~/tmp/vim-lsp.log')

  " https://stackoverflow.com/questions/24931088/disable-omnicomplete-or-ftplugin-or-something-in-vim
  ":help ft-sql
  let g:omni_sql_no_default_maps = 1

  augroup auto_filetype
    autocmd!
    autocmd BufRead,BufNewFile gitconfig  set filetype=gitconfig
    autocmd BufRead,BufNewFile *.gradle   set filetype=groovy
    autocmd BufRead,BufNewFile *.sc       set filetype=scala
    autocmd BufRead,BufNewFile Pipfile    set filetype=conf
    autocmd BufRead,BufNewFile *.py       set foldmethod=indent foldlevel=1
    autocmd BufRead,BufNewFile *.vim      set foldmethod=indent foldlevel=1
  augroup end

  " by default disable fold, zi to toggle foldenable
  :set nofoldenable

  :set hidden

  " https://unix.stackexchange.com/questions/139578/copy-paste-for-vim-is-not-working-when-mouse-set-mouse-a-is-on
  :set mouse=r
  " https://stackoverflow.com/questions/30691466/what-is-difference-between-vims-clipboard-unnamed-and-unnamedplus-settings
  :set clipboard^=unnamedplus
endf


func! myspacevim#after() abort

  "":set colorcolumn=120
  ":help highlight
  ":help highlight-groups
  "":highlight ColorColumn ctermbg=lightgrey guibg=lightgrey
  ":highlight Normal guibg=black
  ":highlight CursorLine guibg=black cterm=NONE
  ":highlight EndOfBuffer guibg=black cterm=NONE

endf
