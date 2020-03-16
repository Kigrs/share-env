export PATH=~/.nodebrew/current/bin:$PATH
export PATH=/usr/local/opt/openssl@1.1/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=~/Library/Python/3.7/bin:$PATH
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PATH=/Library/Frameworks/Python.framework/Versions/3.7/bin:$PATH

#export PS1="[\[\e[1;37m\]\h:\[\e[m\]\W]\$ "
#>> [ip-172-31-41-207:~]$ 

#export PS1="\[\e[1;34m\][\D{%H:%M} \u@\h \W]\[\e[m\]\n\$ "
#>> [12:53 ec2-user@ip-172-31-41-207 ~]
#>> $ 

#export PS1="\[\e[1;34m\][\D{%H:%M}] \u@\h : \w\[\e[m\]\n\$ "
#>> [12:50] ec2-user@ip-172-31-41-207 : ~/expose_attackers_location
#>> $ 

# show timestamp on right side of proompt.
#function __command_rprompt() {
#    local rprompt=$(date "+%H:%M:%S")
#    local num=$(($COLUMNS - ${#rprompt} - 2))
#    printf "%${num}s$rprompt\r" ''
#}
#PROMPT_COMMAND=__command_rprompt
. /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh
. /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true

# セッションクローズ時の.bash_historyへの書き込みをoff
shopt -u histappend
# .bash_historyとメモリ上のコピーを頻繁に同期
share_history(){
  history -a
  history -c
  history -r
}
PROMPT_COMMAND='share_history'

PRE_PROMPT_DATE=$(date "+%s")
function _ps1_status () {
if [ $(date "+%s") -gt $PRE_PROMPT_DATE ]
then
  PRE_PS1_DATE=$(date "+%s") 
  GIT_PS1=$(echo $(__git_ps1) | gsed "s/master/mstr/")
  [ -n "`echo $GIT_PS1 | grep mstr`" ] && GIT_CLR=31 || GIT_CLR=32
  PRE_PS1_STATE=$(echo $GIT_PS1 | tr -d "\(\) " | xargs -IX echo -e "(\033[1;${GIT_CLR}mX\033[0m)") 
  echo $PRE_PS1_STATE
else
  echo $PRE_PS1_STATE
fi
}
export PS1='\[\e[1;34m\][\h:\W]\[\e[m\]$(_ps1_status)\$ '


[ -f $(brew --prefix)/etc/bash_completion ] && . $(brew --prefix)/etc/bash_completion

[ -f ~/.bashrc ] && . ~/.bashrc

[ -f ~/.aws/awscli.sh ] && . ~/.aws/awscli.sh

[ -f ~/.iterm2_shell_integration.bash ] && . ~/.iterm2_shell_integration.bash
