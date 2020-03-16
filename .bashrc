#!/bin/bash

alias a='alias'

alias p='pwd'
alias pc='pwd | tr -d "\n" | pbcopy'

alias d='cd ~/Desktop'
alias h='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

alias ls='ls -G'
alias ll='ls -lG'
alias la='ls -aG'
alias lla='ls -laG'

alias c='clear'
alias m='mkdir'
alias o='open'
alias f='open .'
alias t='tree -CN'
alias ta='tree -CaN -I ".git"'

alias hg='history | grep'
alias mem='top -o rsize'
alias cpu='top -o cpu'

alias less='less -R'
alias grep='grep --color=auto'


# 3rd party
alias v='vim'
alias vr='vim -R'

alias py='python'
alias py3='python3'

alias dk='docker'
alias dkc='docker-compose'

alias speedtest='speedtest-cli --secure'
alias rm='gomi'


#alias gpom='git pull origin master'
#alias gmm='git merge master'
#########################################
alias g='git'

# branch
alias gb='git branch'
alias gbr='git branch -r'
alias gba='git branch -a'
alias gbm='git branch -m'
alias gbd='git branch -d'
alias gbdf='git branch -D'

alias gbdr='git push -d origin'

# temporary (TODO make func:'gco' 'gcof?')
#alias gco='git checkout'
#alias gcob='git checkout -b'
alias gcom='git checkout master'
#alias gca='git checkout —-amend'

function gco () {
local branches=$(git branch)
[ -z "$branches" ] && return 1
[ -z "$1" ] && echo "Select target branch." && return 1

if [ -n "$(echo $branches | grep $1)" ]; then
    git checkout $1
else
    git fetch
    [ "$?" -ne "0" ] && return 1
    branches=$(git branch -r)
    if [ -n "$(echo $branches | grep $1)" ]; then
        git checkout -b $1 origin/$1
    else
        read -p "Make new branch? [$1] (y/N): " yn
        if [[ $yn = [yY] ]]; then
            git checkout -b $1
        else
            echo Checkout aborted.
        fi
    fi
fi
}

# edit
#alias ga='git add'
#alias ga.='git add .'
function ga () { if [ -z "$1" ]; then git add .; else git add $@; fi }

alias gcm='git commit -m'
alias gcma='git commit -ma'
alias gd='git diff'

alias gun='git reset HEAD' # back added staging files to unstaged
alias grhd='git reset --hard' # reset completely staged files

# remote
alias gf='git fetch'
#alias gpl='git pull'
#alias gps='git push'
#alias gpp='git pull && git push'
function gpl () {
    local current_branch=$(echo $(__git_ps1) | gsed -r "s/^\(([^ ]+).*\)$/\1/")
    git pull origin $current_branch
}
function gps () {
    local current_branch=$(echo $(__git_ps1) | gsed -r "s/^\(([^ ]+).*\)$/\1/")
    git push origin $current_branch
}
function gpp () {
    local current_branch=$(echo $(__git_ps1) | gsed -r "s/^\(([^ ]+).*\)$/\1/")
    git pull origin $current_branch && git push origin $current_branch
}


# check
alias gs='git status'
alias gd='git diff'
alias gdc='git diff --compact-summary'
alias gsh='git show'
alias gbl='git blame'
alias gl='git log'
alias glo='git log --oneline' # コミットログを各一行で読む
alias gt="git log --graph --pretty=format:'%x09%C(auto) %h %Cgreen %ar %Creset%x09by\"%C(cyan ul)%an%Creset\" %x09%C(auto)%s %d'"

#########################################

function srch () { grep -E $1 -rl $2; }

function cdf () {
local target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
if [ "$target" != "" ]
then
    cd "$target"
    pwd
else
    echo 'No Finder window found' >&2
fi
}

function line() {
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

