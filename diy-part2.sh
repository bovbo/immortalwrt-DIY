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
#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
#

chmod +x files/etc/uci-defaults/* 2>/dev/null

# ============================================================
# 1. 直接删掉有问题的源码（最关键，防止被编译）
# ============================================================
rm -rf feeds/smpackage/mihomo
rm -rf feeds/packages/net/geoview
rm -rf feeds/packages/net/daed
rm -rf feeds/packages/net/dae
rm -rf package/feeds/*/mihomo
rm -rf package/feeds/*/geoview
rm -rf package/feeds/*/daed
rm -rf package/feeds/*/dae
rm -rf package/feeds/*/luci-app-fchomo
rm -rf package/feeds/*/luci-app-daede

# ============================================================
# 2. 强制在 .config 里关闭
# ============================================================
sed -i 's/CONFIG_PACKAGE_mihomo=y/# CONFIG_PACKAGE_mihomo is not set/' .config
sed -i 's/CONFIG_PACKAGE_geoview=y/# CONFIG_PACKAGE_geoview is not set/' .config
sed -i 's/CONFIG_PACKAGE_luci-app-fchomo=y/# CONFIG_PACKAGE_luci-app-fchomo is not set/' .config
sed -i 's/CONFIG_PACKAGE_daed=y/# CONFIG_PACKAGE_daed is not set/' .config
sed -i 's/CONFIG_PACKAGE_dae=y/# CONFIG_PACKAGE_dae is not set/' .config
sed -i 's/CONFIG_PACKAGE_luci-app-daede=y/# CONFIG_PACKAGE_luci-app-daede is not set/' .config
sed -i 's/CONFIG_PACKAGE_luci-app-dae=y/# CONFIG_PACKAGE_luci-app-dae is not set/' .config

# 关闭自己编 llvm（不需要）
sed -i 's/CONFIG_BPF_TOOLCHAIN_BUILD_LLVM=y/# CONFIG_BPF_TOOLCHAIN_BUILD_LLVM is not set/' .config
sed -i 's/CONFIG_BPF_TOOLCHAIN_HOST=y/# CONFIG_BPF_TOOLCHAIN_HOST is not set/' .config

# ============================================================
# 3. 保留内核 eBPF/BTF（daed 运行时需要）
# ============================================================
echo "CONFIG_KERNEL_DEBUG_INFO=y" >> .config
echo "CONFIG_KERNEL_DEBUG_INFO_BTF=y" >> .config
echo "CONFIG_KERNEL_CGROUP_BPF=y" >> .config
echo "CONFIG_KERNEL_BPF_EVENTS=y" >> .config
echo "CONFIG_KERNEL_XDP_SOCKETS=y" >> .config
echo "CONFIG_PACKAGE_kmod-sched-bpf=y" >> .config
echo "CONFIG_PACKAGE_kmod-xdp-sockets-diag=y" >> .config
echo "CONFIG_PACKAGE_bpftool=y" >> .config
# ============================================================
# 3. 强制保留内核 eBPF / BTF 支持（daed 运行必需）
# ============================================================
# 基础调试与 BTF
echo "CONFIG_DEVEL=y" >> .config
echo "CONFIG_KERNEL_DEBUG_INFO=y" >> .config
echo "CONFIG_KERNEL_DEBUG_INFO_REDUCED=n" >> .config
echo "CONFIG_KERNEL_DEBUG_INFO_BTF=y" >> .config
echo "CONFIG_DEBUG_INFO=y" >> .config
echo "CONFIG_DEBUG_INFO_BTF=y" >> .config

# BPF 核心
echo "CONFIG_BPF=y" >> .config
echo "CONFIG_BPF_SYSCALL=y" >> .config
echo "CONFIG_BPF_JIT=y" >> .config
echo "CONFIG_HAVE_EBPF_JIT=y" >> .config
echo "CONFIG_BPF_JIT_ALWAYS_ON=y" >> .config

# Cgroup BPF（dae/daed 常用）
echo "CONFIG_CGROUPS=y" >> .config
echo "CONFIG_CGROUP_BPF=y" >> .config
echo "CONFIG_BPF_EVENTS=y" >> .config

# XDP 相关
echo "CONFIG_XDP_SOCKETS=y" >> .config
echo "CONFIG_PACKAGE_kmod-xdp-sockets-diag=y" >> .config

# 其他常见依赖（可选但建议保留）
echo "CONFIG_PACKAGE_kmod-sched-core=y" >> .config
echo "CONFIG_PACKAGE_kmod-sched-bpf=y" >> .config
echo "CONFIG_PACKAGE_kmod-veth=y" >> .config
echo "CONFIG_PACKAGE_bpftool=y" >> .config
