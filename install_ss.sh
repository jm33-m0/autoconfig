#!/bin/bash

dot_repo="https://github.com/m13253/dns-over-https.git"
ss_config="https://raw.githubusercontent.com/jm33-m0/autoconfig/master/ss_config.tgz"
ss_service="https://raw.githubusercontent.com/jm33-m0/autoconfig/master/ss-redir@.service"
dot_config="https://raw.githubusercontent.com/jm33-m0/autoconfig/master/doh-client.conf"

YELLOW='\033[0;33m'
RED='\033[0;31m'
END='\033[0m'

check_root() {
    if [ ! $(id -u) -eq 0 ]; then
        echo -e "$RED[-] You must be root$END"
        exit 1
    fi
}

install_ss() {
    sudo sh -c 'printf "deb http://deb.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/stretch-backports.list'
    sudo apt update
    sudo apt -t stretch-backports install shadowsocks-libev -y
}

install_dot() {
    echo -e "$YELLOW[*] make sure you have installed Go and configured GOPATH correctly$END"
    if [ -z $GOPATH ]; then
        echo -e "$RED[-] GOPATH not set, can't proceed$END"
        exit 1
    fi
    git clone $dot_repo dot && \
        cd dot
    make && make install
}

dns_config() {
    install_dot

    # dnsmasq service
    apt-get install dnsmasq -y
    grep "server=127.0.0.1#5353" /etc/dnsmasq.conf > /dev/null
    if [ ! $? -eq 0 ]; then
        echo -e "server=127.0.0.1#5353" >> /etc/dnsmasq.conf
    fi
    systemctl enable dnsmasq.service
    systemctl restart dnsmasq.service

    # dns over https service
    curl -fLo /etc/dns-over-https/doh-client.conf $dot_config
    systemctl restart doh-client.service
    systemctl enable doh-client.service
}

main() {
    check_root
    install_ss

    # install ipset
    apt-get install ipset -y

    # ss config under /etc
    curl -fLo /tmp/ss_config.tgz $ss_config && \
        tar xvpf /tmp/ss_config.tgz -C /

    # ss service
    curl -fLo /lib/systemd/system/ss-redir@.service $ss_service && \
        systemctl daemon-reload

    # start service
    systemctl start ss-redir@config.service
    systemctl enable ss-redir@config.service

    # get DNS ready
    dns_config
}

main
