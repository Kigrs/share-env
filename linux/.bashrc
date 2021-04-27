#!/bin/bash

[ -z "`declare -F | grep _ps1_status`" ] && . ~/.bash_profile && return 0

alias a='alias'

alias p='pwd'
#alias pc='pwd | tr -d "\n" | pbcopy'

alias d='cd ~/Desktop'
alias h='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

alias ls='ls --color=auto'
alias ll='ls -l --color=auto'
alias la='ls -a --color=auto'
alias lla='ls -la --color=auto'

alias c='clear'
alias m='mkdir'
alias o='open'
alias f='open .'
alias t='tree -CN'
alias ta='tree -CaN -I ".git"'

function count () { sort $1 | uniq -c |sort -nr; }

alias hi='history | tail'
alias his='history'
alias hg='history | grep'
function hgt () {
    if [ -z "$1" ]; then
        history | tail
    else
        history | grep $1 | tail
    fi
}

alias mem='top -o rsize'
alias cpu='top -o cpu'

alias less='less -R'
alias grep='grep --color=auto'

alias whereami='curl ifconfig.io'

function json () {
    if [ -n "$1" ]; then echo "$1" | jq; return $?; fi
    local tmpdir=/tmp/JSON/$(uuid) rawjson prettyjson lastdate
    rawjson=$tmpdir/raw.json; prettyjson=$tmpdir/pretty.json;
    mkdir -p $tmpdir
    touch $rawjson
    lastdate=$(date -r $rawjson)
    vim $rawjson
    [ "$lastdate" = "`date -r $rawjson`" ] && \rm -rf $tmpdir && return 0;
    jq . $rawjson > $prettyjson || return 1
    vim $prettyjson
    \rm -rf $tmpdir
}

# 3rd party
alias v='vim'
alias vr='vim -R'
function v. () {
    local file=$(find ~/share-env/ -name ".*" -type f -maxdepth 1 -not -iwholename "*/.DS_Store" | peco)
    [ -z "$file" ] && return 0
    vim $file
    [ -n "`head -n 1 $file | grep '^#\!' | grep 'bash$'`" ] && read -p "Execute \"source `basename $file`\" ?: " yn && if [[ $yn = [yY] ]]; then source $file ; fi
    return 0
}

alias py='python'
alias py3='python3'

alias dk='docker'
alias dkc='docker-compose'

#alias rm='gomi'
alias speedtest='speedtest-cli --secure'
alias hh='hstr'
export HSTR_CONFIG=hicolor       # get more colors

alias ssh-ec2='ssh -i ~/.ssh/keisuke.pem ec2-user@$(aws ec2 describe-instances | jq --raw-output ".Reservations[].Instances[].PublicDnsName")'

###########################################################################################################################################################
# Git

alias g='git'

# branch
## list
alias gb='git branch'
alias gbr='git branch -r'
alias gba='git branch -a'
## rename
alias gbm='git branch -m'
## delete
alias gbd='git branch -d'
alias gbdf='git branch -D'
alias gbdr='git push -d origin' # delete remote branch
## checkout
alias gcom='git checkout master'
function gco () {
    local current_branch=$(echo $(__git_ps1) | sed -r "s/^\(([^ ]+).*\)$/\1/")
    git branch -a --sort=-authordate |\
    grep -v -e '->' -e '*' | perl -pe 's/^\h+//g' |\
    perl -pe 's#^remotes/origin/###' | perl -nle 'print if !$c{$_}++' |\
    grep -v $current_branch | peco --select-1 | xargs git checkout
}
function gcob () {
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
## add
function ga () { if [ -z "$1" ]; then git add .; else git add $@; fi }
##commit
alias gcm='git commit -m'
alias gcma='git commit -ma'
## unstage
alias gun='git reset HEAD' # back added staging files to unstaged
## reset
alias grhd='git reset --hard' # reset completely staged files
## merge
alias gm='git merge'
## revert
alias grv='git revert'

# remote
alias gf='git fetch'
function gpl () {
    local current_branch=$(echo $(__git_ps1) | sed -r "s/^\(([^ ]+).*\)$/\1/")
    git pull origin $current_branch
}
function gps () {
    local current_branch=$(echo $(__git_ps1) | sed -r "s/^\(([^ ]+).*\)$/\1/")
    git push origin $current_branch
}
function gpp () {
    local current_branch=$(echo $(__git_ps1) | sed -r "s/^\(([^ ]+).*\)$/\1/")
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

gtf() {
  local out shas sha q k
  while out=$(
      git log --graph --color=always \
          --pretty=format:'%x09%C(auto) %h %Cgreen %ar %Creset%x09by"%C(cyan ul)%an%Creset" %x09%C(auto)%s %d' "$@" |
      fzf --ansi --multi --no-sort --reverse --query="$q" \
          --print-query --expect=ctrl-d); do
    q=$(head -1 <<< "$out")
    k=$(head -2 <<< "$out" | tail -1)
    shas=$(sed '1,2d;s/^[^a-z0-9]*//;/^$/d' <<< "$out" | awk '{print $1}')
    [ -z "$shas" ] && continue
    if [ "$k" = ctrl-d ]; then
      git diff --color=always $shas | less -R
    else
      for sha in $shas; do
        git show --color=always $sha | less -R
      done
    fi
  done
}

#alias gpom='git pull origin master'
#alias gmm='git merge master'
###########################################################################################################################################################
# GitHub

alias ghiv='gh issue list --state open | peco | cut -f1 | xargs -I {} gh issue view {}'
alias ghpv='gh pr list --state open | peco | cut -f1 | xargs -I {} gh pr view {}'
# ex) ghiv [-p]  -  It can be shown in console with [-p] option.
###########################################################################################################################################################

function srch () { grep -E $1 -rl $2; }

alias effective-grep='grep -v -e "^\s*#" -e "^\s*$"'

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
local ARG_FST ARG_RST N DIR
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


[ -f ~/.fzf.bash ] && source ~/.fzf.bash
