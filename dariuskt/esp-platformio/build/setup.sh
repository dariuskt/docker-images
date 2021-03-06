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
	python-pip \
	python-wheel \
	python-setuptools \
	python3-distutils \
	make \


# install nodemcu stuff
pip install esptool
pip install nodemcu-uploader
pip install adafruit-ampy


# platformio
pip install virtualenv
sudo -HEu project code --install-extension platformio.platformio-ide --force
ln -s /home/project/.platformio/penv/bin/platformio /usr/local/bin/platformio
ln -s /home/project/.platformio/penv/bin/pio /usr/local/bin/pio
ln -s /home/project/.platformio/penv/bin/piodebuggdb /usr/local/bin/piodebuggdb


sudo -HEu project xvfb-run code --verbose 2>&1 | tee /tmp/vscode &
timeout=60
while [ $timeout -gt 0 ]
do
	if grep -Fq 'update#setState checking for updates' </tmp/vscode
	then
		break
	else
		sleep 1
		((timeout--))
	fi
done
sleep 30
killall code || true


sudo -HEu project pio platform install espressif8266 espressif32

# prepare user for ttyUSB access
usermod -a -G dialout project


cp -frv /build/files/* / || true

chown -R 1000:1000 /home/project

source /usr/local/build_scripts/cleanup_apt.sh


