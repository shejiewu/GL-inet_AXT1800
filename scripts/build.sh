#!/bin/bash
PWD=$(pwd)

echo "请选择构建设备："
echo "1. AX1800 - 4.X内核"
echo "2. AXT1800 - 4.X内核"
echo "3. AX1800 - 5.X内核"
echo "4. AXT1800 - 5.X内核"
read input

case $input in
1)
		echo "构建AX1800 - 4.X内核"
		DEVICE="ax1800"
		DEVICE1="wlan-ap"
		;;
2)
		echo "构建AXT1800 - 4.X内核"
		DEVICE="axt1800"
		DEVICE1="wlan-ap-5.4"
		;;
3)
		echo "构建AX1800 - 5.X内核"
		DEVICE="ax1800"
		DEVICE1="wlan-ap"
		;;
4)
		echo "构建AXT1800 - 5.X内核"
		DEVICE="axt1800"
		DEVICE1="wlan-ap-5.4"
		;;
esac

#clone source tree
git clone https://github.com/gl-inet/gl-infra-builder.git $PWD/gl-infra-builder
cp -r $PWD/*.yml $PWD/gl-infra-builder/profiles
cp -r default-settings/  $PWD/gl-infra-builder/feeds/default-settings/
cd $PWD/gl-infra-builder
#setup
python3 setup.py -c configs/config-$DEVICE1.yml

cd wlan-ap/openwrt
./scripts/gen_config.py  $PWD/profiles/glinet-$DEVICE glinet_depends

git clone https://github.com/gl-inet/glinet4.x.git -b main $PWD/glinet
./scripts/feeds update -a
./scripts/feeds install -a
make defconfig
cd ~/GL-inet_AXT1800/
cp -r etc gl-infra-builder/wlan-ap/openwrt/files
cd gl-infra-builder/wlan-ap/openwrt/files/etc
echo "$(date +"%Y.%m.%d")" >./glversion
cd ../../

echo -e "$(nproc) thread compile"
make -j$(expr $(nproc) + 1) GL_PKGDIR=$PWD/glinet/ipq60xx/ V=s
