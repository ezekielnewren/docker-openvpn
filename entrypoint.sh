#!/bin/bash

mkdir -p /etc/ssl/issued 2>/dev/null
mkdir -p /etc/ssl/private 2>/dev/null

name="vpn.ezekielnewren.com"
jq -rM .data.certificate /etc/ssl/vault/$name.json > /etc/ssl/issued/$name.crt
jq -rM .data.ca_chain[] /etc/ssl/vault/$name.json >> /etc/ssl/issued/$name.crt
jq -rM .data.private_key /etc/ssl/vault/$name.json > /etc/ssl/private/$name.key && chmod 640 /etc/ssl/private/$name.key
