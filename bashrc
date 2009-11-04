# .bashrc

#for interactive shell only
#[ -z "$PS1" ] && return

#----------------------------------------------------------------------
pathmunge () {
    if ! echo $PATH | /bin/egrep -q "(^|:)$1($|:)" ; then
        if [ "$2" = "after" ] ; then
            PATH=$PATH:$1
        else
            PATH=$1:$PATH
        fi
    fi
}


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
    pathmunge $path
done

#----------------------------------------------------------------------
PS1='[\u@\h:\W]$ '

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

#----------------------------------------------------------------------
export EDITOR=vim

#----------------------------------------------------------------------
if [[ -d $HOME/env.d ]]; then
    for _env in $HOME/env.d/*.env; do 
        . $_env
    done
fi

