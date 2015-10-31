#
# Bash aliases.
#

alias vi='vim'
alias df='df -hkT'														# Human readable and system type
alias du='du -hk'															# Human readable
alias ls='ls -hF --color=tty'                 # classify files in colour
alias ll='ls -alF --group-directories-first'  # long list
alias la='ll -A'                              # all but . and ..
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias path='echo -e ${PATH//:/\\n}'  					# Show the path as a list of paths.

alias version='lsb_release -a'                # Version information.
alias kbfix='setxkbmap -layout us'            # Make sure typing quotes works as expected.

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# vim: ft=sh
