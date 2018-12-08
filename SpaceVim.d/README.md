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
  - GscopeFind g TeamIdModule [gutentags_plus]
  - Gtags TeamIdModule [gtags.vim]
  - Tags TeamIdModule [fzf.vim]
  - tag TeamIdModule [tagsrch.txt]

* How to find all reference of this function?
  - [SPC]mgr [SpaceVim]
  - GscopeFind c withFeatureFilter [gutentags_plus]
  - Gtags -r withFeatureFilter
  - Rg

* How to find all the sourced vimscript?
  - :redir @a
    :scriptnames
    :redir END
    "ap

* Interesting fuzzy find commands
  - BLines
  - BTags
  - Commands
  - Denite change
  - Denite colorscheme
  - Denite menu - AddedPlugins, StatusCodeDefinitions, CustomKeyMaps ...
  - FzfFiles/Files
  - FzfMessages
  - FzfOutline
  - FzfRegisters
  - GFiles
  - GFiles?
  - FzfHelpTags/Helptags
  - History:
  - Lines
  - Tags

## Reference

* https://github.com/junegunn/fzf.vim#commands
* http://vim.wikia.com/wiki/Browsing_programs_with_tags
