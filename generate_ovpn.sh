#!/bin/bash

fqdn="$1"
ttl="30d"

secret=$(vault write -format=json authority/pki/issue/ezekielnewren-client common_name="$fqdn" ttl="$ttl" | jq -rMc .)
if [ "$secret" == "" ]; then
    echo "failed to generate key pair"
    exit 1
fi

echo "client"
echo "nobind"
echo "dev tun"
echo "remote-cert-tls server"
echo
echo "remote vpn.ezekielnewren.com 1194 udp"
echo
echo "<key>"
echo $secret | jq -rM .data.private_key
echo "</key>"
echo "<cert>"
echo $secret | jq -rM .data.certificate
echo "</cert>"
echo "<ca>"
echo $secret | jq -rM .data.ca_chain[]
echo "</ca>"
echo "key-direction 1"
echo "auth SHA256"
echo "<tls-auth>"
vault kv get service/secret/openvpn | jq -rM .data.data.ta
echo "</tls-auth>"
echo
echo "redirect-gateway def1"
