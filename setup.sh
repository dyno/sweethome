#!/usr/bin/env bash

cd $(dirname $0)
BASEDIR=$PWD
cd - &>/dev/null

set -x

check_and_remove_link() {
  target="$1"
  [ ! -e "$target" -o -L "$target" ] && rm -f "$target"
}

# Bash
check_and_remove_link ~/env.d && ln -sf ${BASEDIR}/env.d ~/

if [ $(uname) = "Linux" ]; then
  ln -sf ${BASEDIR}/bashrc ~/.bashrc
  [ "${TERM}" = "linux" ] && ln -sf ${BASEDIR}/keymap ~/.keymap

elif [ "$(uname)" = "Darwin" ]; then
  ln -sf ${BASEDIR}/bashrc ~/.bash_profile
fi

# Vim/SpaceVim
[ ! -e ~/.SpaceVim ] && curl -sLf https://spacevim.org/install.sh | bash
check_and_remove_link ~/.vim
[ ! -e ~/.vim ] && ln -sf ~/.SpaceVim ~/.vim
check_and_remove_link ~/.vimrc
check_and_remove_link ~/.gvimrc && ln -sf ${BASEDIR}/gvimrc ~/.gvimrc
check_and_remove_link ~/.SpaceVim.d && ln -sf ${BASEDIR}/SpaceVim.d ~/.SpaceVim.d
check_and_remove_link ~/.SpaceVim.d/after && ln -sf ${BASEDIR}/vim/after ~/.SpaceVim.d/

# SSH
[ -d ~/.ssh ] && ln -sf ${BASEDIR}/ssh_config ~/.ssh/config && chmod 600 ~/.ssh/config

