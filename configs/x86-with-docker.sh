#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${SCRIPT_DIR}/x86-openwrt.sh

CONFIG_NAME="_docker"

cd openwrt

cat >>.config <<-EOF
CONFIG_PACKAGE_docker-compose=y
CONFIG_PACKAGE_luci-app-dockerman=y

## target
CONFIG_TARGET_x86=y
CONFIG_TARGET_x86_64=y
CONFIG_TARGET_x86_64_DEVICE_generic=y

## app
CONFIG_PACKAGE_luci-app-acme=n
CONFIG_PACKAGE_luci-app-omcproxy=y
CONFIG_PACKAGE_luci-app-sqm=n
CONFIG_PACKAGE_acme-dnsapi=n

## USB Storage
CONFIG_PACKAGE_kmod-usb-storage=y
CONFIG_PACKAGE_kmod-usb-storage-extras=y

## USB utils
CONFIG_PACKAGE_usbutils=y

## File System
CONFIG_PACKAGE_fdisk=y
CONFIG_PACKAGE_kmod-fs-exfat=y
CONFIG_PACKAGE_kmod-fs-ext4=y
CONFIG_PACKAGE_kmod-fs-vfat=y
CONFIG_PACKAGE_kmod-fs-ntfs=y

## Language
CONFIG_PACKAGE_kmod-nls-cp936=y

EOF

sed -i 's/^[ \t]*//g' ./.config
make defconfig
# 网络配置信息，将从 zzz-default-settings 文件的第2行开始添加
sed -i "2i # network config" ./package/emortal/default-settings/files/99-default-settings
# 默认 IP 地址，旁路由时不会和主路由的 192.168.1.1 冲突
sed -i "3i uci set network.lan.ipaddr='192.168.22.252'" ./package/emortal/default-settings/files/99-default-settings
sed -i "4i uci set network.lan.proto='static'" ./package/emortal/default-settings/files/99-default-settings
#sed -i "23d" ./packages/net/udpxy/Makefile
#sed -i "11,16c PKG_VERSION:=1.0-25.1\PKG_RELEASE:=1\PKG_SOURCE_PROTO:=git\PKG_SOURCE_URL:=https://github.com/haisongliang/udpxy.git\PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)\PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz\PKG_MIRROR_HASH:=de19890237c99b8f9951e6d43e2b269ecaf44d16" ./packages/net/udpxy/Makefile


cd ..
