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



echo -ne "\n\n# updating partition in DTS/DTB"

BUILD_DIR="build_dir/target-mipsel_24kc_musl/linux-ramips_rt305x"
DTC="${BUILD_DIR}/linux-4.14.*/scripts/dtc/dtc"
DTS="target/linux/ramips/dts/A5-V11.dts"
DTB="${BUILD_DIR}/image-A5-V11.dtb"
VMLINUX="${BUILD_DIR}/vmlinux"
UIMAGE="${BUILD_DIR}/uImage.lzma"
BIN="staging_dir/host/bin"
KERNEL="${BUILD_DIR}/a5-v11-kernel.bin"


echo "### compile new DTB with bigger partition"

$DTC -I dtb -O dts -f $DTB \
| sed 's/0x50000 0x3b0000/0x50000 0xfb0000/' \
> $DTS
$DTC -I dts -O dtb -o $DTB.new $DTS

echo "### put new dtb into the image"
cat ${VMLINUX} $DTB.new > ${VMLINUX}_a5-v11-16m

echo "### lzma magic"
${BIN}/lzma e ${VMLINUX}_a5-v11-16m -lc1 -lp2 -pb2 ${VMLINUX}_a5-v11-16m.lzma

$BIN/mkimage -A mips -O linux -T kernel -C lzma -a 0x80000000 -e 0x80000000 \
	-n "Enlarged Linux" -d ${VMLINUX}_a5-v11-16m.lzma $KERNEL


echo -ne "\n\n# Building image"
make image PROFILE=a5-v11 PACKAGES="luci -dnsmasq -ppp-mod-pppoe -ppp -kmod-nf-reject6 -kmod-nf-conntrack6 -kmod-nf-ipt6 -kmod-ip6tables -libip6tc2 -odhcp6c -odhcpd-ipv6only -ip6tables"



echo Moving image to project root a5-v11.*.bin
mv -f build_dir/target-mipsel_24kc_musl/linux-ramips_rt305x/tmp/openwrt-*-ramips-rt305x-a5-v11-squashfs-factory.bin ../a5-v11.factory.bin
mv -f build_dir/target-mipsel_24kc_musl/linux-ramips_rt305x/tmp/openwrt-*-ramips-rt305x-a5-v11-squashfs-sysupgrade.bin ../a5-v11.sysupgrade.bin

