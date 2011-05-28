#!/bin/bash
cd $(dirname $0)
BASEDIR=$PWD
cd - &>/dev/null

set -x

[ -d ~/env.d ] && rm -f ~/env.d
ln -sf ${BASEDIR}/env.d ~/env.d
if [ $(uname) == "Linux" ]; then
  ln -sf ${BASEDIR}/bashrc ~/.bashrc
  if [ $TERM == "linux" ]; then
    ln -sf ${BASEDIR}/keymap ~/.keymap
  fi
elif [ "$(uname)" == "Darwin" ]; then
  ln -sf ${BASEDIR}/bashrc ~/.bash_profile
else
  ln -sf ${BASEDIR}/bashrc ~/.bash_profile
fi

[ -d ~/.vim ] && rm -f ~/.vim
ln -sf ${BASEDIR}/vim ~/.vim
ln -sf ${BASEDIR}/vimrc ~/.vimrc

