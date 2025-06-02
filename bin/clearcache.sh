#!/usr/bin/env bash
echo Clearing PageCache
sync;sync;sync
#sudo sh -c "/usr/bin/echo 1 > /proc/sys/vm/drop_caches && swapoff -a && swapon -a && printf '\n%s\n' 'RAM-cache and swap space cleared'"
sudo sh -c "echo 1 > /proc/sys/vm/drop_caches"
