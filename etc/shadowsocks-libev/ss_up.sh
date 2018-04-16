#!/bin/bash

# Setup the ipset
ipset -N chnroute hash:net maxelem 65536

for ip in $(cat '/etc/shadowsocks-libev/chnroute.txt'); do
    ipset add chnroute $ip
done

# Setup iptables
iptables -t nat -N SHADOWSOCKS

# Allow connection to the server
iptables -t nat -A SHADOWSOCKS -d 103.101.153.224 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 202.5.17.166 -j RETURN

# Allow connection to reserved networks
iptables -t nat -A SHADOWSOCKS -d 100.100.2.0/24 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 0.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 10.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 127.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 169.254.0.0/16 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 172.16.0.0/12 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 192.168.0.0/16 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 224.0.0.0/4 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 240.0.0.0/4 -j RETURN

# Allow connection to Chinese IPs
iptables -t nat -A SHADOWSOCKS -p tcp -m set --match-set chnroute dst -j RETURN
iptables -t nat -A SHADOWSOCKS -p udp -m set --match-set chnroute dst -j RETURN

# Redirect to Shadowsocks
iptables -t nat -A SHADOWSOCKS -p tcp -j REDIRECT --to-port 54763
iptables -t nat -A SHADOWSOCKS -p udp -j REDIRECT --to-port 54763

# Redirect to SHADOWSOCKS
iptables -t nat -A OUTPUT -p tcp -j SHADOWSOCKS
iptables -t nat -A OUTPUT -p udp -j SHADOWSOCKS

echo "nameserver 127.0.0.1" > /etc/resolv.conf
