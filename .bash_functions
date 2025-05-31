#
# Bash functions.
#

# Some functions to produce pretty and consistent console output.
log_header() {
    printf "\n${BOLD}${FG_PURPLE}==========  %s  ==========${NC}\n" "$*"
}
log_arrow() {
    printf "➜  $@\n"
}
log_success() {
    printf "${FG_GREEN}✔  %s${NC}\n" "$@"
}
log_error() {
    printf "${FG_RED}✖  %s${NC}\n" "$@"
}
log_warning() {
    printf "${FG_BROWN}➜  %s${NC}\n" "$@"
}
log_note() {
    printf "${BOLD}${FG_BLUE_BRIGHT}Note:${NC}  ${FG_BLUE_BRIGHT}%s${NC}\n" "$@"
}

# Sets title for current terminal window.
settitle()
{
  echo -ne "\e]2;$@\a\e]1;$@\a";
}

# Shows network information for your system
netinfo()
{
    echo "--------------- Network Information ---------------"
    /sbin/ifconfig | awk /'inet addr/ {print $2}'
    /sbin/ifconfig | awk /'Bcast/ {print $3}'
    /sbin/ifconfig | awk /'inet addr/ {print $4}'
    /sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
    myip=`lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g' `
    echo "${myip}"
    echo "---------------------------------------------------"
}

# Find files that match the given pattern.
ff()
{
    find . -type f -iname '*'$*'*' -ls ;
}

# Simple command line calculator.
calc()
{
    awk "BEGIN{ print $* }" ;calc(){ awk "BEGIN{ print $* }" ;}
}

# List which packages are installed on a remote host.
rpkg() {
    ssh $* "dpkg -l | grep ii" | awk '{print $2}'
}

keycode() {
    xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'
}

keys() {
    xfconf-query -c xfce4-keyboard-shortcuts -l -v | cut -d'/' -f4 | awk '{printf "%30s", $2; print "\t" $1}' | sort | uniq
}

# vim: ft=sh
