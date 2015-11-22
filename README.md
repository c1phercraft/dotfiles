# dotfiles
The Linux dot files I use on various machines

There are a few files that are checked if they exist, and when they do are included. If there is a `~/bin directory`, it will be added to the `$PATH`. If there is a `~/bin/bashrc` file, it will be sourced. I use the latter for location specific stuff, or work items that I do not want to make public here.
There's also a check on `~/.bash_completion`. I plan to put any specific completion items in there in the future, once I will add some of the `~/bin/*` scripts that I use here too.

