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
#export PS1='\[\033[37m\][\[\033[36m\]\u\[\033[37m\]@\h \[\033[32m\]\W\[\033[37m\]]\[\033[31m\]$(__git_ps1)\[\033[00m\]\$ '
#function _ps1_status ( ) { echo __git_ps1 | tr -d "\(\) " | xargs -IX [ -n "X" ] && echo "(\[\e[1;32m\]X\[\e[m\])" }
#export PS1="\[\e[1;34m\][\h:\W]\[\e[m\](\[\e[1;34m\]$(__git_ps1)\[\e[m\])\$ "

#export PS1='\[\e[1;34m\][\h:\W]\[\e[m\](\[\e[1;32m\]$(__git_ps1 | tr -d "\(\) ")\[\e[m\])\$ '
export PS1='\[\e[1;34m\][\h:\W]\[\e[m\]$(echo $(__git_ps1) | tr -d "\(\) " | xargs -IX echo "(\[\e[1;32m\]X\[\e[m\])")\$ '

#echo $(__git_ps1) | tr -d "\(\) " | xargs -IX echo -e "(\[\e[1;32m\]X\[\e[m\])"


[ -f $(brew --prefix)/etc/bash_completion ] && . $(brew --prefix)/etc/bash_completion

[ -f ~/.bashrc ] && . ~/.bashrc

[ -f ~/.aws/awscli.sh ] && . ~/.aws/awscli.sh

[ -f ~/.iterm2_shell_integration.bash ] && . ~/.iterm2_shell_integration.bash
