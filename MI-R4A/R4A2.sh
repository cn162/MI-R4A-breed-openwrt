#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.31.1/g' package/base-files/files/bin/config_generate

# 修改主机名字
sed -i '/uci commit system/i\uci set system.@system[0].hostname='R4A-G'' package/default-settings/files/zzz-default-settings

# 版本号显示
sed -i 's/ImmortalWrt /编译时间 $(TZ=UTC-8 date "+%Y.%m.%d") @ 杨辰 /g' package/default-settings/files/zzz-default-settings

# 更改主机型号，支持中文
sed -i "s/Xiaomi Mi Router 4A Gigabit Edition/小米4A千兆版路由/g" target/linux/ramips/dts/mt7621_xiaomi_mi-router-4a-gigabit.dts

# 注释掉内核版本修改，使用 ImmortalWrt 默认版本
# sed -i "s/KERNEL_PATCHVER:=5.4/KERNEL_PATCHVER:=5.10/g" target/linux/ramips/Makefile

# 状态系统增加个性信息
sed -i "s/exit 0//" package/default-settings/files/zzz-default-settings

echo "sed -i '/CPU usage/a\<tr><td width=\"33%\">关于</td><td><a class=\"author-blog\" href=\"https://myxiaochuang.gitee.io\">作者仓库</a>&nbsp;&nbsp;&nbsp;<a class=\"author-blog\" href=\"https://github.com/cn162/MI-R4A-breed-openwrt\">编译源地址</a>&nbsp;&nbsp;&nbsp;<a class=\"author-blog\" </a></td></tr>' /usr/lib/lua/luci/view/admin_status/index.htm" >> package/default-settings/files/zzz-default-settings

echo "" >> package/default-settings/files/zzz-default-settings
echo "exit 0" >> package/default-settings/files/zzz-default-settings

# 删除原默认主题（修改路径）
rm -rf package/luci-theme-argon
rm -rf package/luci-theme-bootstrap
rm -rf package/luci-theme-material
rm -rf package/luci-theme-netgear

# 下载主题
git clone https://github.com/XXKDB/luci-theme-argon_armygreen.git package/luci-theme-argon_armygreen
git clone https://github.com/YL2209/luci-theme-ifit.git package/luci-theme-ifit

# 下载serverchan（先检查是否存在）
if [ ! -d "package/luci-app-serverchan" ]; then
    git clone https://github.com/tty228/luci-app-serverchan.git package/luci-app-serverchan
fi

# 修改主题样式（保持你的自定义）
sed -i 's/#f7fafc/rgba(134,176,197, .5)/g' package/luci-theme-argon_armygreen/htdocs/luci-static/argon_armygreen/css/style.css
sed -i 's/#f9ffff/#80ABC3/g' package/luci-theme-argon_armygreen/htdocs/luci-static/argon_armygreen/css/style.css
sed -i 's/#7fffffb8/#5C859B/g' package/luci-theme-argon_armygreen/htdocs/luci-static/argon_armygreen/css/style.css
sed -i 's/#9effff57/#9FC4D5/g' package/luci-theme-argon_armygreen/htdocs/luci-static/argon_armygreen/css/style.css
sed -i 's/#4fc352/#496A81/g' package/luci-theme-argon_armygreen/htdocs/luci-static/argon_armygreen/css/style.css
sed -i 's/#5e72e4/#407994/g' package/luci-theme-argon_armygreen/htdocs/luci-static/argon_armygreen/css/style.css

# 取消原主题为默认主题
sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' package/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap

# 设置 argon_armygreen 为默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon_armygreen/g' package/luci/collections/luci/Makefile

# 设置密码为空
sed -i 's@.*CYXluq4wUazHjmCDBCqXF*@#&@g' package/default-settings/files/zzz-default-settings

# 修改wifi设置
sed -i 's/ssid=OpenWrt/ssid=MIWIFI_2021/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i 's/encryption=none/encryption=psk2/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i '/set wireless.default_radio${devidx}.encryption=psk2/a\set wireless.default_radio${devidx}.key=password' package/kernel/mac80211/files/lib/wifi/mac80211.sh
