#!/usr/bin/sh

home_dir=$HOME
dotfiles_dir=$HOME/dotfiles
SRCH_DPTH=5

echo -e "# Make symlink by folloing command."

echo -e "\n- New files -"
#find $dotfiles_dir -mindepth 1 -maxdepth 1 -not -iwholename '*/.git*' -not -iwholename '*/dotfiles/setup.sh'
#find $dotfiles_dir -mindepth 1 -maxdepth 1 -not -iwholename '*/.git*' -not -iwholename '*/dotfiles/setup.sh'
for files in $(find $dotfiles_dir -mindepth 1 -maxdepth 1 -not -iwholename '*/.git*' -not -iwholename '*/dotfiles/setup.sh' | sed 's!^.*/!!') ; do
    
    linkfile="$(find $home_dir -name "$files" -not -iwholename '*/.Trash/*' -not -iwholename '*/dotfiles/*' -not -iwholename '*/.local/*' -maxdepth $SRCH_DPTH 2>/dev/null)"
    if [ ! -L "$linkfile" ];  then 
      [ -z "$linkfile" ] && linkfile="<anywhere>" 
      echo -e "\033[1mln -si $dotfiles_dir/$files $linkfile\033[m"
    fi
    #ln -sf $dotfiles_dir/$files $home_dir/$files
done

echo -e "\n- Already symlink exists -"
for files in $(find $dotfiles_dir -mindepth 1 -maxdepth 1 -not -iwholename '*/.git*' -not -iwholename '*/dotfiles/setup.sh' | sed 's!^.*/!!') ; do
#for files in $(basename $(find $dotfiles_dir -mindepth 1 -maxdepth 1 -not -iwholename '*/.git*')) ; do
    
    linkfile="$(find $home_dir -name "$files" -type l -maxdepth $SRCH_DPTH 2>/dev/null)"
    #[ -n "$linkfile" ] &&  echo -e "\033[0m$(ls -lG $linkfile)\033[m"
    [ -n "$linkfile" ] &&  ls -lG $linkfile
    #ln -sf $dotfiles_dir/$files $home_dir/$files
done

exit 0
