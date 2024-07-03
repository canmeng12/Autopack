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
git clone --depth 1 https://github.com/destan19/OpenAppFilter && mvdir OpenAppFilter && mv -n oaf ./packages && mv -n open-app-filter ./packages

#系统高级设置
git clone --depth 1 https://github.com/sirpdboy/luci-app-advanced

#netdata
git clone --depth 1 https://github.com/sirpdboy/luci-app-netdata

#定时设置
git clone --depth 1 https://github.com/sirpdboy/luci-app-autotimeset

#定时限速
git clone --depth 1 https://github.com/sirpdboy/luci-app-eqosplus

#主题
git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config
git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon
#sed -i 's/+jsonfilter/+jsonfilter +luci-app-argon-config/' luci-theme-argon/Makefile
git clone --depth 1 https://github.com/garypang13/luci-theme-edge
sed -i 's/1.9rem/1rem/' luci-theme-edge/htdocs/luci-static/edge/cascade.css
sed -i 's@.*mediaurlbase*@#&@g' luci-theme*/root/etc/uci-defaults/30_luci-theme-*

#adguardhome,bypass
git clone --depth 1 https://github.com/kiddin9/openwrt-packages packages12 && mv -n packages12/luci-app-bypass ./ && mv -n packages12/adguardhome ./packages/
rm -rf packages12

git clone --depth 1 https://github.com/Hyy2001X/AutoBuild-Packages packages12 && mv -n packages12/luci-app-adguardhome ./ 
rm -rf packages12

#sed -i 's@.*AdGuardHome.yaml*@#&@g' ./*adguardhome/Makefile
#sed -i 's/AdGuardHome.yaml/config\/AdGuardHome.yaml/g' ./*adguardhome/root/etc/config/AdGuardHome
#sed -i 's/default y/default n/g' ./*adguardhome/Makefile

#passwall

git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall2 passwall2 && mv -n passwall2/luci-app-passwall2 ./
rm -rf passwall2

git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall passwall1 && mv -n passwall1/luci-app-passwall ./
rm -rf passwall1
#sed -i '92 s/n/y/' ./luci-app-passwall/Makefile
#sed -i '148 s/n /y /' ./luci-app-passwall/Makefile

git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall-packages packages1 && mv -n packages1/{sing-box,tuic-client,v2ray-core,ipt2socks,ssocks,shadowsocksr-libev} ./packages/
rm -rf packages1

git_sparse_clone master "https://github.com/immortalwrt/luci" "imm" applications/{luci-app-cpulimit,luci-app-webadmin,luci-app-cpufreq}

git clone --depth 1 https://github.com/immortalwrt/immortalwrt && mv -n immortalwrt/package/emortal/cpufreq ./packages/
rm -rf immortalwrt

#ssrplus
git clone --depth 1 https://github.com/fw876/helloworld && mv -n helloworld/luci-app-ssr-plus ./ && mv -n helloworld/{lua-neturl,shadow-tls} ./packages/
rm -rf helloworld

#vssr
#git clone --depth 1 https://github.com/jerrykuku/luci-app-vssr
git clone --depth 1 https://github.com/liuran001/openwrt-packages packages15 && mv -n packages15/luci-app-vssr ./
rm -rf packages15

#v2raya
git clone --depth 1 https://github.com/zxlhhyccc/luci-app-v2raya

git clone --depth 1 https://github.com/v2rayA/v2raya-openwrt && mv -n v2raya-openwrt/v2raya ./packages/
rm -rf v2raya-openwrt

#文件传输,访客网络，释放内存，IP/MAC绑定,实时流量监测,docke

git clone --depth 1 https://github.com/coolsnowwolf/luci && mv -n luci/applications/{luci-app-filetransfer,luci-app-guest-wifi,luci-app-ramfree,luci-app-arpbind,luci-app-wrtbwmon,luci-app-dockerman} ./ && mv -n luci/libs/luci-lib-fs ./packages/
rm -rf luci

#sed -i 's/msgstr"/msgstr "/g' ./*guest-wifi/po/zh-cn/guest-wifi.po

sed -i 's/+dockerd/+dockerd +cgroupfs-mount/' luci-app-docker*/Makefile
sed -i '$i /etc/init.d/dockerd restart &' luci-app-docker*/root/etc/uci-defaults/*

#Turbo ACC 网络加速
#svn export https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-turboacc
#svn export https://github.com/coolsnowwolf/packages/trunk/net/dnsforwarder packages/dnsforwarder
#svn export https://github.com/coolsnowwolf/lede/trunk/package/lean/shortcut-fe packages/shortcut-fe

git clone --depth 1 https://github.com/coolsnowwolf/lede && mv -n lede/package/lean/mt ./packages/
rm -rf lede

#简易更新,#网络唤醒++
git clone --depth 1 https://github.com/sundaqiang/openwrt-packages && mv -n openwrt-packages/{luci-app-easyupdate,luci-app-wolplus} ./
rm -rf openwrt-packages

#openclash
git clone --depth 1 https://github.com/vernesong/OpenClash -b dev && mv -n OpenClash/luci-app-openclash ./
rm -rf OpenClash
#sed -i 's/+libcap /+libcap +libcap-bin /g' luci-app-openclash/Makefile

#磁盘管理

git clone --depth 1 https://github.com/lisaac/luci-app-diskman diskman && mv -n diskman/applications/luci-app-diskman ./
rm -rf diskman
#mkdir -p parted && wget https://raw.githubusercontent.com/lisaac/luci-app-diskman/master/Parted.Makefile -O parted/Makefile

#CPU 性能优化调节
#svn export https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-cpufre
#svn export https://github.com/immortalwrt/luci/trunk/applications/luci-app-cpufreq
#sed -i 's@.*aarch64*@#&@g' luci-app-cpufreq/Makefile
#sed -i 's/\@(aarch64||arm)/ /g' luci-app-cpufreq/Makefile
#sed -i 's,1608,1800,g' luci-app-cpufreq/root/etc/uci-defaults/10-cpufreq
#sed -i 's,2016,2208,g' luci-app-cpufreq/root/etc/uci-defaults/10-cpufreq
#sed -i 's,1512,1608,g' luci-app-cpufreq/root/etc/uci-defaults/10-cpufreq

#smartdns
#svn export https://github.com/pymumu/luci-app-smartdns/trunk/ luci-app-smartdns
#svn export https://github.com/pymumu/openwrt-smartdns/trunk/ packages/smartdns

#cloudflarespeedtest

git clone --depth 1 https://github.com/mingxiaoyu/luci-app-cloudflarespeedtest cloudf && mv -n cloudf/applications/luci-app-cloudflarespeedtest ./
rm -rf cloudf

git clone --depth 1 https://github.com/canmengxian/luci-app-cpu-perf

sed -i \
    -e 's?include \.\./\.\./\(lang\|devel\)?include $(TOPDIR)/feeds/packages/\1?' \
    -e 's?\.\./\.\./luci.mk?$(TOPDIR)/feeds/luci/luci.mk?' \
    */Makefile

git clone --depth 1 https://github.com/openwrt/packages packages13 && mv -n packages13/net/v2ray-core/test.sh ./packages/v2ray-core/
rm -rf packages13

cd packages
git_sparse_clone master "https://github.com/immortalwrt/packages" "imm" devel/gn net/{brook,cdnspeedtest,chinadns-ng,dns2socks,dns2tcp,hysteria,microsocks,naiveproxy,pdnsd-alt,redsocks2,sagernet-core,shadowsocks-rust,simple-obfs,tcping,trojan,trojan-plus,v2ray-geodata,v2ray-plugin,xray-core,xray-plugin,mosdns} utils/cpulimit
#svn export https://github.com/openwrt/packages/trunk/net/xray-core/test.sh && mv -n test.sh ./xray-core
# sed -i 's/36\.1/37-RC2/g' smartdns/Makefile
# sed -i 's/PKG_HASH:=.*/PKG_HASH:=b5fb39d759e333a37b33e56177bd3c7965387b8b1312f45d8709b178ac58f655/g' smartdns/Makefile
git clone --depth 1 https://github.com/jerrykuku/lua-maxminddb && rm -rf ./lua-maxminddb/.git* 

sed -i \
    -e 's?include \.\./\.\./\(lang\|devel\)?include $(TOPDIR)/feeds/packages/\1?' \
    -e 's?\.\./\.\./luci.mk?$(TOPDIR)/feeds/luci/luci.mk?' \
    */Makefile
cd ..

for e in $(ls -d luci-*/po); do
    if [[ -d $e/zh-cn && ! -d $e/zh_Hans ]]; then
        ln -s zh-cn $e/zh_Hans 2>/dev/null
    elif [[ -d $e/zh_Hans && ! -d $e/zh-cn ]]; then
        ln -s zh_Hans $e/zh-cn 2>/dev/null
    fi
done

git rm --cached packages/lua-maxminddb

rm -rf cm
rm -rf ./*/.git &
rm -rf ./*/.gitattributes &
rm -rf ./*/.svn &
rm -rf ./*/.github &
rm -rf ./*/.gitignore

exit 0
