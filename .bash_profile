export PATH=~/.nodebrew/current/bin:$PATH
export PATH=/usr/local/opt/openssl@1.1/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=~/Library/Python/3.7/bin:$PATH

#export PS1="[\[\e[1;37m\]\h:\[\e[m\]\W]\$ "
#>> [ip-172-31-41-207:~]$ 

#export PS1="\[\e[1;34m\][\D{%H:%M} \u@\h \W]\[\e[m\]\n\$ "
#>> [12:53 ec2-user@ip-172-31-41-207 ~]
#>> $ 

#export PS1="\[\e[1;34m\][\D{%H:%M}] \u@\h : \w\[\e[m\]\n\$ "
#>> [12:50] ec2-user@ip-172-31-41-207 : ~/expose_attackers_location
#>> $ 


PS1="\[\e[1;34m\][\h:\W]\[\e[m\]\$ "


[ -f ~/.bashrc ] && . ~/.bashrc

[ -f ~/.aws/awscli.sh ] && . ~/.aws/awscli.sh

[ -f ~/.iterm2_shell_integration.bash ] && . ~/.iterm2_shell_integration.bash

