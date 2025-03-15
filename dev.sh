#!/bin/bash

mkdir -p packages

#netdata
git clone --depth 1 https://github.com/sirpdboy/luci-app-netdata

#定时设置
git clone --depth 1 https://github.com/sirpdboy/luci-app-autotimeset

#adguardhome
git clone --depth 1 https://github.com/kiddin9/kwrt-packages packages12 && mv -n packages12/adguardhome ./packages/
rm -rf packages12
git clone --depth 1 https://github.com/Hyy2001X/AutoBuild-Packages packages12 && mv -n packages12/luci-app-adguardhome ./ 
rm -rf packages12
#sed -i 's@.*AdGuardHome.yaml*@#&@g' ./*adguardhome/Makefile
#sed -i 's/AdGuardHome.yaml/config\/AdGuardHome.yaml/g' ./*adguardhome/root/etc/config/AdGuardHome
#sed -i 's/default y/default n/g' ./*adguardhome/Makefile

#lucky
git clone --depth 1 https://github.com/gdy666/luci-app-lucky lucky && mv -n lucky/luci-app-lucky ./   && mv -n lucky/lucky ./packages/  
rm -rf lucky

#passwall
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall2 passwall2 && mv -n passwall2/luci-app-passwall2 ./
rm -rf passwall2

git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall passwall1 && mv -n passwall1/luci-app-passwall ./
rm -rf passwall1
#sed -i '92 s/n/y/' ./luci-app-passwall/Makefile
#sed -i '148 s/n /y /' ./luci-app-passwall/Makefile

git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall-packages packages1 && mv -n packages1/{sing-box,trojan-plus,tuic-client,v2ray-core,ipt2socks,ssocks,shadowsocksr-libev,geoview} ./packages/
rm -rf packages1

#ssrplus

git clone --depth 1 https://github.com/fw876/helloworld && mv -n helloworld/luci-app-ssr-plus ./ && mv -n helloworld/{lua-neturl,shadow-tls} ./packages/
rm -rf helloworld

#文件传输,访客网络，释放内存，IP/MAC绑定
git clone --depth 1 https://github.com/coolsnowwolf/luci && mv -n luci/applications/{luci-app-filetransfer,luci-app-guest-wifi,luci-app-ramfree,luci-app-arpbind} ./ && mv -n luci/libs/luci-lib-fs ./packages/
rm -rf luci
#sed -i 's/msgstr"/msgstr "/g' ./*guest-wifi/po/zh-cn/guest-wifi.po

#简易更新
git clone --depth 1 https://github.com/sundaqiang/openwrt-packages && mv -n openwrt-packages/luci-app-easyupdate ./
rm -rf openwrt-packages

#openclash
git clone --depth 1 https://github.com/vernesong/OpenClash -b dev && mv -n OpenClash/luci-app-openclash ./
rm -rf OpenClash
#sed -i 's/+libcap /+libcap +libcap-bin /g' luci-app-openclash/Makefile

#CPU 性能优化调节
#svn export https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-cpufre
git clone --depth 1 https://github.com/immortalwrt/luci && mv -n luci/applications/luci-app-cpufreq ./  && mv -n luci/applications/luci-app-natmap ./

git clone --depth 1 https://github.com/immortalwrt/immortalwrt && mv -n immortalwrt/package/emortal/cpufreq ./packages/
rm -rf luci && rm -rf immortalwrt
#sed -i 's@.*aarch64*@#&@g' luci-app-cpufreq/Makefile
#sed -i 's/\@(aarch64||arm)/ /g' luci-app-cpufreq/Makefile
#sed -i 's,1608,1800,g' luci-app-cpufreq/root/etc/uci-defaults/10-cpufreq
#sed -i 's,2016,2208,g' luci-app-cpufreq/root/etc/uci-defaults/10-cpufreq
#sed -i 's,1512,1608,g' luci-app-cpufreq/root/etc/uci-defaults/10-cpufreq

git clone --depth 1 https://github.com/immortalwrt/homeproxy luci-app-homeproxy

#svn export https://github.com/lllrrr/oppackages/trunk/luci-app-pwdHackDeny

sed -i \
    -e 's?include \.\./\.\./\(lang\|devel\)?include $(TOPDIR)/feeds/packages/\1?' \
    -e 's?\.\./\.\./luci.mk?$(TOPDIR)/feeds/luci/luci.mk?' \
    */Makefile

git clone --depth 1 https://github.com/openwrt/packages packages13 && mv -n packages13/net/v2ray-core/test.sh ./packages/v2ray-core/
rm -rf packages13



cd packages
git_sparse_clone master "https://github.com/immortalwrt/packages" "imm" devel/gn net/{brook,chinadns-ng,dns2socks,dns2tcp,hysteria,microsocks,naiveproxy,pdnsd-alt,redsocks2,shadowsocks-rust,simple-obfs,tcping,trojan,v2ray-geodata,v2ray-plugin,xray-core,xray-plugin,mosdns,natmap}
#svn export https://github.com/openwrt/packages/trunk/net/xray-core/test.sh && mv -n test.sh ./xray-core
# sed -i 's/36\.1/37-RC2/g' smartdns/Makefile
# sed -i 's/PKG_HASH:=.*/PKG_HASH:=b5fb39d759e333a37b33e56177bd3c7965387b8b1312f45d8709b178ac58f655/g' smartdns/Makefile
git clone --depth 1 https://github.com/sbwml/packages_new_nat6 new_nat6



sed -i \
    -e 's?include \.\./\.\./\(lang\|devel\)?include $(TOPDIR)/feeds/packages/\1?' \
    -e 's?\.\./\.\./luci.mk?$(TOPDIR)/feeds/luci/luci.mk?' \
    */Makefile


rm -rf ./*/.git &
rm -f ./*/.gitattributes &
rm -rf ./*/.svn &
rm -rf ./*/.github &
rm -rf ./*/.gitignore
    
cd ..

# 遍历所有以 luci- 开头的目录下的 po 文件夹
for e in $(ls -d luci-*/po); do
    # 如果存在 zh-cn 目录且不存在 zh_Hans 目录，则创建符号链接
    if [[ -d $e/zh-cn && ! -d $e/zh_Hans ]]; then
        ln -s zh-cn "$e/zh_Hans" 2>/dev/null
    # 如果存在 zh_Hans 目录且不存在 zh-cn 目录，则创建符号链接
    elif [[ -d $e/zh_Hans && ! -d $e/zh-cn ]]; then
        ln -s zh_Hans "$e/zh-cn" 2>/dev/null
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
