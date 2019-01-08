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
# FZF_DEFAULT_COMMAND, https://github.com/junegunn/fzf
function fuzzy_vim() {
  nvim $(rg --files | fzf -f "$@" | head -n 1)
}
alias fzvim=fuzzy_vim
alias fzvi=fuzzy_vim

function fuzzy_run() {
  # https://stackoverflow.com/questions/8247433/remove-the-last-element-from-an-array
  args=( "$@" )
  query="${args[${#args[@]}-1]}"
  unset args[${#args[@]}-1]
  cmd="${args[@]}"

  $cmd $(fzf -f "$query" | head -n 1)
}
alias fz=fuzzy_run

#----------------------------------------------------------------------
export EDITOR=vim

#----------------------------------------------------------------------
if [[ -d ${HOME}/env.d ]]; then
  for _env in ${HOME}/env.d/*.env; do
    source ${_env}
  done
fi

#----------------------------------------------------------------------
