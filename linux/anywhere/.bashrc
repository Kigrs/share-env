#!/bin/bash

alias a='alias'

alias lscmd='echo $PATH | tr : \\n | awk '\''!a[$0]++'\'' | xargs -I@ find @ -perm +111 -maxdepth 1 2>/dev/null'

alias p='pwd'

alias d='cd ~/Desktop'
alias h='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

alias ls='ls --color=auto'
alias ll='ls -l --color=auto'
alias l='ll'
alias la='ls -a --color=auto'
alias lla='ls -la --color=auto'

alias c='clear'
alias m='mkdir'
alias o='open'
alias f='open .'
alias t='tree -CN'
alias ta='tree -CaN -I ".git"'

alias hi='history | tail'
alias his='history'
function hg () {
    local date_format='\ *[0-9]+\ +[0-9\/:]+'
    if [ $# -eq 0 ]; then
        grep
    else
        history | grep -E "^$date_format\ ${@:$#}" | sed -r "s/^($date_format)(.*)(${@:$#})(.*)/\x1b[37m\1\x1b[0m\2\x1b[4m\3\x1b[0m\4/g"
    fi
}

alias mem='top -o rsize'
alias cpu='top -o cpu'

alias less='less -R'
alias grep='grep --color=auto'

# 3rd party
alias v='vim'
alias vr='vim -R'

alias py='python'
alias py3='python3'
alias ipy='ipython'
alias pyc-clear='find . | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf'

alias dk='docker'
alias dkc='docker-compose'

alias speedtest='speedtest-cli --secure'
alias stresstest='openssl speed -multi `getconf _NPROCESSORS_ONLN`'


###########################################################################################################################################################
# Git


alias g='git'

# branch
## list
alias gb='git branch'
alias gbr='git branch -r'
alias gba='git branch -a'
### parents
function gbp () { git show-branch | grep '*' | grep -v "$(git rev-parse --abbrev-ref HEAD)" | head -1 | awk -F'[]~^[]' '{print $2}'; }
## rename
alias gbm='git branch -m'

## delete
function gbd () { read -p "Delete local branch? [$1] (y/N): " yn; [[ $yn = [yY] ]] && git branch -d $1 || echo Deletion aborted.; }
function gbD () { read -p "Delete local branch by FORCE? [$1] (y/N): " yn; [[ $yn = [yY] ]] && git branch -D $1 || echo Deletion aborted.; }
function gbdr () { read -p "Delete remote branch? [$1] (y/N): " yn; [[ $yn = [yY] ]] && git push -d origin $1 || echo Deletion aborted.; }
function gbda () {
read -p "Delete local & remote branch? [$1] (y/N): " yn
if [[ $yn = [yY] ]]; then
    git branch -d $1
    git push -d origin $1
else
    echo Deletion aborted.
fi
}
## checkout
alias gcom='git checkout master'
function gcob () {
local branches=$(git branch | grep -v \*)
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
alias gcam='git commit --amend'

## unstage
alias gus='git reset --mixed HEAD --' # [file] back to unstaged
## unedit
alias gue='git checkout HEAD --' # [file] revert before edit
## hard reset
alias grhd='git reset --hard' # reset completely & back to prev commit

## merge
alias gm='git merge'
## revert
alias grv='git revert'
## cherry-pick
alias gcp='git cherry-pick'

# remote
alias gf='git fetch'
function gpl () {
    local pull_branch=${1:-$(echo $(__git_ps1) | sed -r "s/^\(([^ ]+).*\)$/\1/")}
    git pull origin $pull_branch
}
alias gplm='git pull origin master'

function gps () {
    local push_branch=${1:-$(echo $(__git_ps1) | sed -r "s/^\(([^ ]+).*\)$/\1/")}
    git push origin $push_branch
}

function gpp () {
    local pull_branch=${1:-$(echo $(__git_ps1) | sed -r "s/^\(([^ ]+).*\)$/\1/")}
    local push_branch=${2:-$(echo $(__git_ps1) | sed -r "s/^\(([^ ]+).*\)$/\1/")}
    git pull origin $pull_branch && git push origin $push_branch
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

function srch () { grep -E $1 -rl $2; }

function line() { printf '%*s\n' "${2:-$(tput cols)}" '' | tr ' ' "${1:--}"; }

function lscat ()  {
[[ $@ == -h || $@ == --help ]] && echo -e "\nUsage: lscat [show_line_num] [dir1 dir2 ..]\n" && return 0
local ARG_FST ARG_RST N DIR file
echo $@ | while read ARG_FST ARG_RST
do
    [ -z $ARG_FST ] && ARG_FST=10
    expr $ARG_FST + 1 > /dev/null 2>&1
    if [ $? -le 1 ]; then N=$ARG_FST; DIR=$ARG_RST; else N=10; DIR=$@; fi
    [ -z "$DIR" ] && DIR="."
    echo -e "MAX_LINE:\t$N\nSEARCH_DIR:\t$DIR\n\n"

    find $DIR -type f -maxdepth 1 2>/dev/null | sort | while read file
    do
        tput smul; tput bold; echo -en "* "; ls -lhG "$file"; tput sgr0
        if [ "`file --mime "$file" | grep binary`" ]; then
            echo "Notice: '$(basename "$file")' is a binary."
        else
            head -n $N "$file";
            [ `wc -l < "$file"` -gt $N ] && echo "..." || echo "<<EOF>>"
        fi
        echo;
    done
done
}

