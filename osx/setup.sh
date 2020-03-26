#!/usr/bin/sh

if [ "$(uname)" == 'Darwin' ]; then
    OS_NAME='osx'
elif [ "$(uname)" == 'Linux' ]; then
    OS_NAME='linux'
else
    echo unknown os type.
    exit 1
fi

home_dir=$HOME
share-env_dir=$HOME/share-env/$OS_NAME
SRCH_DPTH=5

echo -e "# Make symlink by following command."

echo -e "\n- New files -"
for files in $(basename $(find $share-env_dir -name "\.*" -mindepth 1 -maxdepth 1 -not -iwholename '*/.git*' -not -iwholename '*/.DS_Store')) ; do

    linkfile="$(find $home_dir -name "$files" -not -iwholename '*/.Trash/*' -not -iwholename '*/share-env/*' -not -iwholename '*/.local/*' -maxdepth $SRCH_DPTH 2>/dev/null)"
    if [ ! -L "$linkfile" ];  then 
      [ -z "$linkfile" ] && linkfile="<anywhere>" 
      echo -e "\033[1mln -si $share-env_dir/$files $linkfile\033[m"
    fi
done

echo -e "\n- Already symlink exists -"
for files in $(basename $(find $share-env_dir -name "\.*" -mindepth 1 -maxdepth 1 -not -iwholename '*/.git*' -not -iwholename '*/.DS_Store')) ; do
    
    linkfile="$(find $home_dir -name "$files" -type l -maxdepth $SRCH_DPTH 2>/dev/null)"
    [ -n "$linkfile" ] &&  ls -lG $linkfile #&& echo -e "\033[1mln -si $share-env_dir/$files $linkfile\033[m"
done

exit 0
