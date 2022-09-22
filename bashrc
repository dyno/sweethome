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
    PS1='[\u@\h: \w]# '
  else
    PS1='[\u@\h: \w]$ '
  fi
fi # end of if is bash

#----------------------------------------------------------------------
for pth in \
  /opt/homebrew/bin \
  ${HOME}/bin \
  ${HOME}/.local/bin \
  ${HOME}/.cargo/bin \
  ${HOME}/.krew/bin \
; do
  if ! echo ":${PATH}:" | grep -q ":${pth}:"; then
    PATH=${PATH}:${pth}
  fi
done

if [[ -d ${HOME}/env.d ]]; then
  for _env in ${HOME}/env.d/*.env; do
    source ${_env}
  done
fi

# need to move these default path to the last, otherwise pyenv, sdkman etc
# won't work because their substituate alternative needs to take precedence
# in path search.
for pth in /usr/local/bin /usr/local/sbin /usr/bin /usr/sbin /bin /sbin; do
  if echo ":${PATH}:" | grep -q ":${pth}:"; then
    PATH=${PATH/:${pth}:/:}
  fi
  PATH=${PATH}:${pth}
done
export PATH

#----------------------------------------------------------------------
# user specific aliases and functions
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias nvim='nvim -u ~/.vim/vimrc'
# alias vi=nvim
# alias vim=nvim
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
  # https://stackoverflow.com/a/11217798/221794, Getting the last argument passed to a shell script
  cmd="${@:1:$#-1}"
  query="${@: -1}"

  $cmd $(fzf -f "$query" | head -n 1)
}
alias fz=fuzzy_run

#----------------------------------------------------------------------

export EDITOR=nvim
#----------------------------------------------------------------------

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

