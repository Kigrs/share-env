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
export PROMPT_COMMAND='history -a; history -c; history -r'

PRE_PROMPT_DATE=$(date "+%s")
function _ps1_status () {
if [ $(date "+%s") -gt $PRE_PROMPT_DATE ]
then
  PRE_PS1_DATE=$(date "+%s") 
  GIT_PS1=$(echo $(__git_ps1) | sed "s/master/mstr/")
  [ -n "`echo $GIT_PS1 | grep mstr`" ] && GIT_CLR=31 || GIT_CLR=32
  PRE_PS1_STATE=$(echo $GIT_PS1 | tr -d "\(\) " | xargs -IX echo -e "(\033[1;${GIT_CLR}mX\033[0m)") 
  echo $PRE_PS1_STATE
else
  echo $PRE_PS1_STATE
fi
}
export PS1='\[\e[1;34m\][\h:\W]\[\e[m\]$(_ps1_status)\$ '

#export PS1="[\[\e[1;37m\]\h:\[\e[m\]\W]\$ "
#>> [ip-172-31-41-207:~]$ 
#export PS1="\[\e[1;34m\][\D{%H:%M} \u@\h \W]\[\e[m\]\n\$ "
#>> [12:53 ec2-user@ip-172-31-41-207 ~]
#>> $ 
#export PS1="\[\e[1;34m\][\D{%H:%M}] \u@\h : \w\[\e[m\]\n\$ "
#>> [12:50] ec2-user@ip-172-31-41-207 : ~/expose_attackers_location
#>> $ 

#History
HISTTIMEFORMAT='%d_%H:%M '
HISTSIZE=100000
HISTFILESIZE=${HISTSIZE}
HISTCONTROL=ignoreboth
HISTIGNORE='a:p:pwd:pc:d:h:hi:hh:his:history:ls:ll:la:lla:c:t:ta'

# Bash option
shopt -s globstar
shopt -s autocd
shopt -s extglob
shopt -s histverify	
shopt -u histappend

# Git
#. /usr/share/doc/git-2.23.1/contrib/completion/git-prompt.sh
#. /usr/share/doc/git-2.23.1/contrib/completion/git-completion.bash
##. /usr/share/git-core/contrib/completion/git-prompt.sh
source `find / -name 'git-completion.bash' 2>/dev/null`
source `find / -name 'git-prompt.sh' 2>/dev/null`
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true

# 3rd Application
## bat
export BAT_THEME="Nord"

## fzf
export FZF_DEFAULT_OPTS='--height 50% --reverse --border'

# Alias & Functions
[ -f ~/.bashrc ] && . ~/.bashrc
[ -f ~/.aws/awscli.sh ] && . ~/.aws/awscli.sh
