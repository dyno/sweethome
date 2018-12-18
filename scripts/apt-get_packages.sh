#!/bin/bash

# set -o xtrace
set -o errexit

# fix some installation problems (on Deepin 15.7), might be temporary
sudo apt-get install --yes console-setup plymouth-themes plymouth-label

sudo apt-get install --yes synaptic
sudo apt-get install --yes openssh-server
sudo apt-get install --yes docker.io docker-compose

sudo apt-get install --yes curl git moreutils
sudo apt-get install --yes vim-gnome neovim xclip # +python3 +clipboard
sudo apt-get install --yes remake cscope global universal-ctags ripgrep fzy
sudo apt-get install --yes astyle uncrustify

sudo apt-get install --yes python3 python3-pip python3-jedi
sudo apt-get install --yes golang

# pyenv - build python dependencies
sudo apt-get install --yes libsqlite3-dev libssl-dev libreadline-dev zlib1g-dev libbz2-dev

# arc - code review
sudo apt-get install --yes php php-curl

# neovim, https://github.com/neovim/neovim/wiki/Installing-Neovim
# e.g. sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get install software-properties-common python-software-properties
# https://unix.stackexchange.com/questions/75807/no-public-key-available-on-apt-get-update
# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 55F96FCF8231B6DD
