# .bashrc

#for interactive shell only
#[ -z "$PS1" ] && return

#######################################################################

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# ubuntu
if [ -f /etc/bash.bashrc ]; then
    . /etc/bash.bashrc
fi

#----------------------------------------------------------------------
for path in /bin /usr/bin /usr/local/bin /sbin /usr/sbin/ /usr/local/sbin \
    $HOME/bin $HOME/usr/bin \
    /build/apps/bin /build/trees/bin
do
    if ! grep -q ":$path:" <<< ":$PATH:"; then
        PATH=$PATH:$path
    fi
done

#----------------------------------------------------------------------
if [ "`whoami`" == "root" ]; then
  PS1='[\u@\h:\W]# '
else
  PS1='[\u@\h:\W]$ '
fi
#----------------------------------------------------------------------
# history
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
shopt -s histappend
shopt -s checkwinsize

#Make sure all terminals save history
shopt -s histappend
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
 
#Increase history size
export HISTSIZE=1000
export HISTFILESIZE=1000
 
#----------------------------------------------------------------------
# User specific aliases and functions
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias vi=vim

if [ "$(uname)" == "Darwin" ];then
  alias ls='ls -G'
fi

#----------------------------------------------------------------------
export EDITOR=vim

#----------------------------------------------------------------------
if [[ -d $HOME/env.d ]]; then
    for _env in $HOME/env.d/*.env; do
        . $_env
    done
fi

