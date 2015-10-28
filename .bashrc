# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Completion options
[[ -f /etc/bash_completion ]] && . /etc/bash_completion

# Aliases
if [ -f "${HOME}/.bash_aliases" ]; then
  source "${HOME}/.bash_aliases"
fi

alias df='df -h'
alias du='du -h'
alias grep='grep --color'                     # show differences in colour
alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour
alias ls='ls -hF --color=tty'                 # classify files in colour
alias ll='ls -l'                              # long list
alias la='ls -A'                              # all but . and ..

# Functions
if [ -f "${HOME}/.bash_functions" ]; then
  source "${HOME}/.bash_functions"
fi

settitle () 
{ 
  echo -ne "\e]2;$@\a\e]1;$@\a"; 
}

