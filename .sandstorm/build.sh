#!/bin/bash
set -euo pipefail

VENV=/opt/app-venv
if [ ! -d $VENV ] ; then
    sudo mkdir -p $VENV -m777
    virtualenv $VENV
else
    echo "$VENV exists, moving on"
fi

if [ ! -e /opt/paperless ]; then
    sudo git clone https://github.com/paperless-ngx/paperless-ngx /opt/paperless
	sudo git config --global --add safe.directory /opt/paperless
fi

sudo cp /opt/app/paperless.conf /opt/paperless/paperless.conf

cd /opt/paperless
sudo git pull

sudo sh -c 'pipenv requirements > requirements.txt'
$VENV/bin/pip install -r /opt/paperless/requirements.txt