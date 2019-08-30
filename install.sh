#!/bin/bash

# by: jm33-ng

YELLOW='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
END='\033[0m'

export GOPATH=/projects/golang

function info() {
    echo -e "$CYAN [*] $1 $END"
}

function warning() {
    echo -e "$YELLOW [!] $1 $END"
}

function error() {
    echo -e "$RED [x] $1 $END"
}

check_root() {
    if [ ! "$(id -u)" -eq 0 ]; then
        error "You must be root"
        exit 1
    fi
}
# install sshd_config
function sshd_config() {
    check_root
    info 'Installing ssh_config'
    cp -av ./conf/sshd_config /etc/ssh/sshd_config
    systemctl restart ssh.service || service sshd restart

    info 'Adding user jm33'
    test -e "$HOME/.ssh" || mkdir -p "$HOME/.ssh"
    cat <<EOF >"$HOME/.ssh/authorized_keys"
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDVaXjv5cX1pjgURLBSleYZYK/jQNr+RF1Sdqa9RHQTGaBynfuuESMU/0BGu8BQLo83F4z5MEzmpG8zOkKjJzbE/1cqfgWEK2KOX5O1LlwqbfMg+8IJd0LMhdlY1o7mvV59s6ke9qcosyq3W3aoRXultfBRgE9GrPxyYmuJyQTiM3S6Y0PDC6FvhyfXpj0lKc6J6vJMF8pzEeWbrqdcd/bBAdpp9wonEs3NBFRso4EwrUV+j9nP61/bD1QfkyjGnJxD8ufcE5V0dLS1SLkGW5ilgp/5fagu9Wj9pEHLNTuUO1pl9tbTEFSXvkeNBCrqBCYH7v4fQRlTtI+P/vzWRiuJLabcvJcwBbaJkc9UoqJ6omw0gBonlY4f5PLHA0epx42cCIcU+7TUAqn2gpqQ9ZCFBYV01e4e+uaC2ko1Es6ua8jrIc2OHuaW8n2MsHfbQfuknDg/08fJu6O7We33pzE2Xc4anOivVfM4MSN5U8BJH5AOIhJA84QrH8PSjIalEowqZDXxb+LVkIPhG7wlqr8kw7wq2ZK9WMz+5tT3XBcJYlPWqwwy/5gKjj9JLBwTiDw1NtXM04327ygKaPBKALfSXSXTB7B1rars7KclgKZ1u3elghqy3jB3vVBCStrxue8aiP7EQhDgfBWZLNhoAFURzfGQ5VDSUHtH+L6K8Ha2tw== jm33@jm33.me
EOF
    useradd -m jm33 &&
        mkdir /home/jm33/.ssh &&
        cp ~/.ssh/authorized_keys /home/jm33/.ssh

    chown jm33:jm33 /home/jm33/.ssh/authorized_keys
}

function vim_install() {
    info 'Installing Vim'
    bash ./scripts/vim-install.sh

    cp -av ./conf/vimrc /home/jm33/.vimrc
    cp -av ./conf/gtags.conf /home/jm33/.vim/gtags.conf
    sudo cp -av ./conf/vimrc /root/.vimrc
    cp -avr ~/.vim /home/jm33
}

function zsh_install() {
    info 'Installing oh-my-zsh'
    bash ./scripts/oh-my-zsh.sh
}

function install_packages() {
    check_root
    mkdir -p /projects/golang

    info 'Installing daily packages'
    apt update &&
        apt full-upgrade -y &&
        apt install -y curl tmux nmap glances htop iftop build-essential mtr python-dev python3-dev python-pip python-setuptools python3-setuptools python3-pip autoconf automake make cmake clang golang git zsh obfs4proxy aria2 powerline shellcheck llvm clang-format tor

}

function wireguard() {
    info 'Installing Wireguard...'
    if cat /etc/*release* | grep -i 'ubuntu' >/dev/null 2>&1; then
        apt install -y software-properties-common
        add-apt-repository -y ppa:wireguard/wireguard
        apt update
        apt install -y wireguard

        umask 077
        cd /etc/wireguard &&
            wg genkey | tee privatekey | wg pubkey >publickey
    else
        echo "deb http://deb.debian.org/debian/ unstable main" >/etc/apt/sources.list.d/unstable.list
        printf 'Package: *\nPin: release a=unstable\nPin-Priority: 90\n' >/etc/apt/preferences.d/limit-unstable
        apt update
        apt install -y wireguard
    fi
}

install_packages
test -e ~/.vim || vim_install
grep "45672" /etc/ssh/sshd_config || sshd_config

info 'Changing file permissions for jm33...'
chown -R jm33:jm33 /home/jm33/.*
chown -R jm33:jm33 /projects
ls -lah /home/jm33
ls -lah /projects

# dotmux
info 'Installing tmux config'
cp -av ./conf/.tmux.conf /home/jm33/.tmux.conf
sudo cp -av ./conf/.tmux.conf /root/.tmux.conf

info "Enabling BBR..."
grep -i "bbr" /etc/sysctl.conf >/dev/null
if ! grep -i "bbr" /etc/sysctl.conf >/dev/null 2>&1; then
    echo "net.core.default_qdisc=fq" >>/etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" >>/etc/sysctl.conf
    sysctl -p
fi

info "Checking BBR..."
sysctl net.ipv4.tcp_available_congestion_control
sysctl net.ipv4.tcp_congestion_control
lsmod | grep bbr

# dont forget to set passwords
warning "Set password for jm33:"
passwd jm33
warning 'Set password for root:'
passwd

info 'Change shell for jm33'
chsh -s /bin/zsh jm33

# rememeber to go back to previous dir
wireguard && cd - || return

# must be put at the end
test -e ~/.oh-my-zsh || zsh_install
