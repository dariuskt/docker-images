#!/bin/bash

set -x
set -e

apt-get update


apt-get install -y --no-install-recommends \
	lxi-tools \



cp -frv /build/files/* / || true
chown -R 1000:1000 /home/project

source /usr/local/build_scripts/cleanup_apt.sh


