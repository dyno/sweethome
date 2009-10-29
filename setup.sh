#!/bin/bash
cd $(dirname $0)
BASEDIR=$PWD
cd - &>/dev/null

set -x

[ -d ~/env.d ] && rm -f ~/env.d
ln -sf ${BASEDIR}/env.d ~/env.d
ln -sf ${BASEDIR}/bashrc ~/.bashrc

[ -d ~/.vim ] && rm -f ~/.vim
ln -sf ${BASEDIR}/vim ~/.vim
ln -sf ${BASEDIR}/vimrc ~/.vimrc
