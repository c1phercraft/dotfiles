#
# Bash functions.
#

# Sets title for current terminal window.
settitle ()
{
  echo -ne "\e]2;$@\a\e]1;$@\a";
}

# Shows network information for your system
netinfo ()
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
function ff()
{
    find . -type f -iname '*'$*'*' -ls ;
}

# vim: ft=sh
