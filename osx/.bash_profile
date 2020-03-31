#!/bin/bash

# EDITOR
export EDITOR='vim'
export VISUAL='vim'

# PATH
export PATH=~/.nodebrew/current/bin:$PATH
export PATH=/usr/local/opt/openssl@1.1/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=~/Library/Python/3.7/bin:$PATH
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PATH=/Library/Frameworks/Python.framework/Versions/3.7/bin:$PATH

# Prompt
export PROMPT_COMMAND='history -a; history -c; history -r ; _ps1_status'

PRE_PROMPT_DATE=$(date "+%s")
function _ps1_status () {
if [ $(date "+%s") -gt $PRE_PROMPT_DATE ]; then
    echo "$PWD" > /tmp/PWD/${TTY}
    PRE_PROMPT_DATE=$(date "+%s")
    GIT_PS1=$(echo $(__git_ps1) | gsed "s/master/mstr/" | tr -d "\(\) ")
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

#export PS1="[\[\e[1;37m\]\h:\[\e[m\]\W]\$ "
#>> [ip-172-31-41-207:~]$ 
#export PS1="\[\e[1;34m\][\D{%H:%M} \u@\h \W]\[\e[m\]\n\$ "
#>> [12:53 ec2-user@ip-172-31-41-207 ~]
#>> $ 
#export PS1="\[\e[1;34m\][\D{%H:%M}] \u@\h : \w\[\e[m\]\n\$ "
#>> [12:50] ec2-user@ip-172-31-41-207 : ~/expose_attackers_location
#>> $ 

#History
export HISTTIMEFORMAT='%d/%H:%M '
export HISTSIZE=100000
export HISTFILESIZE=${HISTSIZE}
export HISTCONTROL=ignoreboth
export HISTIGNORE='a:p:pwd:pc:hi:hh:his:history:ls:ll:la:lla:c:t:ta'

# Bash option
shopt -s globstar
shopt -s autocd
shopt -s extglob
shopt -s histverify	
shopt -u histappend

# Git
. /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh
. /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true

# 3rd Application
## bat
export BAT_THEME="Nord"

# Alias & Functions
[ -f ~/.bashrc ] && . ~/.bashrc
[ -f $(brew --prefix)/etc/bash_completion ] && . $(brew --prefix)/etc/bash_completion
[ -f ~/.aws/awscli.sh ] && . ~/.aws/awscli.sh
[ -f ~/.iterm2_shell_integration.bash ] && . ~/.iterm2_shell_integration.bash

# tty PWD
mkdir -p /tmp/PWD
export TTY=$(basename $(tty))

