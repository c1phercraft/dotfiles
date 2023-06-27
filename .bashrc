#
# Bash RC-file.
#

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Aliases
[[ -f "${HOME}/.bash_aliases" ]] && source "${HOME}/.bash_aliases"
[[ -f "${HOME}/.git_aliases" ]] && source "${HOME}/.git_aliases"

# Functions
[[ -f "${HOME}/.bash_functions" ]] && source "${HOME}/.bash_functions"

# Location specific definitions
[[ -f "${HOME}/bin/bashrc" ]] && source "${HOME}/bin/bashrc"

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
fi

# Local completion scripts
[[ -f "${HOME}/.bash_completion" ]] && source "${HOME}/.bash_completion"

# Define a few foreground colours
BLACK='\e[0;30m'
RED='\e[0;31m'
GREEN='\e[0;32m'
BROWN='\e[0;33m'
BLUE='\e[0;34m'
PURPLE='\e[0;35m'
CYAN='\e[0;36m'
LIGHTGRAY='\e[0;37m'
DARKGRAY='\e[1;30m'
LIGHTRED='\e[1;31m'
LIGHTGREEN='\e[1;32m'
YELLOW='\e[1;33m'
LIGHTBLUE='\e[1;34m'
LIGHTPURPLE='\e[1;35m'
LIGHTCYAN='\e[1;36m'
WHITE='\e[1;37m'
BOLD='\e[1m'
ITALIC='\e[3m'
UNDERLINE='\e[4m'
NC='\e[0m'              # No color.

# Set a fancy prompt (non-color, unless we know we "want" color)
color_prompt=
case "$TERM" in
  xterm-color) color_prompt=yes;;
  xterm) color_prompt=yes;;
esac

if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  # We have color support; assume it's compliant with Ecma-48
  # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
  # a case would tend to support setf rather than setaf.)
  color_prompt=yes
fi

set_title() {
  local title=$1
  if [ "$GUAKE_TAB_UUID" == "" ]; then
    PS1+="\e]2;$title\a"
  else
    guake -r "$title"
  fi
}

update_prompt() {
  local LAST_RESULT=$?
  local DELIM=$LIGHTGRAY
  
  # Day and time.
  PS1="\n\[$DELIM\](\[$WHITE\]\D{%d~%H%M}\[$DELIM\])"
  # Number of jobs.
  PS1+="-(\[$WHITE\]\j\[$DELIM\])"
  # User and host.
  PS1+="-(\[$WHITE\]\u\[$DELIM\]@\[$WHITE\]\h\[$DELIM\])"
  # Current working directory.
  PS1+="-(\[$YELLOW\]\w\[$DELIM\])"
  
  if `git rev-parse --is-inside-work-tree > /dev/null 2>&1`; then
    # Inside a Git repo, so add more information.
    PS1+="-("

    # Git branch.
    BRANCH="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
    PS1+="\[$LIGHTGREEN\]\[$ITALIC\]$BRANCH\[$NC\]"
       
    local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
    if [ $NUM_AHEAD -gt 0 ]; then
      # Commits that are not pushed to remote yet.
      PS1+="\[$LIGHTRED\]⇡$NUM_AHEAD\[$DELIM\]"
    fi
    local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
    if [ $NUM_BEHIND -gt 0 ]; then
      # Commits on remote that have not been pulled yet.
      PS1+="\[$LIGHTCYAN\]⇣$NUM_BEHIND\[$DELIM\]"
    fi
    
    local FLAGS=
    local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
    if ! git diff --quiet 2> /dev/null; then
      # Unstaged changes.●
      FLAGS+="\[$YELLOW\]*\[$DELIM\]"
    fi
    if ! git diff --cached --quiet 2> /dev/null; then
      # Staged changes.
      FLAGS+="\[$LIGHTGREEN\]&\[$DELIM\]"
    fi
    if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
      # In the middle of a merge.
      FLAGS+="\[$LIGHTRED\]Y\[$DELIM\]"
    fi
    
    # Add flags.
    if [ "$FLAGS" != "" ]; then
      PS1+=" $FLAGS"
    fi
    PS1+="\[$DELIM\])"

    # Terminal title shows current repo.
    ROOT_PATH="$(git rev-parse --show-toplevel 2> /dev/null)"
    ROOT_PATH=$(basename $ROOT_PATH)
    set_title $ROOT_PATH
  else
    set_title "Terminal"
  fi
  
  # Actual prompt.
  PS1+="\n"
  if [ $LAST_RESULT = 0 ]; then
    PS1+="\[$GREEN\]:o)"
  else
    PS1+="\[$RED\]:o("
  fi
  PS1+="\[$DELIM\]\$\[$NC\] "
}

if [ "$color_prompt" = "yes" ]; then
  shopt -u promptvars
  PROMPT_COMMAND=update_prompt
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

#PROMPT_DIRTRIM=5
unset color_prompt

# Resize terminal after window size change.
shopt -s checkwinsize

# Customize grep colors.
export GREP_COLORS='sl=49;38;5;254:cx=49;38;5;238:mt=49;38;5;31;1:fn=49;38;5;83:ln=49;38;5;247;3:bn=49;39:se=49;39';

# LESS man page colors (makes Man pages more readable).
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# To prevent issues with quotes, we're setting the layout to US, which is nearly always correct.
setxkbmap -layout us

if [ -d $HOME/bin ]; then
  export PATH=$HOME/bin:$PATH
fi

if [ -d $HOME/.rvm ]; then
  # Load RVM (Ruby Version Manager)
  [[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

  # Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
  export PATH="$PATH:$HOME/.rvm/bin"

  # RVM completion.
  [[ -r $HOME/.rvm/scripts/completion ]] && source $HOME/.rvm/scripts/completion
else
  # Ruby's bundle doesn't know where to install gems otherwise.
  export GEM_HOME=$(ruby -e 'puts Gem.user_dir')
fi

if [ -d $HOME/.nvm ]; then
  # Load NVM (Node Version Manager)
  export NVM_DIR="$HOME/.nvm"
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
  
  # NVM completion.
  [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
fi

# ---------- non-manual additions below -------------------------------

