
#!/bin/bash

# 修改默认IP
#sed -i 's/192.168.100.1/10.0.0.1/g' package/base-files/files/bin/config_generate

# 更改 Argon 主题背景
cp -f $GITHUB_WORKSPACE/images/bg1.jpg feeds/third/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

rm -rf feeds/packages/net/{alist,adguardhome,mosdns,xray*,v2ray*,v2ray*,sing-box*}
rm -rf feeds/packages/utils/v2dat
rm -rf feeds/packages/lang/golang
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/packages/net/v2ray-geodata

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# 科学上网插件
git clone --depth=1 -b master https://github.com/fw876/helloworld package/luci-app-ssr-plus
git clone --depth=1 -b main https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall
git clone --depth=1 -b main https://github.com/xiaorouji/openwrt-passwall package/luci-app-passwall
git clone --depth=1 -b main https://github.com/xiaorouji/openwrt-passwall2 package/luci-app-passwall2
git_sparse_clone dev https://github.com/vernesong/OpenClash luci-app-openclash

# AdGuardHome
git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome package/luci-app-adguardhome

# Modns
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

# iStoreOS 官方插件库
git clone --depth=1 -b main https://github.com/linkease/istore-packages package/istore-packages
git clone --depth=1 -b dev https://github.com/jjm2473/luci-app-diskman package/diskman
git clone --depth=1 -b dev4 https://github.com/jjm2473/OpenAppFilter package/oaf
git clone --depth=1 -b master https://github.com/linkease/nas-packages package/nas-packages
git clone --depth=1 -b main https://github.com/linkease/nas-packages-luci package/nas-packages-luci
git clone --depth=1 -b main https://github.com/jjm2473/openwrt-apps package/openwrt-apps

# 更换golong 1.23
git clone https://github.com/oppen321/golang feeds/packages/lang/golang

# 5g支持 
git clone --depth=1 https://github.com/Siriling/5G-Modem-Support Modem-Support
# 5G通信模组拨号工具
mkdir package/community
mkdir package/community/quectel_QMI_WWAN
mkdir package/community/quectel_cm_5G
mkdir package/community/quectel_MHI
mkdir package/community/luci-app-hypermodem        
mkdir package/community/sms-tool
mkdir package/community/luci-app-sms-tool
cp -rf ./Modem-Support/quectel_QMI_WWAN/* package/community/quectel_QMI_WWAN
cp -rf ./Modem-Support/quectel_cm_5G/* package/community/quectel_cm_5G
cp -rf ./Modem-Support/quectel_MHI/* package/community/quectel_MHI
cp -rf ./Modem-Support/luci-app-hypermodem/* package/community/luci-app-hypermodem
cp -rf ./Modem-Support/sms-tool/* package/community/sms-tool
cp -rf ./Modem-Support/luci-app-sms-tool/* package/community/luci-app-sms-tool
        
#5G相关
echo "
# 5G模组信号插件
# CONFIG_PACKAGE_ext-rooter-basic=y
        
# 5G模组短信插件
#CONFIG_PACKAGE_luci-app-sms-tool=y
        
# 5G模组信息插件
# CONFIG_PACKAGE_luci-app-3ginfo-lite=y
# CONFIG_PACKAGE_luci-app-3ginfo=y
        
# 5G模组信息插件+AT工具
# CONFIG_PACKAGE_luci-app-cpe=y
# CONFIG_PACKAGE_sendat=y
CONFIG_PACKAGE_sms-tool=y
#CONFIG_PACKAGE_luci-app-modem=y
        
# QMI拨号工具（移远，广和通）
# CONFIG_PACKAGE_quectel-CM-5G=y
# CONFIG_PACKAGE_fibocom-dial=y
        
# QMI拨号软件
# CONFIG_PACKAGE_kmod-qmi_wwan_f=y
# CONFIG_PACKAGE_luci-app-hypermodem=y
        
# Gobinet拨号软件
# CONFIG_PACKAGE_kmod-gobinet=y
# CONFIG_PACKAGE_luci-app-gobinetmodem=y
        
# 串口调试工具
CONFIG_PACKAGE_minicom=y
        
# 脚本拨号工具依赖
CONFIG_PACKAGE_procps-ng=y
CONFIG_PACKAGE_procps-ng-ps=y

#科学上网
CONFIG_PACKAGE_luci-app-passwall=y

#
# Configuration
#
CONFIG_PACKAGE_luci-app-passwall_Iptables_Transparent_Proxy=y
CONFIG_PACKAGE_luci-app-passwall_Nftables_Transparent_Proxy=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Haproxy=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Hysteria=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_NaiveProxy=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Libev_Client=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Libev_Server=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Rust_Client=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Rust_Server=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ShadowsocksR_Libev_Client=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ShadowsocksR_Libev_Server=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Simple_Obfs=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_SingBox=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Trojan_Plus=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_tuic_client=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_V2ray_Geodata=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_V2ray_Plugin=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Xray=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Xray_Plugin=y
# end of Configuration

CONFIG_PACKAGE_luci-app-passwall2=y

#
# Configuration
#
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_IPv6_Nat=y
CONFIG_PACKAGE_luci-app-passwall2_Iptables_Transparent_Proxy=y
CONFIG_PACKAGE_luci-app-passwall2_Nftables_Transparent_Proxy=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Haproxy=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Hysteria=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_NaiveProxy=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Libev_Client=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Libev_Server=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Rust_Client=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Rust_Server=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_ShadowsocksR_Libev_Client=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_ShadowsocksR_Libev_Server=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Simple_Obfs=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_SingBox=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_tuic_client=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_V2ray_Plugin=y
# end of Configuration

CONFIG_PACKAGE_luci-i18n-passwall-zh-cn=y
CONFIG_PACKAGE_luci-i18n-passwall2-zh-cn=y
" >> .config
        
# 额外组件
echo "
CONFIG_GRUB_IMAGES=y
CONFIG_VMDK_IMAGES=y
CONFIG_VDI_IMAGES=y
" >> .config

./scripts/feeds update -a
./scripts/feeds install -a
