#!/bin/bash
PWD=$(pwd)

echo " 请选择构建设备："
echo "1. AXT1800 - 4.X内核"
echo "2. AXT1800 - 5.X内核"
read input

case $input in
1)
		echo "构建AXT1800 - 4.X内核"
		DEVICE="axt1800"
		DEVICE1="wlan-ap"
		;;
2)
		echo "构建AXT1800 - 5.X内核"
		DEVICE="axt1800"
		DEVICE1="wlan-ap-5.4"
		;;
esac

git clone https://github.com/gl-inet/gl-infra-builder.git $PWD/gl-infra-builder

cp -r $PWD/*.yml $PWD/gl-infra-builder/profiles

cd $PWD/gl-infra-builder

python3 setup.py -c configs/config-$DEVICE1.yml

cp -r ~/GL-inet_AXT1800/diysettings/ ./feeds/diysettings
chmod -R 775 ./feeds/diysettings

cd wlan-ap/openwrt
./scripts/gen_config.py $PWD/profiles/glinet-$DEVICE glinet_depends

git clone https://github.com/gl-inet/glinet4.x.git -b main $PWD/glinet

cp -r ~/GL-inet_AXT1800/etc/ files
echo "$(date +"%Y.%m.%d")" >./files/etc/glversion
echo "Bulid  By@shejiewu" >./files/etc/version.type

./scripts/feeds update -a
./scripts/feeds install -a
make defconfig

echo -e "$(nproc) thread compile"
make -j$(expr $(nproc) + 1) GL_PKGDIR=$PWD/glinet/ipq60xx/ V=s

