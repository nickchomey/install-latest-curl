#!/bin/bash

# Install build dependencies
sudo apt-get update
sudo apt-get install -y build-essential libssl-dev libcurl4-openssl-dev gnupg

# Download and extract the latest version of curl
latest_curl_version=$(curl -s https://curl.se/download/ | grep -o 'curl-[0-9.]*.tar.gz' | head -n 1)
curl -LO https://curl.se/download/$latest_curl_version
curl -LO https://curl.se/download/$latest_curl_version.asc

tar -xzvf $latest_curl_version
curl_folder_name=$(basename $latest_curl_version .tar.gz)
cd $curl_folder_name

# Configure, compile, and install
./configure --with-openssl
make
sudo make install

# Cleanup
cd ..
rm -rf $curl_folder_name
rm $latest_curl_version $latest_curl_version.asc
