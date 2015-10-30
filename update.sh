#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

echo "* Updating your local dot files with the remote ones."

git pull origin master;

function update() {
    echo "* Syncing your dot files."
    rsync -i --exclude ".git/" --exclude "update.sh" --exclude "README.md" --exclude "LICENSE" --exclude "*.swp" -avh --no-perms . ~;
}


if [ "$1" == "--force" -o "$1" == "-f" ]; then
    update;
else
    read -p "Are you sure? (y/n) " -n 1;
    echo "";
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        update;
    fi;
fi;

unset update;

