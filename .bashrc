
alias al='alias'

alias d='cd ~/Desktop'
alias h='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias p='pwd'

alias c='clear'
alias m='mkdir'
alias rmd='rm -r'
alias v='vim'
alias vr='vim -R'
alias pwdc='pwd | tr -d "\n" | pbcopy'

alias mem='top -o rsize'
alias cpu='top -o cpu'
alias speedtest='speedtest-cli --secure'

alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias ls='ls -G'
alias ll='ls -lG'
alias la='ls -a'

alias lss='less'
alias less='less -R'

alias t='tree -C'
alias ta='tree -Ca'
alias tree='tree -N'
alias op='open'
alias hg='history | grep'

#alias d='docker'
#alias d-c='docker-compose'

#alias gcm='git checkout master'
#alias gpom='git pull origin master'
#alias gmm='git merge master'

alias gs='git status' # `git status`の確認 
alias gd='git diff' # `git diff`の確認
#alias gc='git commit' # commitする
#alias gca='git commit --amend' #　前のコミットの編集
alias glo='git log --oneline' # コミットログを各一行で読む

alias g='git'
alias ga='git add'
alias gd='git diff'
alias gs='git status'
alias gpl='git pull'
alias gps='git push'
alias gpp='git pull && git push'
alias gb='git branch'
alias gco='git checkout'
alias gf='git fetch'
alias gcm='git commit'
alias gcb='git checkout -b'
alias gca='git checkout —-amend'


alias dk='docker'

alias grep='grep --color=auto'

alias fin='open .'
alias f='open .'

alias py='python'
alias py3='python3'

function srch () { grep -E $1 -rl $2; }

function cdf () {
    target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
    if [ "$target" != "" ]
    then
        cd "$target"
        pwd
    else
        echo 'No Finder window found' >&2
    fi
}

line() {
    printf '%*s\n' "${2:-$(tput cols)}" '' | tr ' ' "${1:--}"
}

function lscat ()  {
if [[ $@ == -h || $@ == --help ]]
then 
	echo -e "\nUsage: lscat [show_line_num] [dir1 dir2 ..]\n"
else 
	echo $@ | while read ARG_FST ARG_RST
	do
		[ -z $ARG_FST ] && ARG_FST=10
		expr $ARG_FST + 1 > /dev/null 2>&1
		if [ $? -le 1 ]; then N=$ARG_FST; DIR=$ARG_RST; else N=10; DIR=$@; fi
		[ -z "$DIR" ] && DIR="."
		echo -e "MAX_LINE:\t$N\nSEARCH_DIR:\t$DIR\n\n"
		
		find $DIR -type f -maxdepth 1 2>/dev/null | while read file
		do 
			echo -en "* "
			ls -l "$file"
			if [ "`file --mime "$file" | grep binary`" ]; then
				echo "Notice: '$(basename "$file")' is a binary."
			else
				head -n $N "$file";
				[ `wc -l < "$file"` -gt $N ] && echo "..." || echo "<<EOF>>"
			fi
			echo;
		done 
	done
fi
}

# HSTR configuration - add this to ~/.bashrc
alias hh=hstr                    # hh to be alias for hstr
export HSTR_CONFIG=hicolor       # get more colors
shopt -s histappend              # append new history items to .bash_history
export HISTCONTROL=ignorespace   # leading space hides commands from history
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
# ensure synchronization between bash memory and history file
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
# if this is interactive shell, then bind hstr to Ctrl-r (for Vi mode check doc)
if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hstr -- \C-j"'; fi
# if this is interactive shell, then bind 'kill last command' to Ctrl-x k
if [[ $- =~ .*i.* ]]; then bind '"\C-xk": "\C-a hstr -k \C-j"'; fi

