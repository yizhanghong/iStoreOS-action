#!/bin/bash

# 修改默认IP
#sed -i 's/192.168.100.1/10.0.0.1/g' package/base-files/files/bin/config_generate

# 更改 Argon 主题背景
cp -f $GITHUB_WORKSPACE/images/bg1.jpg feeds/third/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# 添加jenet-lu的dts
echo "
define Device/jetron_jenet-lu
$(call Device/rk3568)
  DEVICE_VENDOR := JETRON
  DEVICE_MODEL := JENET-LU
  SUPPORTED_DEVICES += jetron,jenet-lu
  DEVICE_DTS := rk3568-jenet-lu
  DEVICE_PACKAGES := kmod-scsi-core kmod-thermal kmod-rkwifi-bcmdhd-pcie rkwifi-firmware-ap6275s
endef
TARGET_DEVICES += jetron_jenet-lu
" >>  target/linux/rockchip/Image/rk35xx.mk

cp -f $GITHUB_WORKSPACE/dts/rk3568-evb1-ddr4-v10.dtsi target/linux/rockchip/dts/rk3568/rk3568-evb1-ddr4-v10.dtsi
cp -f $GITHUB_WORKSPACE/dts/rk3568-jenet.dtsi target/linux/rockchip/dts/rk3568/rk3568-jenet.dtsi
cp -f $GITHUB_WORKSPACE/dts/rk3568-jenet-lu.dts target/linux/rockchip/dts/rk3568/rk3568-jenet-lu.dts

git clone --depth=1 -b main https://github.com/linkease/istore-packages package/istore-packages
git clone --depth=1 -b dev https://github.com/jjm2473/luci-app-diskman package/diskman
git clone --depth=1 -b dev4 https://github.com/jjm2473/OpenAppFilter package/oaf
git clone --depth=1 -b master https://github.com/linkease/nas-packages package/nas-packages
git clone --depth=1 -b main https://github.com/linkease/nas-packages-luci package/nas-packages-luci
git clone --depth=1 -b main https://github.com/jjm2473/openwrt-apps package/openwrt-apps

./scripts/feeds update -a
./scripts/feeds install -a
