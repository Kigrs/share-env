#!/usr/bin/sh

home_dir=$HOME
dotfiles_dir=$HOME/dotfiles

echo -e "# Make symlink by folloing command."

echo -e "\n- New files -"
for files in $(basename $(find $dotfiles_dir -name '.*' -maxdepth 1)) ; do
    
    [ -L "$home_dir/$files" ] || echo "ln -sf $dotfiles_dir/$files $home_dir/$files"
    #ln -sf $dotfiles_dir/$files $home_dir/$files
done

echo -e "\n- Already symlink exists -"
for files in $(basename $(find $dotfiles_dir -name '.*' -maxdepth 1)) ; do
    
    [ -L "$home_dir/$files" ] && echo "ln -sf $dotfiles_dir/$files $home_dir/$files"
    #ln -sf $dotfiles_dir/$files $home_dir/$files
done

exit 0
