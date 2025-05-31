#
# Bash RC-file.
#

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Aliases
[[ -f "${HOME}/.bash_aliases" ]] && source "${HOME}/.bash_aliases"
[[ -f "${HOME}/.git_aliases" ]] && source "${HOME}/.git_aliases" 2>/dev/null # To prevent lock file issue.

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

# Color indices.
#BLACK_INDEX=0
#RED_INDEX=1
#GREEN_INDEX=2
#BROWN_INDEX=3
#BLUE_INDEX=4
#PURPLE_INDEX=5
#CYAN_INDEX=6
#DARKGRAY_INDEX=7
#WHITE_INDEX=7
#DEFAULT_INDEX=9

# Foreground.
FG_BLACK="$(tput setaf 0)"
FG_RED="$(tput setaf 1)"
FG_GREEN="$(tput setaf 2)"
FG_BROWN="$(tput setaf 3)"
FG_BLUE="$(tput setaf 4)"
FG_PURPLE="$(tput setaf 5)"
FG_CYAN="$(tput setaf 6)"
FG_DARKGRAY="$(tput setaf 7)"

# Bright foreground.
FG_GRAY_BRIGHT="$(tput setaf 8)"
FG_RED_BRIGHT="$(tput setaf 9)"
FG_GREEN_BRIGHT="$(tput setaf 10)"
FG_BROWN_BRIGHT="$(tput setaf 11)"
FG_BLUE_BRIGHT="$(tput setaf 12)"
FG_PURPLE_BRIGHT="$(tput setaf 13)"
FG_CYAN_BRIGHT="$(tput setaf 14)"
FG_WHITE="$(tput setaf 15)"

# Background.
BG_BLACK="$(tput setab 0)"
BG_RED="$(tput setab 1)"
BG_GREEN="$(tput setab 2)"
BG_BROWN="$(tput setab 3)"
BG_BLUE="$(tput setab 4)"
BG_PURPLE="$(tput setab 5)"
BG_CYAN="$(tput setab 6)"
BG_DARKGRAY="$(tput setab 7)"

# Bright background.
BG_BLACK_BRIGHT="$(tput setab 8)"
BG_RED_BRIGHT="$(tput setab 9)"
BG_GREEN_BRIGHT="$(tput setab 10)"
BG_BROWN_BRIGHT="$(tput setab 11)"
BG_BLUE_BRIGHT="$(tput setab 12)"
BG_PURPLE_BRIGHT="$(tput setab 13)"
BG_CYAN_BRIGHT="$(tput setab 14)"
BG_DARKGRAY_BRIGHT="$(tput setab 15)"

BOLD="$(tput bold)"
ITALIC="$(tput sitm)"
UNDERLINE="$(tput smul)"
NC="$(tput sgr0)"  # No color.

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

echo_right() {
  local line=$1
  columns="$(tput cols)"
  printf "%*s" $columns "$line"
}

START_CAP=
END_CAP=

update_prompt() {
  local LAST_RESULT=$?
  
  # Day and time.
  PS1="\n\[$FG_DARKGRAY\]$START_CAP\[$NC$FG_BLACK$BG_DARKGRAY\]\D{%d}\[$NC$FG_DARKGRAY\]$END_CAP"
  PS1+="\[$FG_BLUE\]$START_CAP\[$FG_BLACK$BG_BLUE\]\D{%H%M}\[$NC$FG_BLUE\]$END_CAP"
  # Number of jobs.
  PS1+="\[$FG_DARKGRAY\]$START_CAP\[$FG_BLACK$BG_DARKGRAY\]\j\[$NC$FG_DARKGRAY\]$END_CAP"
  # User and host.
  PS1+="\[$FG_BLUE\]$START_CAP\[$FG_BLACK$BG_BLUE\]\u@\h\[$NC$FG_BLUE\]$END_CAP"
  # Current working directory.
  PS1+="\[$FG_BROWN\]$START_CAP\[$FG_BLACK$BG_BROWN\]\w\[$NC$FG_BROWN\]$END_CAP"
  
  if `git rev-parse --is-inside-work-tree 2> /dev/null`; then
    # Inside a Git repo, so add more information.

    local ICON_AHEAD='⇡'
    local ICON_BEHIND='⇣'
    local ICON_UNSTAGED='↥'
    local ICON_STAGED='⤒'
    local ICON_MERGING='ᛣ'
    local ICON_REBASING='⇈'

    local FG_GIT=$FG_GREEN
    local BG_GIT=$BG_GREEN
    local FLAGS=
    local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
    if [ $NUM_AHEAD -gt 0 ]; then
      # Commits that are not pushed to remote yet.
      FLAGS+=" $ICON_AHEAD$NUM_AHEAD"
      FG_GIT=$FG_CYAN
      BG_GIT=$BG_CYAN
    fi
    local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
    if [ $NUM_BEHIND -gt 0 ]; then
      # Commits on remote that have not been pulled yet.
      FLAGS+=" $ICON_BEHIND$NUM_BEHIND"
      FG_GIT=$FG_CYAN
      BG_GIT=$BG_CYAN
    fi
    
    local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
    if ! git diff --quiet 2> /dev/null; then
      # Unstaged changes.
      FLAGS+=" $ICON_UNSTAGED"
      FG_GIT=$FG_CYAN
      BG_GIT=$BG_CYAN
    fi
    if ! git diff --cached --quiet 2> /dev/null; then
      # Staged changes.
      FLAGS+=" $ICON_STAGED"
      FG_GIT=$FG_CYAN
      BG_GIT=$BG_CYAN
    fi
    if git rebase --show-current-patch 2> /dev/null; then
      # Rebase on-going.
      FLAGS+=" $ICON_REBASING"
      FG_GIT=$FG_RED
      BG_GIT=$BG_RED
    fi
    if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
      # In the middle of a merge.
      FLAGS+=" $ICON_MERGING"
      FG_GIT=$FG_RED
      BG_GIT=$BG_RED
    fi
    
    # Git branch.
    BRANCH="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
    PS1+="\[$NC$FG_GIT\]$START_CAP\[$FG_WHITE$BG_GIT\] \[$ITALIC\]$BRANCH\[$NC\]"

    # Add flags.
    if [ "$FLAGS" != "" ]; then
        PS1+="\[$FG_WHITE$BG_GIT\]$FLAGS \[$NC$FG_GIT\]$END_CAP"
    else
        PS1+="\[$NC$FG_GIT\]$END_CAP"
    fi

    # Terminal title shows current repo.
    ROOT_PATH="$(git rev-parse --show-toplevel 2> /dev/null)"
    ROOT_PATH=$(basename $ROOT_PATH)
    set_title $ROOT_PATH
  else
    set_title "Terminal"
  fi
  
  # Actual prompt.
  PS1+="$NC\n"
  if [ $LAST_RESULT == 0 ]; then
    PS1+="\[$FG_GREEN\]:o)"
  else
    PS1+="\[$FG_RED\]:o("
  fi
  PS1+="\[$FG_GRAY_BRIGHT\]\$\[$NC\] "
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

# To work with my dotfile repo.
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# ---------- non-manual additions below -------------------------------

