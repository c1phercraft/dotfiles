#
# Bash aliases.
#
alias vi='vim'
alias df='df -hkT'							# Human readable and system type
alias du='du -hk'							# Human readable
alias ls='ls -hF --color=tty'               # classify files in colour
alias ll='ls -alF --group-directories-first'  # long list
alias la='ll -A'                            # all but . and ..
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias path='echo -e ${PATH//:/\\n}'  		# Show the path as a list of paths.

alias version='lsb_release -a;cat /sys/devices/virtual/dmi/id/product_name'   # Version information.
alias kbfix='setxkbmap -layout us'          # Make sure typing quotes works as expected.

alias prettyxml='xmllint --format --xmlout --nsclean'   # Prettify an XML file.
alias undupe="awk \'!x[$0]++\'"             # Removes duplicate lines without sorting.
alias exitdisown='disown -a && exit'        # Exits the shell, leaving background jobs running.

alias psg='ps ux|grep'                      # Lists all user processes matching the given expression.
alias psga='ps aux|grep'                    # Lists all processes matching the given expression.

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias weather='curl wttr.in amsterdam'

alias gw='./gradlew'

# vim: ft=sh
