#!/bin/bash

# EDITOR
export EDITOR='vim'
export VISUAL='vim'

# PATH
#export PATH=~/.nodebrew/current/bin:$PATH
#export PATH=/usr/local/opt/openssl@1.1/bin:$PATH
export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
export PATH=~/.local/bin:$PATH
export PATH=/usr/local/bin:$PATH
#export PATH=~/Library/Python/3.7/bin:$PATH
#export PATH=~/Library/Python/3.7/lib/python/site-packages:$PATH
#export PATH=/Library/Frameworks/Python.framework/Versions/3.7/bin:$PATH
#export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PATH=/usr/lib/postgresql/11/bin:$PATH

# Prompt
export PROMPT_COMMAND='history -a; history -c; history -r ; _ps1_status;'

PRE_PROMPT_DATE=$(date "+%s")
function _ps1_status () {
if [[ $(date "+%s") -gt $PRE_PROMPT_DATE ]] ; then
    _pwd_status
    PRE_PROMPT_DATE=$(date --date '1 sec' "+%s")
    GIT_PS1=$(echo $(__git_ps1) | sed "s/master/mstr/" | tr -d "\(\) ")
    if [ -n "$GIT_PS1" ]; then
        P_S="("
        P_E=")"
        [ -n "`echo $GIT_PS1 | grep mstr`" ] && GIT_CLR=$(tput setaf 1 && tput bold) || GIT_CLR=$(tput setaf 2 && tput bold)
    else
        unset P_S P_E
    fi
fi
}
export PS1='\[\e[1;34m\][\h:\W]\[\e[m\]${P_S}\[${GIT_CLR}\]${GIT_PS1}\[\e[0m\]${P_E}\$ '

function _pwd_status () {
    echo "$PWD" > /tmp/PWD/${TTY}
    [ "$PRE_PWD" != "$PWD" ] && echo "$PWD" >> ~/.pwd_history && PRE_PWD="$PWD"
}

#History
export HISTTIMEFORMAT='%d/%H:%M '
export HISTSIZE=100000
export HISTFILESIZE=${HISTSIZE}
export HISTCONTROL=ignoreboth
export HISTIGNORE='a:p:pwd:pc:hi:hh:his:history:ls:ll:la:lla:c:t:ta:gd:gs'

# Bash option
shopt -s autocd
shopt -s cdspell
shopt -s checkwinsize
shopt -s dirspell
shopt -s dotglob
shopt -s extglob
shopt -s globstar
shopt -s histverify	
shopt -u histappend

# Git
. ~/share-env/.git-prompt.sh
. ~/share-env/.git-completion.bash
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true

# 3rd Application
## bat
export BAT_THEME="Nord"

# cdx command
mkdir -p /tmp/PWD
export TTY=$(basename $(tty))

# PostgreSQL
export LD_LIBRARY_PATH=/usr/lib/postgresql/11/lib:$LD_LIBRARY_PATH
export PGDATA=~/postgres/data

# Alias & Functions
[ -f ~/.bashrc ] && . ~/.bashrc
[ -f ~/.aws/awscli.sh ] && . ~/.aws/awscli.sh

# Command completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

[ -x "$(which aws_completer)" ] && complete -C $(which aws_completer) aws
