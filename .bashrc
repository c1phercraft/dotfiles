# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Aliases
[[ -f "${HOME}/.bash_aliases" ]] && source "${HOME}/.bash_aliases"

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

# Load RVM (Ruby Version Manager)
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

# set a fancy prompt (non-color, unless we know we "want" color)
color_prompt=
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
    color_prompt=yes
fi

if [ "$color_prompt" = yes ]; then
    PS1="\n\[\e[30;1m\](\!)-(\j)-(\[\e[0m\]\u@\h\[\e[30;1m\])-(\[\e[1;33m\]\w\[\e[0m\]\[\e[30;1m\])\[\e[0m\]\n\`if [ \$? = 0 ]; then echo \[\e[32m\]:o\)\[\e[0m\]; else echo \[\e[31m\]:o\(\[\e[0m\]; fi\`\[\e[30;1m\]\\$\[\e[0m\] "
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

#PROMPT_DIRTRIM=5
unset color_prompt

export PATH=$HOME/bin:$PATH

