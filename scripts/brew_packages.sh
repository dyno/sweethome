#!/usr/bin/env bash

function install_or_upgrade() {
  package=$1
  for package in "$@"; do
    echo "install or upgrade $package"
    # https://stackoverflow.com/questions/43619480/upgrade-or-install-a-homebrew-formula
    brew install "$package" 2>/dev/null || (brew upgrade "$package" && brew cleanup "$package")
  done
}

# set -o xtrace
set -o errexit

export HOMEBREW_NO_AUTO_UPDATE=1
brew update

install_or_upgrade bash bash-completion shellcheck coreutils moreutils tree
# python build dependencies
install_or_upgrade openssl readline zlib xz
install_or_upgrade git tig
install_or_upgrade macvim neovim
install_or_upgrade go
install_or_upgrade global cscope remake

# https://dev.to/_darrenburns/10-tools-to-power-up-your-command-line-4id4
install_or_upgrade z exa fd bat ncdu # cd ls find cat du

# http://docs.ctags.io/en/latest/osx.html
brew tap universal-ctags/universal-ctags
brew install --HEAD universal-ctags 2>/dev/null || true

# ripgrep => rg; the_silver_searcher => ag
install_or_upgrade ripgrep the_silver_searcher
install_or_upgrade jq gron fpp
install_or_upgrade astyle uncrustify
