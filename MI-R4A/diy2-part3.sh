#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part3.sh
# Description: OpenWrt DIY script part 3 (After compiling)
#

echo "开始应用自定义文件..."

# 检查并创建必要的目录
mkdir -p openwrt/package/base-files/files/etc

# 1. 应用自定义 favicon
if [ -f "MI-R4A/favicon.ico" ]; then
    # 尝试多个可能的主题路径
    if [ -d "openwrt/package/luci-theme-argon_armygreen/htdocs/luci-static/argon_armygreen" ]; then
        mv MI-R4A/favicon.ico openwrt/package/luci-theme-argon_armygreen/htdocs/luci-static/argon_armygreen/favicon.ico
        echo "✓ 自定义 favicon 已应用到 argon_armygreen 主题"
    elif [ -d "openwrt/feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon" ]; then
        mv MI-R4A/favicon.ico openwrt/feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/favicon.ico
        echo "✓ 自定义 favicon 已应用到 argon 主题"
    else
        echo "⚠ 未找到主题目录，跳过 favicon 应用"
    fi
else
    echo "⚠ MI-R4A/favicon.ico 文件不存在"
fi

# 2. 应用自定义 banner
if [ -f "MI-R4A/banner" ]; then
    mv MI-R4A/banner openwrt/package/base-files/files/etc/banner
    echo "✓ 自定义 banner 已应用"
else
    echo "⚠ MI-R4A/banner 文件不存在"
fi

# 3. 可选：添加其他后处理步骤
# 例如：修改版本信息、添加构建时间等
echo "构建时间: $(date)" > openwrt/package/base-files/files/etc/buildinfo

echo "自定义文件应用完成"
