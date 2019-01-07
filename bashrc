# .bashrc

#for interactive shell only
#[ -z "${PS1}" ] && return

#######################################################################
if [[ "${SHELL}" =~ bash ]]; then
  # Source global definitions
  if [ -f /etc/bashrc ]; then
    . /etc/bashrc
  fi

  # ubuntu
  if [ -f /etc/bash.bashrc ]; then
    . /etc/bash.bashrc
  fi

  #----------------------------------------------------------------------
  if [[ "${USER}" == "root" ]]; then
    PS1='[\u@\h: \W]# '
  else
    PS1='[\u@\h: \W]$ '
  fi
fi # end of if is bash

#----------------------------------------------------------------------
for pth in ${HOME}/bin ${HOME}/.local/bin \
  /usr/local/bin /usr/local/sbin \
  /usr/bin /usr/sbin \
  /bin /sbin; do
  if ! echo ":${PATH}:" | grep -q ":${pth}:"; then
    PATH=${PATH}:${pth}
  fi
done

export PATH

#----------------------------------------------------------------------
# user specific aliases and functions
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias vi=vim
if [[ "${OSTYPE}" =~ "darwin" ]]; then
  alias ls='ls -G'
elif [[ "${OSTYPE}" =~ "linux" ]]; then
  alias ls='ls --color --ignore=*.pyc '
fi

# https://stackoverflow.com/questions/7131670/make-a-bash-alias-that-takes-a-parameter
# vim edit with 'I am feeling lucky' search.
function lucky_vim() {
  nvim $(rg --files | fzf -f "$@" | head -n 1)
}

alias lv=lucky_vim
alias lvi=lucky_vim
alias lvim=lucky_vim
alias fvim=lucky_vim

#----------------------------------------------------------------------
export EDITOR=vim

#----------------------------------------------------------------------
if [[ -d ${HOME}/env.d ]]; then
  for _env in ${HOME}/env.d/*.env; do
    source ${_env}
  done
fi

#----------------------------------------------------------------------
