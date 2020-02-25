source /usr/local/etc/bash_completion.d/git-completion.bash
source /usr/local/etc/bash_completion.d/git-prompt.sh
# Add custom bashrc here. Ignore the failure if the the custom script 
# does not exist.

# TODO(dotslash): Define more formatting helpers.
# TODO(dotslash): Export this somehow
NOCOLOR='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
DULLYELLOW='\033[0;33m'
BLUE='\033[0;34m'
PINK='\033[0;35m'
CYAN='\033[0;36m'
LIGHTGRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHTBLUE='\033[1;34m'
LIGHTPINK='\033[1;35m'
LIGHTCYAN='\033[1;36m'
WHITE='\033[1;37m'

test_colors() {
  echo -e "$RED RED $GREEN GREEN $DULLYELLOW DULLYELLOW $BLUE BLUE $PINK PINK"
  echo -e "$CYAN CYAN $LIGHTGRAY LIGHTGRAY $DARKGRAY DARKGRAY $LIGHTRED LIGHTRED"
  echo -e "$LIGHTGREEN LIGHTGREEN $YELLOW YELLOW $LIGHTBLUE LIGHTBLUE "
  echo -e "$LIGHTPINK LIGHTPINK $LIGHTCYAN LIGHTCYAN $WHITE WHITE"
  echo -e "$RED RED $NOCOLOR NOCOLOR"
}

# returns '(master)'
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# > get_time
# 12:26:31
get_time() { date +"%T"; }
# PS1 with git info. Example:
# >12:27:11 ~/dotfiles (master)$
export PS1=">\$(get_time) ${GREEN}\w${YELLOW} \$(parse_git_branch)${NOCOLOR}$ "
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

# https://github.com/dotslash/recent2: Logs bash history to an sqlite file
export PROMPT_COMMAND='log-recent -r $? -c "$(HISTTIMEFORMAT= history 1)" -p $$'
alias grep='grep --color'
alias sqlite3='sqlite3 -column -header'
HISTTIMEFORMAT="%d/%m/%y %T "


CONDA_BASE=""
if [ -d "/opt/miniconda3" ]; then
  CONDA_BASE="/opt/miniconda3"
elif [ -d "~/opt/miniconda3"]; then
  CONDA_BASE=~/opt/miniconda3
fi

if [[ CONDA_BASE ]]; then
  # added by Miniconda3 4.7.12 installer (modified by me)
  # >>> conda init >>>
  # !! Contents within this block are managed by 'conda init' !!
  export CONDA_CHANGEPS1=false
  # Use the conda env "bash". The idea is that I will install python cli utils in this
  # env without impacting the default conda env
  CONDA_ENV_TO_USE=bash
  __conda_setup="$(CONDA_REPORT_ERRORS=false "$CONDA_BASE/bin/conda" shell.bash hook 2> /dev/null)"
  if [ $? -eq 0 ]; then
     \eval "$__conda_setup"
     conda activate $CONDA_ENV_TO_USE
  else
      if [ -f "$CONDA_BASE/etc/profile.d/conda.sh" ]; then
          . "$CONDA_BASE/etc/profile.d/conda.sh"
          conda activate $CONDA_ENV_TO_USE
      else
          \export PATH="$CONDA_BASE/bin:$PATH"
      fi
  fi
  unset __conda_setup
  # <<< conda init <<<
  export PS1="${PINK}(\$(basename $CONDA_DEFAULT_ENV))${NOCOLOR} $PS1"
fi

# If there is a DOTFILES_GIT_REPO/custom_bashrc.sh, then that will be symlinked
# to .custom_bashrc.sh. This is done to make it "easy" to modify the custom 
# bashrc file - It's painful to find and edit hidden files in osx :/ 
# This is done towards the end of the file to ensure things like
# export PS1="foo-$PS1" to work. The custom_bashrc.sh can build on top of what
# is done here.
source ~/.custom_bashrc.sh 2>/dev/null || true



# Added sdkman to install scala.
# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/sai.suram/.sdkman"
[[ -s "/Users/sai.suram/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/sai.suram/.sdkman/bin/sdkman-init.sh"
