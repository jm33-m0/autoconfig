#!/bin/bash

# by: jm33-ng
# 2017-06-10
# change log
# 2018-03-24 - switch to spacevim

# urls of target scripts and config files
zsh_url='https://raw.githubusercontent.com/jm33-m0/autoconfig/master/oh-my-zsh.sh'
sshd_url='https://raw.githubusercontent.com/jm33-m0/autoconfig/master/sshd_config'

# install curl if no curl is detected
apt-get update && apt-get install curl -y

function check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo '[-] Please run me as root'
        exit 1
    fi
}

# install sshd_config
function sshd_config() {
    check_root
    echo '[*] Installing ssh_config'
    curl -kfsSL $sshd_url -o /etc/ssh/sshd_config
    systemctl restart ssh.service || service sshd restart

    echo '[*] Adding user jm33'
    test -e "$HOME/.ssh" || mkdir -p "$HOME/.ssh"
    cat <<EOF >"$HOME/.ssh/authorized_keys"
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDVaXjv5cX1pjgURLBSleYZYK/jQNr+RF1Sdqa9RHQTGaBynfuuESMU/0BGu8BQLo83F4z5MEzmpG8zOkKjJzbE/1cqfgWEK2KOX5O1LlwqbfMg+8IJd0LMhdlY1o7mvV59s6ke9qcosyq3W3aoRXultfBRgE9GrPxyYmuJyQTiM3S6Y0PDC6FvhyfXpj0lKc6J6vJMF8pzEeWbrqdcd/bBAdpp9wonEs3NBFRso4EwrUV+j9nP61/bD1QfkyjGnJxD8ufcE5V0dLS1SLkGW5ilgp/5fagu9Wj9pEHLNTuUO1pl9tbTEFSXvkeNBCrqBCYH7v4fQRlTtI+P/vzWRiuJLabcvJcwBbaJkc9UoqJ6omw0gBonlY4f5PLHA0epx42cCIcU+7TUAqn2gpqQ9ZCFBYV01e4e+uaC2ko1Es6ua8jrIc2OHuaW8n2MsHfbQfuknDg/08fJu6O7We33pzE2Xc4anOivVfM4MSN5U8BJH5AOIhJA84QrH8PSjIalEowqZDXxb+LVkIPhG7wlqr8kw7wq2ZK9WMz+5tT3XBcJYlPWqwwy/5gKjj9JLBwTiDw1NtXM04327ygKaPBKALfSXSXTB7B1rars7KclgKZ1u3elghqy3jB3vVBCStrxue8aiP7EQhDgfBWZLNhoAFURzfGQ5VDSUHtH+L6K8Ha2tw== jm33@jm33.me
EOF
    useradd -m jm33 &&
        mkdir /home/jm33/.ssh &&
        cp ~/.ssh/authorized_keys /home/jm33/.ssh

    echo '[?] Set password for jm33:'
    passwd jm33
    echo '[?] Set password for root:'
    passwd
}

function vim_install() {
    echo '[*] Installing Vim'
    curl -sLf https://github.com/jm33-m0/vim_dotfiles/raw/master/install.sh | bash
}

function zsh_install() {
    echo '[*] Installing oh-my-zsh'
    curl -kfsSL $zsh_url | bash
}

function install_packages() {
    check_root
    mkdir -p /projects/golang

    echo '[*] Installing daily packages'
    apt update &&
        apt full-upgrade -y &&
        apt install -y tmux nmap glances htop iftop build-essential mtr python-dev python3-dev python-pip python-setuptools python3-setuptools python3-pip autoconf automake make cmake clang golang git zsh obfs4proxy aria2 powerline shellcheck llvm clang-format tor

    # this might be unavailable in older distros
    apt install universal-ctags -y

    # shell format for vim-autofmt
    go get -u -v mvdan.cc/sh/cmd/shfmt

    # python related
    apt install python3-autopep8 pylint3 -y
    python2 -m pip install pylint --user
    mv "$HOME"/.local/bin/pylint "$HOME"/.local/bin/pylint_2
    ln -s /usr/bin/pylint3 /usr/local/bin/pylint
}

install_packages
test -e ~/.vim || vim_install
test -e ~/.oh-my-zsh || zsh_install
grep "45672" /etc/ssh/sshd_config || sshd_config

chown -R jm33:jm33 /home/jm33/.*
chown -R jm33:jm33 /projects/golang

echo "[*] Enabling BBR..."
grep -i "bbr" /etc/sysctl.conf >/dev/null
if ! grep -i "bbr" /etc/sysctl.conf >/dev/null 2>&1; then
    echo "net.core.default_qdisc=fq" >>/etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" >>/etc/sysctl.conf
    sysctl -p
fi
echo "[*] Checking BBR..."
sysctl net.ipv4.tcp_available_congestion_control
sysctl net.ipv4.tcp_congestion_control
lsmod | grep bbr
