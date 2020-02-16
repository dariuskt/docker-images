#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "PROJECT ROOT: ${PROJECT_ROOT}"
cd "${PROJECT_ROOT}"


echo -ne "\n\n### Downloading image builder ..."
if [ ! -d imagebuilder ]; then
    wget -qO ib.tar.xz "https://downloads.openwrt.org/releases/$VERSION/targets/ramips/rt305x/openwrt-imagebuilder-$VERSION-ramips-rt305x.Linux-x86_64.tar.xz"
    tar -xf ib.tar.xz
    rm ib.tar.xz
    rm -fr imagebuilder
    mv openwrt-imagebuilder* imagebuilder
fi


cd imagebuilder

echo -e "\n\n### Preparing for build ... "

BUILD_DIR="build_dir/target-mipsel_24kc_musl/linux-ramips_rt305x"
DTB="${BUILD_DIR}/image-A5-V11.dtb"
VMLINUX="${BUILD_DIR}/vmlinux"
KERNEL="${BUILD_DIR}/a5-v11-kernel.bin"
BIN="staging_dir/host/bin"


# backup stuff for repeatability
function mkbak() {
	if [ ! -f "${1}.bak" ]; then
		cp ${1}{,.bak}
	fi
}
mkbak $DTB
mkbak $KERNEL

#mkbak target/linux/ramips/image/rt305x.mk
# to be able to build images bigger then 4MB
# change 4M to 8M for A5-V11 in file:
# target/linux/ramips/image/rt305x.mk

# update partition size in DTB
fdtput -t x $DTB  /palmbus@10000000/spi@b00/m25p80@0/partitions/partition@50000 reg 0x00050000 0x00fb0000

# merge vmlinux and dtb
cat $VMLINUX $DTB > ${VMLINUX}_with_dtb

# compress vmlinux and dtb
$BIN/lzma e -lc1 -lp2 -pb2 ${VMLINUX}_with_dtb{,.lzma}

# make image from vmlinux with dtb lzma
$BIN/mkimage -A mips -O linux -T kernel -C lzma -a 0x80000000 -e 0x80000000 \
	-n "Enlarged Linux" -d ${VMLINUX}_with_dtb.lzma $KERNEL

binwalk $KERNEL.bak
binwalk $KERNEL


echo -e "\n\n### Building image ... "
make clean
make image PROFILE=a5-v11 PACKAGES="luci"



echo -e "\n\n### Moving image to project root a5-v11.*.bin"
mv build_dir/target-mipsel_24kc_musl/linux-ramips_rt305x/tmp/openwrt-*-ramips-rt305x-a5-v11-squashfs-factory.bin ../a5-v11.factory.bin
mv build_dir/target-mipsel_24kc_musl/linux-ramips_rt305x/tmp/openwrt-19.07.1-ramips-rt305x-a5-v11-squashfs-sysupgrade.bin ../a5-v11.sysupgrade.bin



