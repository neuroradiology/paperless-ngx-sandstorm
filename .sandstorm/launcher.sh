#!/bin/bash

set -euo pipefail

VENV=/opt/app-venv

wait_for() {
    local service=$1
    local file=$2
    while [ ! -e "$file" ] ; do
        echo "waiting for $service to be available at $file."
        sleep .1
    done
}

# something something folders
mkdir -p /var/consume
mkdir -p /var/data
mkdir -p /var/media
mkdir -p /var/log
# Wipe /var/run, since pidfiles and socket files from previous launches should go away
# TODO someday: I'd prefer a tmpfs for these.
rm -rf /var/run
mkdir -p /var/run
rm -rf /var/tmp
mkdir -p /var/tmp

# Rotate log files larger than 512K
log_files="$(find /var/log -type f -name '*.log')"
for f in $log_files; do
    if [ $(du -b "$f" | awk '{print $1}') -ge $((512 * 1024)) ] ; then
        mv $f $f.1
    fi
done

redis-server --daemonize yes

cd /opt/paperless/src
$VENV/bin/python3 manage.py migrate
$VENV/bin/python3 manage.py runserver