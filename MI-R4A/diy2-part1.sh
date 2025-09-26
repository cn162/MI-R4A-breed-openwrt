#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# 检查文件是否存在再执行修改
if [ -f "target/linux/ramips/dts/mt7621_xiaomi_mi-router-4a-3g-v2.dtsi" ]; then
    echo "找到设备树文件，执行 Breed 直刷修改"
    
    ## 修改为R4A千兆版Breed直刷版
    shanchu1=$(grep -a -n -e '&spi0 {' target/linux/ramips/dts/mt7621_xiaomi_mi-router-4a-3g-v2.dtsi | cut -d ":" -f 1)
    shanchu2=$(grep -a -n -e '&pcie {' target/linux/ramips/dts/mt7621_xiaomi_mi-router-4a-3g-v2.dtsi | cut -d ":" -f 1)
    
    # 修复 expr 语法错误 - 添加参数检查
    if [ -n "$shanchu2" ] && [ "$shanchu2" -eq "$shanchu2" ] 2>/dev/null; then
        shanchu2=$((shanchu2 - 1))
        shanchu2="${shanchu2}d"
        
        # 修复 sed 命令 - 添加引号
        if [ -n "$shanchu1" ] && [ -n "$shanchu2" ]; then
            sed -i "${shanchu1},${shanchu2}" target/linux/ramips/dts/mt7621_xiaomi_mi-router-4a-3g-v2.dtsi
        fi
    fi
    
    # 提取华硕设备树配置
    grep -Pzo '&spi0[\s\S]*};[\s]*};[\s]*};[\s]*};' target/linux/ramips/dts/mt7621_youhua_wr1200js.dts > youhua.txt 2>/dev/null
    echo "" >> youhua.txt
    echo "" >> youhua.txt
    
    # 修复 expr 语法错误
    if [ -n "$shanchu1" ] && [ "$shanchu1" -eq "$shanchu1" ] 2>/dev/null; then
        shanchu1=$((shanchu1 - 1))
        shanchu1="${shanchu1}r"
        
        if [ -f "youhua.txt" ]; then
            sed -i "${shanchu1} youhua.txt" target/linux/ramips/dts/mt7621_xiaomi_mi-router-4a-3g-v2.dtsi
            rm -rf youhua.txt
        fi
    fi
    
    ## 修改mt7621.mk
    if grep -q 'define Device/xiaomi_mir3g-v2' target/linux/ramips/image/mt7621.mk; then
        imsize1=$(grep -a -n -e 'define Device/xiaomi_mir3g-v2' target/linux/ramips/image/mt7621.mk | cut -d ":" -f 1)
        
        # 修复 expr 语法错误 - 使用算术扩展
        if [ -n "$imsize1" ] && [ "$imsize1" -eq "$imsize1" ] 2>/dev/null; then
            imsize1=$((imsize1 + 2))
            imsize1="${imsize1}s"
            sed -i "${imsize1}/IMAGE_SIZE := .*/IMAGE_SIZE := 16064k/" target/linux/ramips/image/mt7621.mk
        fi
    else
        echo "未找到 xiaomi_mir3g-v2 设备定义，可能使用不同名称"
    fi
else
    echo "未找到设备树文件，跳过 Breed 直刷修改"
    echo "ImmortalWrt 可能使用不同的文件结构"
fi
