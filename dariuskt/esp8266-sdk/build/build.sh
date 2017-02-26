#!/bin/bash

set -x
set -e

echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/02apt-speedup


apt-get update
apt-get install -y --no-install-recommends \
	openssh-client \
	make autoconf automake libtool gcc g++ gperf \
	flex bison texinfo gawk ncurses-dev libexpat-dev python python-serial sed \
	git unzip bash help2man \
	libtool-bin \
	minicom \



cp -frv /build/files/* /


sudo -iu user /tmp/init.sh
rm /tmp/init.sh


source /usr/local/build_scripts/cleanup_apt.sh

