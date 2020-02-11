#!/bin/bash -x

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "PROJECT ROOT: ${PROJECT_ROOT}"
cd "${PROJECT_ROOT}"



wget -qO ib.tar.xz "https://downloads.openwrt.org/releases/$VERSION/targets/ramips/rt305x/openwrt-imagebuilder-$VERSION-ramips-rt305x.Linux-x86_64.tar.xz"
tar -xf ib.tar.xz
rm ib.tar.xz
mv openwrt-imagebuilder* imagebuilder



cd imagebuilder

echo updating partition in DTS
sed -i 's/0x50000 0x3b0000/0x50000 0xfb0000/' target/linux/ramips/dts/A5-V11.dts

echo Building image
make image PROFILE=a5-v11 PACKAGES="-dnsmasq -ppp-mod-pppoe -ppp -kmod-nf-reject6 -kmod-nf-conntrack6 -kmod-nf-ipt6 -kmod-ip6tables -libip6tc2 -odhcp6c -odhcpd-ipv6only -ip6tables"

echo Moving image to project root a5-v11.*.bin
mv build_dir/target-mipsel_24kc_musl/linux-ramips_rt305x/tmp/openwrt-*-ramips-rt305x-a5-v11-squashfs-factory.bin ../a5-v11.factory.bin
mv build_dir/target-mipsel_24kc_musl/linux-ramips_rt305x/tmp/openwrt-19.07.1-ramips-rt305x-a5-v11-squashfs-sysupgrade.bin ../a5-v11.sysupgrade.bin



