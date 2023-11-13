#!/bin/bash

# Install build dependencies
sudo apt-get update
sudo apt-get install -y build-essential libssl-dev libcurl4-openssl-dev gnupg

# Download and extract the latest version of curl
latest_curl_version=$(curl -s https://curl.se/download/ | grep -o 'curl-[0-9.]*.tar.gz' | head -n 1)
curl -LO https://curl.haxx.se/download/$latest_curl_version
curl -LO https://curl.haxx.se/download/$latest_curl_version.asc

# Import and retrieve the GPG key
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys "$(< $latest_curl_version.asc awk '$1 == "Key" {print $2}')"

# Verify the GPG signature
gpg --verify $latest_curl_version.asc $latest_curl_version

# Exit if the verification fails
if [ $? -ne 0 ]; then
    echo "GPG verification failed. Exiting."
    exit 1
fi

tar -xzvf $latest_curl_version
curl_folder_name=$(basename $latest_curl_version .tar.gz)
cd $curl_folder_name

# Configure, compile, and install
./configure
make
sudo make install

# Cleanup
cd ..
rm -rf $curl_folder_name
rm $latest_curl_version $latest_curl_version.asc
