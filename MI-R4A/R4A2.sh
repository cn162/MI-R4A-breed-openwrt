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

set -e  # 遇到错误立即退出
echo "=== 开始执行 DIY 脚本 Part 2 ==="

# 检查是否在正确的目录中
if [ ! -d "package" ] || [ ! -d "target" ]; then
    echo "错误：不在 OpenWrt 源码目录中"
    echo "当前目录: $(pwd)"
    exit 1
fi

# 1. 修改默认IP（添加文件存在性检查）
if [ -f "package/base-files/files/bin/config_generate" ]; then
    echo "修改默认IP..."
    sed -i 's/192.168.1.1/192.168.31.1/g' package/base-files/files/bin/config_generate
else
    echo "警告：config_generate 文件不存在"
fi

# 2. 修改主机名（简化操作）
if [ -f "package/default-settings/files/zzz-default-settings" ]; then
    echo "修改主机名和版本号..."
    
    # 修改主机名
    if grep -q "system.@system\[0\].hostname" package/default-settings/files/zzz-default-settings; then
        sed -i 's/uci set system.@system\[0\].hostname=.*/uci set system.@system[0].hostname='"'"'R4A-G'"'"'/g' package/default-settings/files/zzz-default-settings
    else
        # 如果不存在，添加设置
        sed -i '/uci commit system/i\uci set system.@system[0].hostname='\''R4A-G'\' package/default-settings/files/zzz-default-settings
    fi
    
    # 修改版本号显示
    sed -i 's/ImmortalWrt /编译时间 $(TZ=UTC-8 date "+%Y.%m.%d") @ 杨辰 /g' package/default-settings/files/zzz-default-settings
    
    # 状态系统增加个性信息（简化版本）
    if ! grep -q "作者仓库" package/default-settings/files/zzz-default-settings; then
        sed -i '/exit 0/d' package/default-settings/files/zzz-default-settings
        echo "" >> package/default-settings/files/zzz-default-settings
        echo "# 自定义状态信息" >> package/default-settings/files/zzz-default-settings
        echo "sed -i '/CPU usage/i\\<tr><td width=\"33%\">关于</td><td><a href=\"https://github.com/cn162/MI-R4A-breed-openwrt\">编译源地址</a></td></tr>' /usr/lib/lua/luci/view/admin_status/index.htm" >> package/default-settings/files/zzz-default-settings
        echo "exit 0" >> package/default-settings/files/zzz-default-settings
    fi
else
    echo "警告：zzz-default-settings 文件不存在"
fi

# 3. 更改主机型号显示（检查文件是否存在）
if [ -f "target/linux/ramips/dts/mt7621_xiaomi_mi-router-4a-gigabit.dts" ]; then
    echo "修改设备显示名称..."
    sed -i "s/Xiaomi Mi Router 4A Gigabit Edition/小米4A千兆版路由/g" target/linux/ramips/dts/mt7621_xiaomi_mi-router-4a-gigabit.dts
fi

# 4. 删除原默认主题（安全删除）
echo "处理主题..."
for theme in argon bootstrap material netgear; do
    if [ -d "package/luci-theme-${theme}" ]; then
        echo "删除主题: luci-theme-${theme}"
        rm -rf "package/luci-theme-${theme}"
    fi
done

# 5. 下载新主题（添加错误处理）
echo "下载新主题..."
if [ ! -d "package/luci-theme-argon_armygreen" ]; then
    git clone https://github.com/XXKDB/luci-theme-argon_armygreen.git package/luci-theme-argon_armygreen || echo "主题下载失败，继续执行"
fi

if [ ! -d "package/luci-theme-ifit" ]; then
    git clone https://github.com/YL2209/luci-theme-ifit.git package/luci-theme-ifit || echo "主题下载失败，继续执行"
fi

# 6. 下载serverchan（简化）
if [ ! -d "package/luci-app-serverchan" ]; then
    echo "下载 serverchan..."
    git clone https://github.com/tty228/luci-app-serverchan.git package/luci-app-serverchan || echo "serverchan 下载失败"
fi

# 7. 修改主题为默认（简化操作）
if [ -f "package/luci/collections/luci/Makefile" ]; then
    echo "设置默认主题..."
    sed -i 's/luci-theme-bootstrap/luci-theme-argon_armygreen/g' package/luci/collections/luci/Makefile
fi

# 8. 设置密码为空
if [ -f "package/default-settings/files/zzz-default-settings" ]; then
    echo "设置空密码..."
    sed -i 's/.*CYXluq4wUazHjmCDBCqXF.*/#&/g' package/default-settings/files/zzz-default-settings
fi

# 9. 修改WiFi设置（简化）
if [ -f "package/kernel/mac80211/files/lib/wifi/mac80211.sh" ]; then
    echo "修改WiFi设置..."
    sed -i 's/ssid=OpenWrt/ssid=MIWIFI_2021/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
    sed -i 's/encryption=none/encryption=psk2/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
fi

echo "=== DIY 脚本 Part 2 执行完成 ==="
