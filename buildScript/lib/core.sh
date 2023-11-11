#!/bin/bash

buildScript/lib/core/init.sh
cd ..
rm -rf sing-box
#git clone -b building https://github.com/PuerNya/sing-box.git sing-box
#git clone -b dev-next-yaott https://github.com/CHIZI-0618/sing-box.git sing-box
git clone -b dev-next https://github.com/SagerNet/sing-box.git sing-box
git clone -b dev https://github.com/White12352/sing sing
svn co https://github.com/MatsuriDayo/sing-box/branches/1.7.a10/nekoutils sing-box/nekoutils
svn co https://github.com/MatsuriDayo/sing-box/branches/1.7.a10/outbound t/outbound
rm -f sing-box/outbound/selector.go
cp -f t/outbound/selector.go sing-box/outbound/selector.go
cd sing-box
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
#git remote add MatsuriDayo https://github.com/MatsuriDayo/sing-box
#git fetch MatsuriDayo 1.7.a10
#git clean -f nekoutils/callback.go
#git cherry-pick -x -n 00803b5
#git cherry-pick -x -n e962e65
#git cherry-pick -x -n 074cade
##git cherry-pick -x -n a6f6c23
##git cherry-pick -x -n 6dc5b05
#git cherry-pick -x -n e40ce5e
#git cherry-pick -x -n 209eae6
#git cherry-pick -x -n 7e553db
#git cherry-pick -x -n a64e8ec
#git cherry-pick -x -n 1927ca5
cd ..
#sed 's/err = router.Initialize(inbounds, outbounds, func() adapter.Outbound {/err = router.Initialize(inbounds, []adapter.OutboundProvider{func() adapter.Outbound {/' -i sing-box-extra/boxbox/box.go
#sed 's/})/}}, outbounds, func() adapter.Outbound { return nil })/' -i sing-box-extra/boxbox/box.go
ls -la
git clone -b dev-11 https://github.com/White12352/spa spa
ls -la
rm -f sing-box/outbound/shadowsocksr.go
rm -f sing-box/outbound/shadowsocksr_stub.go
mv -f spa/.github/outbound/* sing-box/outbound/
mv -f spa/.github/test/* sing-box/test/
mv -f spa/.github/transport/* sing-box/transport/
mv -f spa/.github/common/sniff/* sing-box/common/sniff/
sed -i '0,/berty.tech\/go-libtor v[0-999]\+\.[0-999]\+\.[0-999]\+/s//&\n\tgithub.com\/Dreamacro\/clash v1.17.0/' sing-box/go.mod
awk '/github.com\/ajg\/form v[0-9]+\.[0-9]+\.[0-9]+ \/\/ indirect/ && !inserted {print "\tgithub.com/Dreamacro/protobytes v0.0.0-20230617041236-6500a9f4f158 // indirect"; inserted=1} 1' sing-box/go.mod > temp && mv -f temp sing-box/go.mod
sed -i -e '/ImageShadowTLS             = "ghcr.io\/ihciah\/shadow-tls:latest"/ { N; s/ImageShadowTLS             = "ghcr.io\/ihciah\/shadow-tls:latest"\n/ImageShadowTLS             = "ghcr.io\/ihciah\/shadow-tls:latest"\n\tImageShadowsocksR          = "teddysun\/shadowsocks-r:latest"\n/ }' sing-box/test/clash_test.go
#sed -i '/ImageShadowTLS             = "ghcr.io\/ihciah\/shadow-tls:latest"/a \	\tImageShadowsocksR          = "teddysun\/shadowsocks-r:latest"' sing-box/test/clash_test.go
awk '/ImageShadowTLS,/ {print; print "\tImageShadowsocksR,"; next} 1' sing-box/test/clash_test.go > temp && mv -f temp sing-box/test/clash_test.go
sed -i '/berty\.tech\/go-libtor v[0-999]\+\.[0-999]\+\.[0-999]\+ \/\//a \\tgithub.com\/Dreamacro\/clash v1.17.0 // indirect\n\tgithub.com\/Dreamacro\/protobytes v0.0.0-20230617041236-6500a9f4f158 // indirect' sing-box/test/go.mod
awk '/ProtocolSTUN = "stun"/ {print; print "\tProtocolBittorrent = \"bittorrent\""; inserted=1; next} 1; END {if (!inserted) print "\tProtocolBittorrent = \"bittorrent\""}' sing-box/constant/protocol.go > temp_file && mv -f temp_file sing-box/constant/protocol.go 
awk '{ if (/sniffMetadata, err := sniff.PeekStream\(ctx, conn, buffer, time\.Duration\(metadata\.InboundOptions\.SniffTimeout\), sniff\.StreamDomainNameQuery, sniff\.TLSClientHello, sniff\.HTTPHost\)/) sub("sniff\\.HTTPHost", "sniff.HTTPHost, sniff.BittorrentTCPMessage") } { print }' sing-box/route/router.go > temp && mv -f temp sing-box/route/router.go 
sed -i 's/sniffMetadata, _ := sniff.PeekPacket(ctx, buffer.Bytes(), sniff.DomainNameQuery, sniff.QUICClientHello, sniff.STUNMessage)/sniffMetadata, _ := sniff.PeekPacket(ctx, buffer.Bytes(), sniff.DomainNameQuery, sniff.QUICClientHello, sniff.STUNMessage, sniff.BittorrentUDPMessage)/' sing-box/route/router.go
awk '{if(index($0, "//replace github.com/sagernet/sing") > 0) $0 = "replace github.com/sagernet/sing => ../sing"}1' sing-box/go.mod > temp_file && mv -f temp_file sing-box/go.mod
git clone -b dev https://github.com/SagerNet/sing-quic sing-quic
cd sing-box/test
go mod tidy
cd ..
go mod tidy
cd ../nans/libcore
go mod tidy
cd ..
buildScript/lib/core/build.sh
