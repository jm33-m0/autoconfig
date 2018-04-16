#!/bin/bash

iptables -t nat -D OUTPUT -p tcp -j SHADOWSOCKS
iptables -t nat -D OUTPUT -p udp -j SHADOWSOCKS
iptables -t nat -F SHADOWSOCKS
iptables -t nat -X SHADOWSOCKS

ipset destroy chnroute
