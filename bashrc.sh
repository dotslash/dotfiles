source /usr/local/etc/bash_completion.d/git-completion.bash
source /usr/local/etc/bash_completion.d/git-prompt.sh
source /usr/local/lib/bazel/bin/bazel-complete.bash
# Add custom bashrc here. Ignore the failure if the the custom script 
# does not exist.
# If there is a DOTFILES_GIT_REPO/custom_bashrc.sh, then that will be symlinked
# to .custom_bashrc.sh. This is done to make it "easy" to modify the custom 
# bashrc file - It's painful to find and edit hidden files in osx :/ 
source .custom_bashrc.sh 2>/dev/null || true

# returns '(master)'
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# > get_time
# 12:26:31
get_time() { date +"%T"; }
# PS1 with git info. Example:
# >12:27:11 ~/dotfiles (master)$
export PS1=">\$(get_time) \[\033[32m\]\w\[\033[33m\] \$(parse_git_branch)\[\033[00m\]$ "
alias ls='ls -G'


# Avoid head aches caused by the default ls color scheme
# https://apple.stackexchange.com/a/33679
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
# export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
# export LSCOLORS=ExFxCxDxBxegedabagacad
alias glog='git log -10'


function swap() {
    local TMPFILE=tmp.$$;
    mv "$1" $TMPFILE && mv "$2" "$1" && mv $TMPFILE "$2";
}

# Example: git_find_replace foo bar
function git_find_replace() {
  find_text=$1  
  repl_text=$2 
  for file in `git grep --name-only  $find_text`
  do 
    echo sed -i \'.orig\' -e \"s/$find_text/$repl_text/g\" $file
    sed -i '.orig' -e "s/$find_text/$repl_text/g" $file; 
  done
}

# Example: confirm && echo "confirmed"
confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}

# Example: urldecode 'foo.com/bar?id%3D184ff84d27c3613d%26quality%3Dmedium'
# Expects python3
alias urldecode='python -c "import urllib.parse, sys; print(urllib.parse.unquote(sys.argv[1] if len(sys.argv) > 1 else sys.stdin.read()[0:-1]))"'


export PROMPT_COMMAND='log-recent -r $? -c "$(HISTTIMEFORMAT= history 1)" -p $$'
alias grep='grep --color'
alias sqlite3='sqlite3 -column -header'
HISTTIMEFORMAT="%d/%m/%y %T "


# added by Miniconda3 4.7.12 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!

export CONDA_CHANGEPS1=true
# Use the conda env "bash". The idea is that I will install python cli utils in this
# env without impacting the default conda env
CONDA_ENV_TO_USE=bash
__conda_setup="$(CONDA_REPORT_ERRORS=false '/Users/sai.suram/opt/miniconda3/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
   \eval "$__conda_setup"
   CONDA_CHANGEPS1=true conda activate $CONDA_ENV_TO_USE
else
    if [ -f "/Users/sai.suram/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/sai.suram/opt/miniconda3/etc/profile.d/conda.sh"
        CONDA_CHANGEPS1=true conda activate $CONDA_ENV_TO_USE
    else
        \export PATH="/Users/sai.suram/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda init <<<


# TODO(dotslash): Not sure why I added this.
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/sai.suram/.sdkman"
[[ -s "/Users/sai.suram/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/sai.suram/.sdkman/bin/sdkman-init.sh"
