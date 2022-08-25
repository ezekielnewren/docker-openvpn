## rules required to be run on the host
## forward traffic from clients
# sudo iptables -A FORWARD -i tun0 -s 192.168.255.0/24 -j ACCEPT
## nat packets so that dns via udp works
# sudo iptables -t nat -I POSTROUTING -s 192.168.255.0/24 -o br0 -j MASQUERADE


docker build -t openvpn . || exit 1
docker rm -f vpn_home
docker run --name vpn_home --privileged --restart always -itd \
-w /docker -v $PWD:/docker -v /etc/ssl:/etc/ssl --network=host \
openvpn
