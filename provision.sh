#!/bin/bash

mkdir -p /etc/ssl/issued 2>/dev/null
mkdir -p /etc/ssl/ca 2>/dev/null
mkdir -p /etc/ssl/private 2>/dev/null

if [ ! -f /etc/ssl/dh2048.pem ]; then
    openssl dhparam -out /etc/ssl/dh2048.pem 2048
    chmod 644 /etc/ssl/dh2048.pem
fi

name="vpn.ezekielnewren.com"
file_json="/etc/ssl/private/vault/$name.json"
jq -rM .data.ca_chain[] $file_json > /etc/ssl/ca/chain.pem
jq -rM .data.certificate $file_json > /etc/ssl/issued/$name.crt
jq -rM .data.private_key $file_json > /etc/ssl/private/$name.key && chmod 640 /etc/ssl/private/$name.key

mkdir -p /tmp/openvpn 2>/dev/null
cat server.conf server_tun.conf > /tmp/openvpn/server_tun.conf
cat server.conf server_tap.conf > /tmp/openvpn/server_tap.conf
