#!/bin/bash

set -e

VERSION=6.18.7
HASH=v25.12.0-rc5

rm -rf openwrt
rm -rf backports*
rm -f 0001-mac80211.patch

git clone https://github.com/openwrt/openwrt.git
cd openwrt
git checkout $HASH
cd ..

wget https://github.com/openwrt/backports/releases/download/backports-v$VERSION/backports-$VERSION.tar.zst
tar --zstd -xvf backports-$VERSION.tar.zst
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

for patch in ../openwrt/package/kernel/mac80211/patches/ath9k/*.patch; do
	patch -p1 < $patch
done

for patch in ../openwrt/package/kernel/mac80211/patches/ath10k/*.patch; do
	patch -p1 < $patch
done

for patch in ../openwrt/package/kernel/mac80211/patches/ath11k/*.patch; do
	patch -p1 < $patch
done

for patch in ../openwrt/package/kernel/mac80211/patches/ath12k/*.patch; do
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

for patch in ../openwrt/package/kernel/mac80211/patches/rtl/*.patch; do
	[ -e "$patch" ] || continue
	patch -p1 < $patch
done

rm -rf include/linux/ssb/ include/linux/bcma/ include/net/bluetooth

rm -f include/linux/cordic.h include/linux/crc8.h include/linux/eeprom_93cx6.h include/linux/wl12xx.h include/linux/mhi.h include/net/ieee80211.h backport-include/linux/bcm47xx_nvram.h

echo "compat-wireless-$VERSION-1-$HASH" > compat_version

git add .
git commit -m "mac80211"
git format-patch HEAD~1
mv 0001-mac80211.patch ..
