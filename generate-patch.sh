#!/bin/bash

set -e

VERSION=6.12.6
HASH=v24.10.1

rm -rf openwrt
rm -rf backports*
rm -f 0001-mac80211.patch

git clone https://github.com/openwrt/openwrt.git
cd openwrt
git checkout $HASH
cd ..

wget http://mirror2.openwrt.org/sources/backports-$VERSION.tar.xz
tar xvJf backports-$VERSION.tar.xz
cd backports-$VERSION/

git init
git add .
git commit -m "init"

for patch in ../openwrt/package/kernel/mac80211/patches/build/*.patch; do
	patch -p1 < $patch
done

for patch in ../openwrt/package/kernel/mac80211/patches/subsys/*.patch; do
	patch -p1 < $patch
done

for patch in ../openwrt/package/kernel/mac80211/patches/ath/*.patch; do
	patch -p1 < $patch
done

for patch in ../openwrt/package/kernel/mac80211/patches/ath5k/*.patch; do
	patch -p1 < $patch
done

for patch in ../openwrt/package/kernel/mac80211/patches/ath10k/*.patch; do
	patch -p1 < $patch
done

for patch in ../openwrt/package/kernel/mac80211/patches/ath11k/*.patch; do
	patch -p1 < $patch
done

for patch in ../openwrt/package/kernel/mac80211/patches/rt2x00/*.patch; do
	patch -p1 < $patch
done

for patch in ../openwrt/package/kernel/mac80211/patches/mt7601u/*.patch; do
	patch -p1 < $patch
done

for patch in ../openwrt/package/kernel/mac80211/patches/mwl/*.patch; do
	patch -p1 < $patch
done

for patch in ../openwrt/package/kernel/mac80211/patches/brcm/*.patch; do
	patch -p1 < $patch
done

rm -rf include/linux/ssb/ include/linux/bcma/ include/net/bluetooth

rm -f include/linux/cordic.h include/linux/crc8.h include/linux/eeprom_93cx6.h include/linux/wl12xx.h include/linux/mhi.h include/net/ieee80211.h backport-include/linux/bcm47xx_nvram.h

echo 'compat-wireless-6.9.9-1-r27299-66559946ac' > compat_version

git add .
git commit -m "mac80211"
git format-patch HEAD~1
mv 0001-mac80211.patch ..
