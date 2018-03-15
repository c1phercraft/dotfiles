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

# Load RVM (Ruby Version Manager)
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

# Define a few Colours
BLACK='\e[0;30m'
BLUE='\e[0;34m'
GREEN='\e[0;32m'
CYAN='\e[0;36m'
RED='\e[0;31m'
PURPLE='\e[0;35m'
BROWN='\e[0;33m'
LIGHTGRAY='\e[0;37m'
DARKGRAY='\e[1;30m'
LIGHTBLUE='\e[1;34m'
LIGHTGREEN='\e[1;32m'
LIGHTCYAN='\e[1;36m'
LIGHTRED='\e[1;31m'
LIGHTPURPLE='\e[1;35m'
YELLOW='\e[1;33m'
WHITE='\e[1;37m'
BOLD='\e[1m'
ITALIC='\e[3m'
UNDERLINE='\e[4m'
NC='\e[0m'              # No Color

# set a fancy prompt (non-color, unless we know we "want" color)
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

if [ "$color_prompt" = yes ]; then
    PS1="\n\[${DARKGRAY}\](\!)-(\j)-(\[${LIGHTGRAY}\]\u@\h\[${DARKGRAY}\])-(\[${YELLOW}\]\w\[${DARKGRAY}\])\n\`if [ \$? = 0 ]; then echo \"\[${GREEN}\]:o)\"; else echo \"\[${RED}\]:o(\"; fi\`\[${DARKGRAY}\]\$\[${NC}\] "
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

#PROMPT_DIRTRIM=5
unset color_prompt

# Resize terminal after window size change.
shopt -s checkwinsize

# LESS man page colors (makes Man pages more readable).
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

if [ -d $HOME/bin ]; then
	export PATH=$HOME/bin:$PATH
fi

# vim: ft=sh
