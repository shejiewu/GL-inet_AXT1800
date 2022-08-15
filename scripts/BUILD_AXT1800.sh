#!/bin/bash
PWD=$(pwd)

echo "请选择编译固件的设备："
echo "1. AXT1800 - 4.X内核"
echo "2. AXT1800 - 5.X内核"
read input
case $input in
1)
    echo "编译AXT1800 - 4.X内核"
    DEVICE0="wlan-ap"
    DEVICE1="axt1800"
    ;;	
2)
    echo "编译AXT1800 - 5.X内核"
    DEVICE0="wlan-ap-5.4"
    DEVICE1="axt1800-5-4"
    ;;
    *) echo '请输入“1”或“2”（不带引号）选择，您的选择错误，脚本已退出，请重新启动脚本！！'
    echo '  '
    exit
    ;;
esac
## sudo apt install build-essential libncurses5-dev gawk git libssl-dev gettext zlib1g-dev swig unzip time rsync python3 python3-setuptools python3-yaml
git clone https://github.com/gl-inet/gl-infra-builder.git $PWD/gl-infra-builder
cp -r $PWD/*.yml $PWD/gl-infra-builder/profiles
cd $PWD/gl-infra-builder
python3 setup.py -c configs/config-$DEVICE0.yml
## echo 准备就绪，请添加自定义信息到 profiles/target_wlan_ap-gl-ax1800-common.yml 或 profiles/target_wlan_ap-gl-ax1800-common-5-4.yml 里，实现第三方插件编译一起，然后按回车键继续或不改, 按回车键继续; read dummy;
cd wlan-ap/openwrt
scripts/gen_config.py target_wlan_ap-gl-$DEVICE1 glinet_depends
git clone https://github.com/gl-inet/glinet4.x.git -b main $PWD/glinet
cp -r ~/GL-inet_AXT1800/etc/ ./package/base-files/files
echo "$(date +"%Y.%m.%d")" >./package/base-files/files/etc/glversion
echo " Bulid By@shejiewu " >./package/base-files/files/etc/version.type
./scripts/feeds update -a
./scripts/feeds install -a
make defconfig
## make -j1 GL_PKGDIR=$PWD/glinet/ipq60xx/ V=s
make -j$(expr $(nproc) + 1) GL_PKGDIR=$PWD/glinet/ipq60xx/ V=s
