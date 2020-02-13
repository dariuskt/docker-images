#!/bin/bash

set -x
set -e

apt-get update


apt-get install -y --no-install-recommends \
	subversion g++ zlib1g-dev build-essential git python python3 \
	libncurses5-dev gawk gettext unzip file libssl-dev wget \
	libelf-dev ecj fastjar java-propose-classpath \
	python3-distutils \
	libncursesw5-dev xsltproc file device-tree-compiler binwalk \



cp -frv /build/files/* / || true
chown -R 1000:1000 /home/project

source /usr/local/build_scripts/cleanup_apt.sh


