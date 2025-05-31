dotdir=.dotfiles
dotdir_backup=.dotfiles-backup

# Clone the dot file repo.
git clone --bare git@github.com:c1phercraft/dotfiles.git $HOME/$dotdir

# Prep the command to use.
function dotfiles {
   /usr/bin/git --git-dir=$HOME/$dotdir/ --work-tree=$HOME $@
}

# Try to checkout the repo.
mkdir -p ${dotdir_backup}
dotfiles checkout

if [ $? != 0 ]; then
  # Some dotfiles already exist; let's backup them.
  echo "Backing up pre-existing dotfiles."
  dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} ${dotdir_backup}/{}

  # And try the checkout again.
  dotfiles checkout
fi

dotfiles config status.showUntrackedFiles no
echo "Dotfiles ready."

