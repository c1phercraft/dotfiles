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
    printf "${FG_YELLOW}➜  %s${NC}\n" "$@"
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
    ip_info=$(/usr/sbin/ip -o -f inet address | grep ' brd ')
    internal_ip=$(echo $ip_info | awk '{print $4}')
    broadcast_ip=$(echo $ip_info | awk '{print $6}')
    mac_addr=$(/usr/sbin/ip -o -f inet -br link | awk /' UP / {print $3}')
    echo "Internal IP : ${internal_ip}"
    echo "Broadcast IP: ${broadcast_ip}"
    echo "MAC/HW addr : ${mac_addr}"
    external_ip=$(curl -s http://checkip.dyndns.org:8245/ | sed -n 's/.*Current IP Address: \([0-9.]*\).*/\1/p')
    echo "External IP : ${external_ip}"
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

version() {
  # OS + machine info
  lsb_release -a 2>/dev/null
  cat /sys/devices/virtual/dmi/id/product_name 2>/dev/null || true
  echo

  # Monitor info (Model, Size, Diagonal)
  hwinfo --monitor | awk '
    # When Model: line is found
    /Model:/ {
      s=$0
      sub(/.*Model: "/,"",s)
      sub(/".*/,"",s)
      model=s
    }

    # When Size: line is found
    /Size:/ {
      s=$0
      sub(/.*Size: */,"",s)
      # Extract mm values for diagonal calculation
      split(s, dims, " ")
      w_mm = dims[1]
      h_mm = dims[3]

      # Convert mm → inches
      w_in = w_mm / 25.4
      h_in = h_mm / 25.4
      diag = sqrt(w_in*w_in + h_in*h_in)

      # Print final line
      printf "%s - %s (%.1f\")\n", model, s, diag
    }
  '
}

# vim: ft=sh
