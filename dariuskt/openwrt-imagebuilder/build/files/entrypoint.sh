#!/bin/bash -x


chown 1000:1000 /home/project/src
cd /home/project/src

if [ ! -f build.sh ]
then
	mv ../build.sh ./
fi

if [ ! -f flash.sh ]
then
	mv ../flash.sh ./
fi


sudo -HEu project bash -lc ./build.sh


