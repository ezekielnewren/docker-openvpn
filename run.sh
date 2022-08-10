#!/bin/bash

docker build -t openvpn . || exit 1
docker run --name vpn_home --privileged --rm -it -w /docker -v $PWD:/docker -v /etc/ssl:/etc/ssl --network=host openvpn
