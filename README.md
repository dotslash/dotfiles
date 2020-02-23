# dotfiles
Supports the config files for bashrc (or bash_profile), gitconfig, gitignore and vimrc.

### Usage

1. Do a dry run to see if things make sense. 
```sh
> python setup.py dry
Config mappings to set:
{'/Users/dotslash/dotfiles/bashrc.sh': '~/.bash_profile',
 '/Users/dotslash/dotfiles/gitconfig': '~/.gitconfig',
 '/Users/dotslash/dotfiles/gitignore': '~/.gitignore',
 '/Users/dotslash/dotfiles/vimrc': '~/.vimrc'}
Backed up /Users/dotslash/.vimrc to /Users/dotslash/.vimrc_1582496367.598279
Backed up /Users/dotslash/.bash_profile to /Users/dotslash/.bash_profile_1582496367.598279
Backed up /Users/dotslash/.gitignore to /Users/dotslash/.gitignore_1582496367.598279
Backed up /Users/dotslash/.gitconfig to /Users/dotslash/.gitconfig_1582496367.598279
Synlinked /Users/dotslash/.vimrc to /Users/dotslash/dotfiles/vimrc
Synlinked /Users/dotslash/.bash_profile to /Users/dotslash/dotfiles/bashrc.sh
Synlinked /Users/dotslash/.gitignore to /Users/dotslash/dotfiles/gitignore
Synlinked /Users/dotslash/.gitconfig to /Users/dotslash/dotfiles/gitconfig
====================
If you dont like this outcome, run the following in bash:
rsync /Users/dotslash/.vimrc_1582496367.598279 /Users/dotslash/.vimrc && rsync /Users/dotslash/.bash_profile_1582496367.598279 /Users/dotslash/.bash_profile && rsync /Users/dotslash/.gitignore_1582496367.598279 /Users/dotslash/.gitignore && rsync /Users/dotslash/.gitconfig_1582496367.598279 /Users/dotslash/.gitconfig
```
2. Run `python setup.py`. 
   - If you don't like the desired outcome, run the provided bash command in the output. 
   - Why `rsync`? : Because I symlink from the git repo to appropriate dotfiles, doing a mv/cp might not work as you think. It will change the files in git repo as well.
   - Why `ln -s` and not `cp` from the git repo? : Because I want to keep the make sure changes in the git repo will reflect into the dot files.
     - TODO(dotslash): Consider adding a way to sever the link between the git repo the dotfiles.
