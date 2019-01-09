#!/bin/bash

# set -o xtrace
set -o errexit

# XXX: fix some installation problems (on Deepin 15.7), might be temporary
sudo apt install --yes console-setup plymouth-themes plymouth-label

sudo apt install --yes synaptic
sudo apt install --yes openssh-server
sudo apt install --yes docker.io docker-compose

sudo apt install --yes curl git tig moreutils
sudo apt install --yes vim-gnome neovim xclip # +python3 +clipboard
sudo apt install --yes remake cscope global universal-ctags ripgrep fzy silversearcher-ag
sudo apt install --yes astyle uncrustify

sudo apt install --yes python3 python3-pip python3-jedi
sudo apt install --yes golang

# pyenv - build python dependencies
sudo apt install --yes libbz2-dev libffi-dev libreadline-dev libsqlite3-dev libssl-dev zlib1g-dev
sudo apt install --yes libev-dev

# arc - code review
sudo apt install --yes php php-curl

# neovim, https://github.com/neovim/neovim/wiki/Installing-Neovim
# e.g. sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt install software-properties-common python-software-properties
# https://unix.stackexchange.com/questions/75807/no-public-key-available-on-apt-get-update
# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 55F96FCF8231B6DD
