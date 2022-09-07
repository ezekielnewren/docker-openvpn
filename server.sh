## rules required to be run on the host
## forward traffic from clients
# sudo iptables -A FORWARD -i tun0 -s 192.168.255.0/24 -j ACCEPT
## nat packets so that dns via udp works
# sudo iptables -t nat -I POSTROUTING -s 192.168.255.0/24 -o br0 -j MASQUERADE

exists_and_not_empty() {
    path="$1"
    if [ ! -f $path ]; then
        echo "$path no such file or directory"
        exit 1
    fi

    if [ "$(wc -c $path | cut -d' ' -f1)" == "0" ]; then
        echo "$path is empty"
        exit 2
    fi
}

exists_and_not_empty /etc/ssl/private/vault/vpn.ezekielnewren.com.json
exists_and_not_empty /etc/ssl/dh2048.pem
exists_and_not_empty /etc/ssl/private/ta.key

docker build --network host -t openvpn . || exit 1
docker rm -f vpn_home
sleep 1
docker run --name vpn_home --privileged --restart always -itd \
-w /docker -v $PWD:/docker -v /etc/ssl:/etc/ssl --network=host \
openvpn # "/provision.sh && exec bash"
