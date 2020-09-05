#!/bin/bash -x

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "PROJECT ROOT: ${PROJECT_ROOT}"
cd "${PROJECT_ROOT}"


if [ ! -d imagebuilder ]; then
	wget -qO ib.tar.xz "https://downloads.openwrt.org/releases/$VERSION/targets/ramips/rt305x/openwrt-imagebuilder-$VERSION-ramips-rt305x.Linux-x86_64.tar.xz"
	tar -xf ib.tar.xz
	rm ib.tar.xz
	mv openwrt-imagebuilder* imagebuilder
fi



cd imagebuilder




echo -ne "\n\n# Building image"
make clean
make image PROFILE=a5-v11 PACKAGES="luci -dnsmasq -ppp-mod-pppoe -ppp -kmod-nf-reject6 -kmod-nf-conntrack6 -kmod-nf-ipt6 -kmod-ip6tables -libip6tc2 -odhcp6c -odhcpd-ipv6only -ip6tables"




echo -ne "\n\n# updating partition in DTS/DTB"

BUILD_DIR="build_dir/target-mipsel_24kc_musl/linux-ramips_rt305x"
DTC="${BUILD_DIR}/linux-4.14.167/scripts/dtc/dtc"
DTS="target/linux/ramips/dts/A5-V11.dts"
DTB="${BUILD_DIR}/image-A5-V11.dtb"
VMLINUX="${BUILD_DIR}/vmlinux"
UIMAGE="${BUILD_DIR}/uImage.lzma"
BIN="staging_dir/host/bin"

echo "### compile new DTB with bigger partition"

$DTC -I dtb -O dts -f $DTB \
| sed 's/0x50000 0x3b0000/0x50000 0xfb0000/' \
> $DTS
rm -f $DTB
$DTC -I dts -O dtb -o $DTB $DTS

echo "### backup original vmlinux"
cp -f ${VMLINUX} ${VMLINUX}-a5-v11
echo "### put new dtb into the image"
#${BIN}/patch-dtb ${VMLINUX}-a5-v11 $DTB 8192
echo "### lzma magic"
#${BIN}/lzma e ${VMLINUX}-a5-v11 -lc1 -lp2 -pb2 ${VMLINUX}-a5-v11.lzma



echo Moving image to project root a5-v11.*.bin
mv -f build_dir/target-mipsel_24kc_musl/linux-ramips_rt305x/tmp/openwrt-*-ramips-rt305x-a5-v11-squashfs-factory.bin ../a5-v11.factory.bin
mv -f build_dir/target-mipsel_24kc_musl/linux-ramips_rt305x/tmp/openwrt-*-ramips-rt305x-a5-v11-squashfs-sysupgrade.bin ../a5-v11.sysupgrade.bin


