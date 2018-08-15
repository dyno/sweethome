#!/bin/bash

cd $(dirname $0)
BASEDIR=$PWD
cd - &>/dev/null

set -x

# Bash
[ ! -e ~/env.d -o -L ~/env.d ] && ln -sf ${BASEDIR}/env.d ~/

if [ $(uname) == "Linux" ]; then
    ln -sf ${BASEDIR}/bashrc ~/.bashrc
    [ $TERM == "linux" ] && ln -sf ${BASEDIR}/keymap ~/.keymap

elif [ "$(uname)" == "Darwin" ]; then
    ln -sf ${BASEDIR}/bashrc ~/.bash_profile
fi

# Vim
[ ! -e ~/.vim -o -L ~/.vim ] && rm -f ~/.vim && ln -sf ${BASEDIR}/vim ~/.vim
[ ! -e ~/.vimrc -o -L ~/.vimrc ] && rm -f ~/.vimrc && ln -sf ${BASEDIR}/vimrc ~/.vimrc

# SSH
[ -d ~/.ssh ] && ln -sf ${BASEDIR}/ssh_config ~/.ssh/config && chmod 600 ~/.ssh/config

# ammonite
[ ! -e ~/.ammonite -o -L ~/.ammonite ] && rm -f ~/.ammonite && ln -sf ${BASEDIR}/ammonite ~/.ammonite
