#!/bin/bash

ss_config="https://raw.githubusercontent.com/jm33-m0/autoconfig/master/ss_config.tgz"
ss_service="https://raw.githubusercontent.com/jm33-m0/autoconfig/master/ss-redir@.service"
dot_archive="https://raw.githubusercontent.com/jm33-m0/autoconfig/master/dot.tgz"

YELLOW='\033[0;33m'
RED='\033[0;31m'
END='\033[0m'

check_root() {
    if [ ! "$(id -u)" -eq 0 ]; then
        echo -e "$RED[-] You must be root$END"
        exit 1
    fi
}

install_ss() {
    echo -e "$YELLOW[*] Installing Shadowsocks$END"
    if [ "$(uname -m)" = "x86_64" ]; then
        sh -c 'printf "deb http://deb.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/stretch-backports.list'
        apt update
        apt -t stretch-backports install shadowsocks-libev -y
    else
        echo -e "$YELLOW[*] Compiling Shadowsocks$END"
        apt-get install --no-install-recommends gettext build-essential autoconf libtool libpcre3-dev asciidoc xmlto libev-dev libc-ares-dev automake libmbedtls-dev libsodium-dev -y
        git clone https://github.com/shadowsocks/shadowsocks-libev.git
        cd shadowsocks-libev || return
        ./autogen.sh
        ./configure || echo "$YELLOW[-] Configure error!$END"
        make install
        which ss-redir || echo "$YELLOW[-] SS not installed!$END"
    fi
}

install_dot() {
    echo -e "$YELLOW[*] Installing DNSOverHTTPS$END"
    curl -fLo dot.tgz $dot_archive &&
        tar xvzpf dot.tgz
    cd dot || return
    make install
}

dns_config() {
    install_dot
    echo -e "$YELLOW[*] Configuring DNSOverHTTPS$END"

    # dnsmasq service
    apt-get install dnsmasq -y
    if ! grep "server=127.0.0.1#53535" /etc/dnsmasq.conf >/dev/null 2>&1; then
        echo -e "server=127.0.0.1#53535" >>/etc/dnsmasq.conf
    fi
    systemctl enable dnsmasq.service
    systemctl restart dnsmasq.service

    # dns over https service
    systemctl restart doh-client.service
    systemctl enable doh-client.service
}

main() {
    check_root
    install_ss

    # install ipset
    apt-get install ipset -y

    # ss config under /etc
    curl -fLo /tmp/ss_config.tgz $ss_config &&
        tar xvpf /tmp/ss_config.tgz -C /

    # ss service
    curl -fLo /lib/systemd/system/ss-redir@.service $ss_service &&
        systemctl daemon-reload

    # get DNS ready
    dns_config

    # start service
    echo -e "$YELLOW[*] Starting SS service$END"
    systemctl start ss-redir@config.service
    systemctl enable ss-redir@config.service
}

main
