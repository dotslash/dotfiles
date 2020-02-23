# dotfiles
Supports the following config files for bashrc (or bash_profile), gitconfig, gitignore and vimrc.

### Usage

1. Do a try run to see if things make sense. 
```sh
> python setup.py dry
Config mappings to set:
{'/Users/dotslash/dotfiles/bashrc.sh': '~/.bash_profile',
 '/Users/dotslash/dotfiles/gitconfig': '~/.gitconfig',
 '/Users/dotslash/dotfiles/gitignore': '~/.gitignore',
 '/Users/dotslash/dotfiles/vimrc': '~/.vimrc'}
Backed up /Users/dotslash/.vimrc to /Users/dotslash/.vimrc_1582493398.941699
Backed up /Users/dotslash/.bash_profile to /Users/dotslash/.bash_profile_1582493398.941699
Backed up /Users/dotslash/.gitignore to /Users/dotslash/.gitignore_1582493398.941699
Backed up /Users/dotslash/.gitconfig to /Users/dotslash/.gitconfig_1582493398.941699
Deleted dst_path
Synlinked /Users/dotslash/dotfiles/vimrc to /Users/dotslash/.vimrc
Deleted dst_path
Synlinked /Users/dotslash/dotfiles/bashrc.sh to /Users/dotslash/.bash_profile
Deleted dst_path
Synlinked /Users/dotslash/dotfiles/gitignore to /Users/dotslash/.gitignore
Deleted dst_path
Synlinked /Users/dotslash/dotfiles/gitconfig to /Users/dotslash/.gitconfig
```
2. Run `python setup.py`. 
   - If you dont like the desired outcome, use the backed up files to undo the the changes via `rsync`. 
   - Why `rsync`: Because I symlink from the git repo to appropriate dotfiles, doing a mv/cp might not work as you think. It will change the files in git repo as well.
   - TODO(dotslash): Provide a way to break the (sym)links

