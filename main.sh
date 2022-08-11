#!/bin/bash
function git_clone() {
  git clone --depth 1 $1 $2 || true
}
function git_sparse_clone() {
  branch="$1" rurl="$2" localdir="$3" && shift 3
  git clone -b $branch --depth 1 --filter=blob:none --sparse $rurl $localdir
  cd $localdir
  git sparse-checkout init --cone
  git sparse-checkout set $@
  mv -n $@ ../
  cd ..
  rm -rf $localdir
}
function mvdir() {
  mv -n $(find $1/* -maxdepth 0 -type d) ./
  rm -rf $1
}
mkdir -p packages

#应用过滤
git clone --depth 1 https://github.com/destan19/OpenAppFilter && mvdir OpenAppFilter &&  mv -n oaf ./packages && mv -n open-app-filter ./packages 

git clone --depth 1 https://github.com/sirpdboy/luci-app-advanced

#netdata
git clone --depth 1 https://github.com/sirpdboy/luci-app-netdata 

#主题
git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config
git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon
sed -i 's/+jsonfilter/+jsonfilter +luci-app-argon-config/' luci-theme-argon/Makefile
git clone --depth 1 https://github.com/garypang13/luci-theme-edge
sed -i 's/1.9rem/1rem/' luci-theme-edge/htdocs/luci-static/edge/cascade.css
sed -i 's@.*mediaurlbase*@#&@g' luci-theme*/root/etc/uci-defaults/30_luci-theme-*

#adguardhome
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-adguardhome
svn export https://github.com/kiddin9/openwrt-packages/trunk/adguardhome packages/adguardhome
#sed -i 's@.*AdGuardHome.yaml*@#&@g' ./*adguardhome/Makefile
#sed -i 's/AdGuardHome.yaml/config\/AdGuardHome.yaml/g' ./*adguardhome/root/etc/config/AdGuardHome
#sed -i 's/default y/default n/g' ./*adguardhome/Makefile

#passwall
#svn co https://github.com/xiaorouji/openwrt-passwall/trunk ./ && rm -rf .svn && rm -rf .github
#rm -rf xray-core trojan-go
svn export https://github.com/xiaorouji/openwrt-passwall/branches/luci/luci-app-passwall ./luci-app-passwall
#sed -i '92 s/n/y/' ./luci-app-passwall/Makefile
#sed -i '148 s/n /y /' ./luci-app-passwall/Makefile

svn export https://github.com/fw876/helloworld/trunk/shadowsocks-rust packages/shadowsocks-rust
svn export https://github.com/fw876/helloworld/trunk/shadowsocksr-libev packages/shadowsocksr-libev
cd packages
git_sparse_clone master "https://github.com/immortalwrt/packages" "imm" net/brook net/chinadns-ng net/dns2tcp net/hysteria net/naiveproxy net/sagernet-core net/simple-obfs net/ssocks net/tcping net/trojan-plus net/v2ray-geodata net/v2ray-plugin net/xray-plugin net/trojan net/v2ray-core net/cdnspeedtest 
cd ..

#sed -i "s/\.\.\/\.\./\$(TOPDIR)\/feeds\/packages/g" brook/Makefile hysteria/Makefile sagernet-core/Makefile v2ray-core/Makefile v2ray-plugin/Makefile xray-plugin/Makefile

for i in "dns2socks" "microsocks" "ipt2socks" "pdnsd-alt" "redsocks2"; do \
  svn export "https://github.com/immortalwrt/packages/trunk/net/$i" "packages/$i"; \
done

#ssrplus
svn export https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus

#vssr
git clone --depth 1 https://github.com/jerrykuku/luci-app-vssr

#v2raya
git clone --depth 1 https://github.com/zxlhhyccc/luci-app-v2raya

#bypass
svn export https://github.com/kiddin9/openwrt-bypass/trunk/luci-app-bypass
svn export https://github.com/kiddin9/openwrt-bypass/trunk/lua-maxminddb  packages/lua-maxminddb


#文件传输
svn export https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-filetransfer 
svn export https://github.com/coolsnowwolf/luci/trunk/libs/luci-lib-fs packages/luci-lib-fs

#Turbo ACC 网络加速
#svn export https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-turboacc 
#svn export https://github.com/coolsnowwolf/packages/trunk/net/dnsforwarder packages/dnsforwarder
#svn export https://github.com/coolsnowwolf/lede/trunk/package/lean/shortcut-fe packages/shortcut-fe

#访客网络
svn export https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-guest-wifi 
#sed -i 's/msgstr"/msgstr "/g' ./*guest-wifi/po/zh-cn/guest-wifi.po

#简易更新
svn export https://github.com/sundaqiang/openwrt-packages/trunk/luci-app-easyupdate 

#网络唤醒++
svn export https://github.com/sundaqiang/openwrt-packages/trunk/luci-app-wolplus 

#openclash
svn export https://github.com/vernesong/OpenClash/trunk/luci-app-openclash
sed -i 's/+libcap /+libcap +libcap-bin /g' luci-app-openclash/Makefile

#磁盘管理
svn export https://github.com/lisaac/luci-app-diskman/trunk/applications/luci-app-diskman
#mkdir -p parted && wget https://raw.githubusercontent.com/lisaac/luci-app-diskman/master/Parted.Makefile -O parted/Makefile

#实时流量监测
svn export https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-wrtbwmon 

#CPU 性能优化调节
#svn export https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-cpufre 
svn export https://github.com/immortalwrt/luci/trunk/applications/luci-app-cpufreq
#sed -i 's@.*aarch64*@#&@g' luci-app-cpufreq/Makefile
#sed -i 's/\@(aarch64||arm)/ /g' luci-app-cpufreq/Makefile 
#sed -i 's,1608,1800,g' luci-app-cpufreq/root/etc/uci-defaults/10-cpufreq
#sed -i 's,2016,2208,g' luci-app-cpufreq/root/etc/uci-defaults/10-cpufreq
#sed -i 's,1512,1608,g' luci-app-cpufreq/root/etc/uci-defaults/10-cpufreq

#释放内存
svn export https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-ramfree 

#IP/MAC绑定
svn export https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-arpbind 

#定时设置
git clone --depth 1 https://github.com/sirpdboy/luci-app-autotimeset 

#docke
#svn export https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-dockerman 
svn export https://github.com/lisaac/luci-app-dockerman/trunk/applications/luci-app-dockerman
sed -i 's/+dockerd/+dockerd +cgroupfs-mount/' luci-app-docker*/Makefile
sed -i '$i /etc/init.d/dockerd restart &' luci-app-docker*/root/etc/uci-defaults/*

#smartdns
svn export https://github.com/immortalwrt/packages/trunk/net/smartdns packages/smartdns

#cloudflarespeedtest
svn export https://github.com/mingxiaoyu/luci-app-cloudflarespeedtest/trunk/applications/luci-app-cloudflarespeedtest



cd packages
# sed -i 's/36\.1/37-RC2/g' smartdns/Makefile
# sed -i 's/PKG_HASH:=.*/PKG_HASH:=b5fb39d759e333a37b33e56177bd3c7965387b8b1312f45d8709b178ac58f655/g' smartdns/Makefile

sed -i \
-e 's?include \.\./\.\./\(lang\|devel\)?include $(TOPDIR)/feeds/packages/\1?' \
-e 's?\.\./\.\./luci.mk?$(TOPDIR)/feeds/luci/luci.mk?' \
*/Makefile
cd ..

sed -i \
-e 's?include \.\./\.\./\(lang\|devel\)?include $(TOPDIR)/feeds/packages/\1?' \
-e 's?\.\./\.\./luci.mk?$(TOPDIR)/feeds/luci/luci.mk?' \
*/Makefile

for e in $(ls -d luci-*/po); do
	if [[ -d $e/zh-cn && ! -d $e/zh_Hans ]]; then
		ln -s zh-cn $e/zh_Hans 2>/dev/null
	elif [[ -d $e/zh_Hans && ! -d $e/zh-cn ]]; then
		ln -s zh_Hans $e/zh-cn 2>/dev/null
	fi
done

rm -rf ./*/.git & rm -f ./*/.gitattributes
rm -rf ./*/.svn & rm -rf ./*/.github & rm -rf ./*/.gitignore

exit 0
