#
# Bash functions.
#

# Some functions to produce pretty and consistent console output.
e_header() {
    printf "\n${BOLD}${PURPLE}==========  %s  ==========${NC}\n" "$*"
}
e_arrow() {
    printf "➜  $@\n"
}
e_success() {
    printf "${GREEN}✔  %s${NC}\n" "$@"
}
e_error() {
    printf "${RED}✖  %s${NC}\n" "$@"
}
e_warning() {
    printf "${YELLOW}➜  %s${NC}\n" "$@"
}
e_note() {
    printf "${BOLD}${LIGHTBLUE}Note:${NC}  ${LIGHTBLUE}%s${NC}\n" "$@"
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

# vim: ft=sh
