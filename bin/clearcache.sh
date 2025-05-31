#!/usr/bin/env bash
echo Clearing PageCache
sync;sync;sync
sudo sh -c "echo 1 > /proc/sys/vm/drop_caches"

