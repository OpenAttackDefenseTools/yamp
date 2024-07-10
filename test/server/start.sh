#!/bin/bash
set -e
set -u

sleep 0.5

# Setup wireguard tunnel
ip link add yampa type wireguard
wg set yampa private-key <(echo "$PROXY_PEER_PRIVATE") listen-port 51820 peer "$PROXY_OWN_PUBLIC" endpoint yampa:51821 persistent-keepalive 1 allowed-ips 10.2.3.0/24
ip -4 address add 10.2.3.4/32 dev yampa
ip link set mtu 1420 up dev yampa
ip -4 route add 10.2.3.0/24 dev yampa

exec python3 -m app
