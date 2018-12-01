## FAQ

* How to fuzzy find a file?
  - [SPC]pf [SpaceVim]
  - Files [fzf.vim]
  - GFiles [fzf.vim]
  - FZF [fzf]
  - Denite/Unite file_rec
  - PickerEdit [vim-picker]

* How to find tags?
  - Ctrl+]
  - :tags/tselect/tjump
  - GscopeFind g TeamIdModule [gutentags_plus]
  - Tags [fzf.vim]

* How to find all reference of this function?
  - [SPC]mgr [SpaceVim]
  - GscopeFind c withFeatureFilter [gutentags_plus]
  - Rg

* How to find all the sourced vimscript?
  - :redir @a
    :scriptnames
    :redir END
    "ap

## Reference

* http://vim.wikia.com/wiki/Browsing_programs_with_tags

