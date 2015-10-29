# vim: ft=sh

# Sets title for current terminal window.
settitle ()
{
  echo -ne "\e]2;$@\a\e]1;$@\a";
}

