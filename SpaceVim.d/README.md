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
  - Ag/Rg
  - BLines
  - BTags
  - Commands  => :command
  - Denite change
  - Denite colorscheme
  - Denite menu:AddedPlugins
  - Denite menu:CustomKeyMaps
  - Denite menu:StatusCodeDefinitions
  - Files/FzfFiles
  - FzfHelpTags/Helptags
  - FzfLocationList
  - FzfMessages
  - FzfOutline
  - FzfQuickfix
  - FzfRegisters
  - GFiles    => git ls-files
  - GFiles?   => git status
  - History   => :old-files
  - History:  => :history
  - Lines
  - Locate    => !locate
  - Tags

* Fuzzy search any command vim or system
  - Redir scriptnames
  - Redir !ps -ef | grep py
  - BLines

* Where is this command come from?
  - :Commands " find the function source
  - :func fzf#vim#history

## Reference

* https://github.com/junegunn/fzf.vim#commands
* http://vim.wikia.com/wiki/Browsing_programs_with_tags
* https://stackoverflow.com/questions/2960593/vimscript-how-to-get-the-current-list-of-user-defined-functions-and-determine-t
* https://vi.stackexchange.com/questions/11171/define-commands-programmatically
