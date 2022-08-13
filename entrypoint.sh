#!/bin/bash

mkdir -p /etc/ssl/issued 2>/dev/null
mkdir -p /etc/ssl/ca 2>/dev/null
mkdir -p /etc/ssl/private 2>/dev/null

name="vpn.ezekielnewren.com"
file_json="/etc/ssl/private/vault/$name.json"
jq -rM .data.certificate $file_json > /etc/ssl/issued/$name.crt
jq -rM .data.ca_chain[] $file_json > /etc/ssl/ca/chain.pem
cat /etc/ssl/certs/EzekielNewrenRoot.pem >> /etc/ssl/ca/chain.pem
jq -rM .data.private_key $file_json > /etc/ssl/private/$name.key && chmod 640 /etc/ssl/private/$name.key
