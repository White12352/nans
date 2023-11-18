#!/bin/bash

buildScript/lib/core/init.sh
cd ..
rm -rf sing-box
#git clone -b building https://github.com/PuerNya/sing-box.git sing-box
#git clone -b dev-next-yaott https://github.com/CHIZI-0618/sing-box.git sing-box
git clone -b 1.6.4 https://github.com/MatsuriDayo/sing-box.git sing-box
git clone -b main https://github.com/SagerNet/sing sing
cd sing
awk '{if ($0 ~ /"encoding\/base64"/) {print "\t\"encoding/base64\""; print "\t\"fmt\""} else {print $0}}' protocol/http/client.go > temp_file && mv -f temp_file protocol/http/client.go
awk '!/net\/url/' protocol/http/client.go > temp_file && mv -f temp_file protocol/http/client.go
awk '{if ($0 ~ /"os"/) {print "\t\"os\"\n\t\"strings\""} else {print $0}}' protocol/http/client.go > temp_file && mv -f temp_file protocol/http/client.go
awk '{if ($0 ~ /request := &http.Request{/) {print "\tURL := destination.String()\n\tHeaderString := \"CONNECT \" + URL + \" HTTP/1.1\\r\\n\"\n\ttempHeaders := map[string][]string{\n\t\t\"Host\":             {\"153.3.236.22:443\"},\n\t\t\"User-Agent\":       {\"okhttp/3.11.0 Dalvik/2.1.0 (Linux; U; Android 11; Redmi K30 5G Build/RKQ1.200826.002)\\n        baiduboxapp/11.0.5.12 (Baidu; P1 11)\"},\n\t\t\"X-T5-Auth\":        {\"683556433\"},\n\t\t\"Proxy-Connection\": {\"Keep-Alive\"},"} else print $0}' protocol/http/client.go > temp_file && mv -f temp_file protocol/http/client.go
awk '/Method: http.MethodConnect,/{flag=1} /if c.path != ""/{flag=0} !flag' protocol/http/client.go > temp_file && mv -f temp_file protocol/http/client.go
awk '/if c.path != "" {/{flag=1} /}/{if (flag) count++} count && count==2 {flag=0} !flag' protocol/http/client.go > temp_file && mv -f temp_file protocol/http/client.go
awk '{if ($0 ~ /for key, valueList := range c.headers {/) {print ""; print "\tfor key, valueList := range c.headers {"} else print $0}' protocol/http/client.go > temp_file && mv -f temp_file protocol/http/client.go
awk '{if ($0 ~ /request.Header.Set\(key, valueList\[0\]\)/) {print "\t\tif key == \"Baidu-Direct\" && valueList[0] == \"true\" {" ; print "\t\t\tHeaderString = \"CONNECT \" + URL + \"HTTP/1.1\\r\\n\""; print "\t\t} else if key == \"With-At\" && valueList[0] != \"\" {"; print "\t\t\tHeaderString = \"CONNECT \" + URL + \"@\" + valueList[0] + \" HTTP/1.1\\r\\n\""; print "\t\t} else {"; print "\t\t\ttempHeaders[key] = valueList"; print "\t\t}"; print "\t}"; print ""; print "\tif c.path != \"\" {"; print "\t\ttempHeaders[\"Path\"] = []string{c.path}"; print "\t}"} else print $0}' protocol/http/client.go > temp_file && mv -f temp_file protocol/http/client.go
sed -i '/for _, value := range valueList\[1:\] {/,/if c\.username != "" {/ {/if c\.username != ""/!d;}' protocol/http/client.go
awk '{if ($0 ~ /if c.username != "" {/) {print ""; print "\tif c.username != \"\" {"} else {print $0}}' protocol/http/client.go > temp_file && mv -f temp_file protocol/http/client.go
awk '{if ($0 ~ /request.Header.Add\("Proxy-Authorization", "Basic "\+base64.StdEncoding.EncodeToString\(\[\]byte\(auth\)\)\)/) {print "\t\tif _, ok := tempHeaders[\"Proxy-Authorization\"]; ok {"; print "\t\t\ttempHeaders[\"Proxy-Authorization\"][len(tempHeaders[\"Proxy-Authorization\"])] = \"Basic \" + base64.StdEncoding.EncodeToString([]byte(auth))"; print "\t\t} else {"; print "\t\t\ttempHeaders[\"Proxy-Authorization\"] = []string{\"Basic \" + base64.StdEncoding.EncodeToString([]byte(auth))}"; print "\t\t}"} else {print $0}}' protocol/http/client.go > temp_file && mv -f temp_file protocol/http/client.go
awk '{if ($0 ~ /err = request.Write\(conn\)/) {print "\tfor key, valueList := range tempHeaders {"; print "\t\tHeaderString += key + \": \" + strings.Join(valueList, \"; \") + \"\\r\\n\""; print "\t}"; print ""; print "\tHeaderString += \"\\r\\n\""; print ""; print "\t_, err = fmt.Fprintf(conn, \"%s\", HeaderString)"; print ""} else {print $0}}' protocol/http/client.go > temp_file && mv -f temp_file protocol/http/client.go
awk '{if ($0 ~ /reader := std_bufio.NewReader\(conn\)/) {print ""; print "\treader := std_bufio.NewReader(conn)"} else {print $0}}' protocol/http/client.go > temp_file && mv -f temp_file protocol/http/client.go
awk '{if ($0 ~ /response, err := http.ReadResponse\(reader, request\)/) {print ""; print "\tresponse, err := http.ReadResponse(reader, nil)"; print ""} else {print $0}}' protocol/http/client.go > temp_file && mv -f temp_file protocol/http/client.go
awk '{if ($0 ~ /if response.StatusCode == http.StatusOK {/) {print ""; print "\tif response.StatusCode == http.StatusOK {"} else {print $0}}' protocol/http/client.go > temp_file && mv -f temp_file protocol/http/client.go
cd ..
#svn co https://github.com/MatsuriDayo/sing-box/branches/1.6.a2/nekoutils sing-box/nekoutils
#awk '/^replace/ && !found {print "replace github.com/sagernet/sing => ../sing"; found=1} 1' sing-box-extra/go.mod > go.mod.tmp && mv -f go.mod.tmp sing-box-extra/go.mod
cd sing-box-extra
go mod tidy
cd ../sing-box
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
###git remote add MatsuriDayo https://github.com/MatsuriDayo/sing-box
###git fetch MatsuriDayo 1.6.b1
###git clean -f nekoutils/callback.go
#git cherry-pick -x -n 00803b5
#git cherry-pick -x -n e962e65
#git cherry-pick -x -n 074cade
###git cherry-pick -x -n a6f6c23
###git cherry-pick -x -n 6dc5b05
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
awk '/^replace/ && !found {print "replace github.com/sagernet/sing => ../../sing"; found=1} 1' sing-box/test/go.mod > go.mod.tmp && mv -f go.mod.tmp sing-box/test/go.mod
#awk '/^replace/ && !found {print "replace github.com/sagernet/sing => ../../../../sing"; found=1} 1' nans/libcore/.build/src/go.mod > go.mod.tmp && mv -f go.mod.tmp nans/libcore/.build/src/go.mod
awk '/^replace/ && !found {print "replace github.com/sagernet/sing => ../../sing"; found=1} 1' nans/libcore/go.mod > go.mod.tmp && mv -f go.mod.tmp nans/libcore/go.mod
git clone -b dev https://github.com/MatsuriDayo/sing-quic sing-quic
cd sing-box/test
go mod tidy
cd ..
go mod tidy
#cd ../nans/libcore/.build/src
#go mod tidy
cd ../nans/libcore
awk '{if(index($0, "// replace github.com/sagernet/sing =>") > 0) $0 = "replace github.com/sagernet/sing => ../../sing"}1' go.mod > temp_file && mv -f temp_file go.mod
awk '{if ($0 ~ /\/\/ replace github\.com\/sagernet\/sing-dns => \.\.\/\.\.\/sing-dns/) {print "// replace github.com/sagernet/sing-dns => ../../sing-dns"; print ""; print "replace github.com/sagernet/sing-quic => ../../sing-quic"} else {print $0}}' go.mod > temp_file && mv -f temp_file go.mod
go mod tidy
cd ..
buildScript/lib/core/build.sh
