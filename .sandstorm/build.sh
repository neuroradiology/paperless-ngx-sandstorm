#!/bin/bash
set -euo pipefail

here="$(realpath $(dirname $0))"

if [ ! -e /opt/paperless ]; then
    sudo git clone https://github.com/paperless-ngx/paperless-ngx /opt/paperless
	sudo git config --global --add safe.directory /opt/paperless
fi

cd /opt/paperless
sudo git pull

sudo pipenv lock
sudo pipenv install --skip-lock