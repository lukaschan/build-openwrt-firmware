#!/bin/bash

(git clone https://github.com/immortalwrt/immortalwrt openwrt  && git clone https://github.com/kiddin9/openwrt-packages openwrt) || (cd openwrt && git stash && git pull)

cd openwrt
echo "src-git kiddin9 https://github.com/kiddin9/openwrt-packages.git" >> feeds.conf.default
echo "src-git xiaorouji https://github.com/xiaorouji/openwrt-passwall.git;packages" >> feeds.conf.default
echo "src-git xiaorouji2 https://github.com/xiaorouji/openwrt-passwall2.git;main" >> feeds.conf.default

./scripts/feeds update -a
./scripts/feeds install -a
