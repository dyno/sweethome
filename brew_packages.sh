#!/usr/bin/env bash

set -o errexit

brew install openssl readline zlib xz
brew install bash coreutils moreutils
brew install git curl
brew install vim neovim
brew global cscope remake fzf fzy
brew install ripgrep the_silver_searcher jq
