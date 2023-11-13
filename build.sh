#!/bin/bash

# Install build dependencies
sudo apt-get update
sudo apt-get install -y build-essential libssl-dev libcurl4-openssl-dev

# Download and extract the latest version of curl
latest_curl_version=$(curl -s https://curl.se/download/ | grep -o 'curl-[0-9.]*.tar.gz' | head -n 1)
curl -LO https://curl.se/download/$latest_curl_version
curl -LO https://curl.se/download/$latest_curl_version.asc

tar -xzf $latest_curl_version
curl_folder_name=$(basename $latest_curl_version .tar.gz)
cd $curl_folder_name

prefix="/usr/"
# Configure, compile, and install
./configure --build='\`dpkg-architecture -qDEB_BUILD_GNU_TYPE\` '--prefix=${prefix}' '--includedir=${prefix}/include' '--mandir=${prefix}/share/man' '--infodir=${prefix}/share/info' '--sysconfdir=/etc' '--localstatedir=/var' '--disable-option-checking' '--disable-silent-rules' '--libdir=${prefix}/lib/'\`dpkg-architecture -qDEB_HOST_MULTIARCH\` '--runstatedir=/run' '--disable-maintainer-mode' '--disable-dependency-tracking' '--disable-symbol-hiding' '--enable-versioned-symbols' '--enable-threaded-resolver' '--with-lber-lib=lber' '--with-gssapi=/usr' '--with-nghttp2' '--includedir=/usr/include/'\`dpkg-architecture -qDEB_HOST_MULTIARCH\` '--with-zsh-functions-dir=/usr/share/zsh/vendor-completions' '--with-libssh' '--without-libssh2' '--with-openssl' '--with-ca-path=/etc/ssl/certs' '--with-ca-bundle=/etc/ssl/certs/ca-certificates.crt' 'build_alias='\`dpkg-architecture -qDEB_BUILD_GNU_TYPE\` 'CFLAGS=-g -O2  -flto=auto -ffat-lto-objects -flto=auto -ffat-lto-objects -fstack-protector-strong -Wformat -Werror=format-security' 'LDFLAGS=-Wl,-Bsymbolic-functions -flto=auto -ffat-lto-objects -flto=auto -Wl,-z,relro -Wl,-z,now' 'CPPFLAGS=-Wdate-time -D_FORTIFY_SOURCE=2
sudo make
sudo make install
#mv /usr/bin/curl /usr/bin/curl.bak
#mv /usr/local/bin/curl /usr/bin/curl
sudo ldconfig

# Cleanup
cd ..
rm -rf $curl_folder_name
rm $latest_curl_version $latest_curl_version.asc
