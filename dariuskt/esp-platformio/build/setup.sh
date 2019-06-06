#!/bin/bash

set -x
set -e

echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/02apt-speedup


apt-get update


# vscode

wget -O /tmp/vscode.deb 'https://go.microsoft.com/fwlink/?LinkID=760868'
dpkg -i /tmp/vscode.deb || true
apt-get install -y --no-install-recommends --fix-broken

apt-get install -y --no-install-recommends \
	libx11-xcb1 \
	libxtst6 \
	libasound2 \
	x11-apps \
	xvfb \
	xauth \


# platformio

sudo -HEu project code --install-extension platformio.platformio-ide --force
ln -s /home/project/.platformio/penv/bin/platformio /usr/local/bin/platformio
ln -s /home/project/.platformio/penv/bin/pio /usr/local/bin/pio
ln -s /home/project/.platformio/penv/bin/piodebuggdb /usr/local/bin/piodebuggdb


# TODO:
sudo -HEu project xvfb-run code --verbose &
sleep 45
killall code || true

sudo -HEu project pio platform install espressif8266 espressif32



cp -frv /build/files/* / || true


source /usr/local/build_scripts/cleanup_apt.sh


