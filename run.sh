#!/bin/bash

docker build -t openvpn . && docker run --name vpn_home -it -w /root --network=host openvpn
