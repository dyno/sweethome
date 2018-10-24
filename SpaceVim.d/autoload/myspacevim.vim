" https://spacevim.org/documentation/#bootstrap-functions

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
  let g:rooter_patterns = ['Pipfile', '.git/']

endf


func! myspacevim#after() abort

  :set colorcolumn=120
  ":help highlight
  ":help highlight-groups
  :highlight ColorColumn ctermbg=lightgrey guibg=lightgrey
  ":highlight Normal guibg=black
  ":highlight CursorLine guibg=black cterm=NONE
  ":highlight EndOfBuffer guibg=black cterm=NONE
  
  :set norelativenumber

endf
