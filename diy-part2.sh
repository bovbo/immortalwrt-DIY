#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

chmod +x files/etc/uci-defaults/* 2>/dev/null

# ===== 修复 daed eBPF 编译：改用 OpenWrt 自带的 llvm-bpf =====
# 关闭 Host 工具链
sed -i 's/CONFIG_BPF_TOOLCHAIN_HOST=y/# CONFIG_BPF_TOOLCHAIN_HOST is not set/' .config
sed -i 's/CONFIG_USE_LLVM_HOST=y/# CONFIG_USE_LLVM_HOST is not set/' .config

# 开启 Build 方式
echo "CONFIG_BPF_TOOLCHAIN_BUILD=y" >> .config
echo "CONFIG_USE_LLVM_BUILD=y" >> .config

# 可选：强制重新生成配置（保险）
./scripts/feeds install -a
make defconfig
