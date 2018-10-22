#!/bin/bash

set -x
set -e

echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/02apt-speedup

apt-get update
apt-get install -y --no-install-recommends make
apt-get install -y python-pip

pip install esptool
pip install nodemcu-uploader


cp -frv /build/files/* / || true


source /usr/local/build_scripts/cleanup_apt.sh


