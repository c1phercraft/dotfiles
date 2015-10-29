# vim: ft=sh

alias vi='vim'
alias df='df -h'
alias du='du -h'
alias grep='grep --color=auto'                # show differences in colour
alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour
alias ls='ls -hF --color=tty'                 # classify files in colour
alias ll='ls -alF'                              # long list
alias la='ls -A'                              # all but . and ..
alias l='ls -CF'
alias ..='cd ..'
alias version='lsb_release -a'                # Version information.
alias kbfix='setxkbmap -layout us'            # Make sure typing quotes works as expected.

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

