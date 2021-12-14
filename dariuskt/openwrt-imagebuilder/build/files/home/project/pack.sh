#!/bin/bash


cp uboot.img full.img

dd if=/dev/null of=full.img bs=1 count=1 seek=$((0x0040000))
cat factory.img >> full.img

dd if=/dev/null of=full.img bs=1 count=1 seek=$((0x0050000))
cat uboot.img >> full.img

dd if=/dev/null of=full.img bs=1 count=1 seek=$((0x1000000))



