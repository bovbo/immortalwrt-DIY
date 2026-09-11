#!/bin/bash
# diy-part1.sh —— 拉取源码后、feeds update 之前执行
# 追加第三方 feeds 源，带 grep 判断防止每次编译重复追加

grep -q 'kenzok8/openwrt-daede' feeds.conf.default || sed -i '$a src-git daede https://github.com/kenzok8/openwrt-daede.git' feeds.conf.default
grep -q 'kenzok8/small-package' feeds.conf.default || sed -i '$a src-git smpackage https://github.com/kenzok8/small-package' feeds.conf.default
