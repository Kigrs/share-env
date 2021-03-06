#!/bin/bash

[ -z "`declare -F | grep _ps1_status`" ] && . ~/.bash_profile && return 0

alias a='alias'
function def () {
    function _search_command () {
        [ "$#" -eq 0 ] && alias && declare -f && return 0
        for func in "$@"; do
            declare -f $func 2>/dev/null || alias $func 2>/dev/null || echo "$func: neither alias nor function are found."
        done
    }
    _search_command $@ | bat -plain --paging auto -l sh
}
alias lscmd='echo $PATH | tr : \\n | awk '\''!a[$0]++'\'' | xargs -I@ find @ -perm +111 -maxdepth 1 2>/dev/null'

alias p='pwd && pwd | tr -d "\n" | pbcopy'

alias d='cd ~/Desktop'
alias h='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

alias ls='ls -G'
alias ll='ls -lhG'
alias l='ll'
alias la='ls -aG'
alias lla='ls -lahG'

alias c='clear'
alias m='mkdir'
alias o='open'
function oa () {
    # oa [Application] filenames
    # oa sub testfile
    # oa testfile
    local app
    if [ -z "$1" ]; then
        echo "Missing filename" && return 0
    elif [ ! -r "$1" ]; then
        [ ! -r "$2" ] && echo "$2: No such file or directory" && return 0
        app=$(find /Applications/ -type d -name "*.app" -mindepth 1 -maxdepth 1 | fzf --query="/applications//$1.app" --select-1)
        [ -z "$app" ] && return 0
        open -a "$app" "${@:2}"
    else
        app=$(find /Applications/ -type d -name "*.app" -mindepth 1 -maxdepth 1 | fzf --select-1)
        [ -z "$app" ] && return 0
        open -a "$app" "${@:1}"
    fi
    return 0
}
alias f='open .'
alias t='tree -CN'
alias ta='tree -CaN -I ".git"'

function count () { sort $1 | uniq -c |sort -nr; }

alias hi='history | tail'
alias his='history'
function hg () {
    local date_format='\ *[0-9]+\ +[0-9\/:]+'
    if [ $# -eq 0 ]; then
        grep
    else
        history | grep -E "^$date_format\ ${@:$#}" | gsed -r "s/^($date_format)(.*)(${@:$#})(.*)/\x1b[37m\1\x1b[0m\2\x1b[4m\3\x1b[0m\4/g"
    fi
}
function hgz () {
    local command=$(hg --plain "$1" | fzf --tac --ansi)
    local date_format='\ *[0-9]+\ +[0-9\/:]+'
    #[ -n "$command" ] && echo "$command" | gsed -r "s/$date_format\ //" | tr -d "\n" | pbcopy && echo "$command" | gsed -r "s/^($date_format)(.*)/\x1b[37m\1\x1b[0m\2/g"
    [ -n "$command" ] && echo "$command" | gsed -r "s/$date_format\ //" | tr -d "\n" | pbcopy && echo "$command" | gsed -r "s/^($date_format)(.*)/\x1b[37mCopied\ :\ \x1b[0m\2/g"
    return 0
}

alias mem='top -o rsize'
alias cpu='top -o cpu'

alias less='less -R'
alias grep='grep --color=auto'

alias whereami='curl ifconfig.io'

function xsleep () {
    read -t $1 < /dev/udp/0.0.0.0/80
    return 0
}

function sh-escape () {
  local s a=() q="'" qq='"'
  for s in "$@"; do
    a+=("'${s//$q/$q$qq$q$qq$q}'")
  done
  echo "${a[*]}"
}

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
    local file lastmoddate
    file=$(find ~/share-env/ -name ".*" -type f -maxdepth 3 -not -iwholename "*/.DS_Store" | peco --select-1)
    [ -z "$file" ] && return 0
    lastmoddate=$(date -r $file)
    vim $file
    [ "$lastmoddate" != "`date -r $file`" -a -n "`head -n 1 $file | grep '^#\!' | grep 'bash$'`" ] && read -n 1 -p "Execute \"source `basename $file`\" ?: " yn && if [[ $yn = [yY] ]]; then source $file ; fi
    return 0
}

alias py='python'
alias py3='python3'
alias ipy='ipython'
alias pyc-clear='find . | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf'

function jpy () {
    local jnb
    jnb=${1:-`ls | peco --select-1`}
    [ -z "$jnb" ] && return 0
    jupyter nbconvert --to notebook --execute $jnb \
    --inplace --ExecutePreprocessor.timeout=-1 \
    --debug
}

alias dk='docker'
alias dkc='docker-compose'

alias rm='gomi'
alias speedtest='speedtest-cli --secure'
alias stresstest='openssl speed -multi `getconf _NPROCESSORS_ONLN`'
alias hh='hstr'
export HSTR_CONFIG=hicolor       # get more colors

function imginfo() {
    catimg $1 && sips --getProperty all $1;
}

function lsimg () {
    local pic_ext=('jpg' 'jpeg' 'JPG' 'JPEG' 'jpe' 'jfif' 'pjpeg' 'pjp' 'png' 'gif' 'tiff' 'tif' 'webp' 'svg' 'svgz')
    printf '%s\n' "${@:-./}" | while read dir; do
        ls -F "$dir" | grep -v -E ".*\/" | grep -F '.' | while read file; do
            extension=$(echo "$file" | rev | cut -d. -f 1 | rev)
            if [ "$(printf '%s\n' "${pic_ext[@]}" | grep -E "^${extension}$")" ]; then
                echo
                ls -l "$dir""$file"
                catimg "$dir""$file"
            fi
        done
    done
}

function onetime () {
    local key_id secret_key code
    key_id=$(cat ~/.oauth | cut -d\  -f 1 | peco --select-1)
    [ -z "$key_id" ] && return 0
    secret_key=$(grep $key_id ~/.oauth | cut -d\  -f 2)
    code=$(oathtool --totp --base32 $secret_key)
    [ -n "$code" ] && echo $code && echo $code | pbcopy
}

function ssha () {
    local PRIVATE_KEY=${1-~/.ssh/private.pem}
    local FINGER_PRINT=$(ssh-keygen -lf $PRIVATE_KEY | cut -d\  -f2)
    [[ -n "$SSH_AGENT_PID" && -n "$(ssh-add -l | grep $FINGER_PRINT)" ]] && echo -e "Agent pid $SSH_AGENT_PID" && return 0
    [ -z "$SSH_AGENT_PID" ] && eval `ssh-agent`
    ssh-add $PRIVATE_KEY
}
function sshx () {
    local name host port user key config=~/.ssh/server
    name=$(cut -d \  -f 1 $config | sed -e '1d' | fzf --select-1 --exit-0)
    [ -z "$name" ] && return 0
    IFS=\  read name host port user key <<< "$(grep $name $config)"
    echo Host: $host
    ssha ~/.ssh/$key && ssh -p $port $user@$host
}
alias ssh-ec2='ssha && ssh ec2-user@$(aws ec2 describe-instances --profile private | jq --raw-output ".Reservations[].Instances[].PublicDnsName")'

alias subethaedit='open -a /Applications/SubEthaEdit.app'
alias vscode='open -a /Applications/Visual\ Studio\ Code.app'

###########################################################################################################################################################
# Git

function ghelp () {
    local git_alias=$(alias | grep -e =.git -e =.gh)
    local git_func=$(eval $(declare -F | grep 'declare -f g'))
    bat -pp -l bash <(echo "$git_alias")
    bat -pp -l bash <(echo "$git_func")
}

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
function gco () {
    local current_branch=$(echo $(__git_ps1) | gsed -r "s/^\(([^ ]+).*\)$/\1/")
    git branch -a --sort=-authordate |\
    grep -v -e '->' -e '*' | perl -pe 's/^\h+//g' |\
    perl -pe 's#^remotes/origin/###' | perl -nle 'print if !$c{$_}++' |\
    grep -v $current_branch | peco --select-1 | xargs git checkout
}
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
    local pull_branch=${1:-$(echo $(__git_ps1) | gsed -r "s/^\(([^ ]+).*\)$/\1/")}
    git pull origin $pull_branch
}
alias gplm='git pull origin master'

function gps () {
    local push_branch=${1:-$(echo $(__git_ps1) | gsed -r "s/^\(([^ ]+).*\)$/\1/")}
    git push origin $push_branch
}

function gpp () {
    local pull_branch=${1:-$(echo $(__git_ps1) | gsed -r "s/^\(([^ ]+).*\)$/\1/")}
    local push_branch=${2:-$(echo $(__git_ps1) | gsed -r "s/^\(([^ ]+).*\)$/\1/")}
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

alias ghiv='gh issue list --state open | peco --select-1 | cut -f1 | xargs -I {} gh issue view {}'
alias ghpv='gh pr list --state open | peco --select-1 | cut -f1 | xargs -I {} gh pr view {}'
# ex) ghiv [-p]  -  It can be shown in console with [-p] option.
###########################################################################################################################################################

function cb () { echo -n "${@}" | pbcopy; }

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

function cdx () {
    local target=$(ls /tmp/PWD/* | grep -v "$TTY" | xargs cat | sort -u| grep -v "^$PWD$" | peco --select-1)
    [ -n "$target" ] && cd "$target" && pwd
    return 0
}

function cdh () {
    local HOME_ESC replace restore target
    HOME_ESC=$(echo $HOME | gsed "s/\//\\\\\//g")
    replace="s/$HOME_ESC/~/"
    restore="s/~/$HOME_ESC/"
    target=$(tac ~/.pwd_history | awk '!a[$0]++' | grep -v "^$PWD$" | gsed $replace | peco --select-1 | gsed $restore)
    [ -n "$target" ] && cd "$target" && pwd
    return 0
}

function cdg () {
    local GIT_REPOS="$(ghq root)/$(ghq list | peco)"
    [ "$GIT_REPOS" = "$(ghq root)/" ] || cd $GIT_REPOS
    return 0
}

function cdp () {
    local target targets pre_directory pre_line
    while :; do
        targets=$(cat <(line =) <(ls -AF | grep "\/" | grep -v "^\.") \
                      <(line) <(ls -AF | grep -v "\/" | grep -v "^\.") <(ls -AF | grep -v "\/" | grep "^\.") \
                      <(line) <(ls -AF | grep -E "^\\..*/$") \
                      <(line =) <(echo -e "/\n$HOME\n../../../\n../../\n../"))

        [[ "$target" =~ ^../ ]] || [[ -f "$target" ]] && \
            pre_line=$(($(echo "$targets" | grep -n -F "$pre_directory" | awk 'NR==1 || length<len {len=length; line=$0} END {print line}' | cut -d ":" -f 1) - 1)) || pre_line=1
        target=$(echo "$targets" | peco --prompt "$(pwd)/" --initial-index "$pre_line" | gsed -r 's/(.*)(@|\*)$/\1/')

        [ -z "$target" ] && break
        [ -f "$target" ] && pre_directory="$target" && vim "$target"
        if [ -d "$target" ]; then
            [[ "$target" =~ ^../ ]] && \
                pre_directory="$(pwd | rev | cut -d \/ -f $(echo -n "$target" | gsed 's/\.\.\//x/g' | wc -m) | rev)" && \
                pre_directory=${pre_directory:="$(pwd | cut -d \/ -f 2)"}
            cd "$target"
            _pwd_status
        fi
    done
    return 0
}

function cdz () {
    local target=$(fzf --select-1 --exit-0 --query="$1" --preview 'bat {}')
    [ -n "$target" ] && cd "$(dirname "$target")"
    return 0
}

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
            #head -n $N "$file";
            bat -pp -r:$N "$file";
            [ `wc -l < "$file"` -gt $N ] && echo "..." || echo "<<EOF>>"
        fi
        echo;
    done 
done
}



