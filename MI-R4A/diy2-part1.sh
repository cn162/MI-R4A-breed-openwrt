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
    export shanchu1=$(grep -a -n -e '&spi0 {' target/linux/ramips/dts/mt7621_xiaomi_mi-router-4a-3g-v2.dtsi | cut -d ":" -f 1)
    export shanchu2=$(grep -a -n -e '&pcie {' target/linux/ramips/dts/mt7621_xiaomi_mi-router-4a-3g-v2.dtsi | cut -d ":" -f 1)
    export shanchu2=$(expr $shanchu2 - 1)
    export shanchu2=$(echo $shanchu2"d")
    sed -i $shanchu1,$shanchu2 target/linux/ramips/dts/mt7621_xiaomi_mi-router-4a-3g-v2.dtsi
    
    grep -Pzo '&spi0[\s\S]*};[\s]*};[\s]*};[\s]*};' target/linux/ramips/dts/mt7621_youhua_wr1200js.dts > youhua.txt
    echo "" >> youhua.txt
    echo "" >> youhua.txt
    export shanchu1=$(expr $shanchu1 - 1)
    export shanchu1=$(echo $shanchu1"r")
    sed -i "$shanchu1 youhua.txt" target/linux/ramips/dts/mt7621_xiaomi_mi-router-4a-3g-v2.dtsi
    rm -rf youhua.txt
    
    ## 修改mt7621.mk
    if grep -q 'define Device/xiaomi_mir3g-v2' target/linux/ramips/image/mt7621.mk; then
        export imsize1=$(grep -a -n -e 'define Device/xiaomi_mir3g-v2' target/linux/ramips/image/mt7621.mk | cut -d ":" -f 1)
        export imsize1=$(expr $imsize1 + 2)
        export imsize1=$(echo $imsize1"s")
        sed -i "$imsize1/IMAGE_SIZE := .*/IMAGE_SIZE := 16064k/" target/linux/ramips/image/mt7621.mk
    else
        echo "未找到 xiaomi_mir3g-v2 设备定义，可能使用不同名称"
    fi
else
    echo "未找到设备树文件，跳过 Breed 直刷修改"
    echo "ImmortalWrt 可能使用不同的文件结构"
fi
