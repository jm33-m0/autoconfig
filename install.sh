#!/bin/bash

# by: jm33-ng
# 2017-06-10

# urls of target scripts and config files
zsh_url='https://raw.githubusercontent.com/jm33-m0/autoconfig/master/oh-my-zsh.sh'
sshd_url='https://raw.githubusercontent.com/jm33-m0/autoconfig/master/sshd_config'
vimrc_url='https://raw.githubusercontent.com/jm33-m0/autoconfig/master/vimrc'
vim_files_url='https://raw.githubusercontent.com/jm33-m0/autoconfig/master/vim.tgz'

# install curl if no curl is detected
if ! test -e '/usr/bin/curl'; then
    apt-get update && apt-get install curl -y
fi

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
    cat << EOF > "$HOME/.ssh/authorized_keys"
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDVaXjv5cX1pjgURLBSleYZYK/jQNr+RF1Sdqa9RHQTGaBynfuuESMU/0BGu8BQLo83F4z5MEzmpG8zOkKjJzbE/1cqfgWEK2KOX5O1LlwqbfMg+8IJd0LMhdlY1o7mvV59s6ke9qcosyq3W3aoRXultfBRgE9GrPxyYmuJyQTiM3S6Y0PDC6FvhyfXpj0lKc6J6vJMF8pzEeWbrqdcd/bBAdpp9wonEs3NBFRso4EwrUV+j9nP61/bD1QfkyjGnJxD8ufcE5V0dLS1SLkGW5ilgp/5fagu9Wj9pEHLNTuUO1pl9tbTEFSXvkeNBCrqBCYH7v4fQRlTtI+P/vzWRiuJLabcvJcwBbaJkc9UoqJ6omw0gBonlY4f5PLHA0epx42cCIcU+7TUAqn2gpqQ9ZCFBYV01e4e+uaC2ko1Es6ua8jrIc2OHuaW8n2MsHfbQfuknDg/08fJu6O7We33pzE2Xc4anOivVfM4MSN5U8BJH5AOIhJA84QrH8PSjIalEowqZDXxb+LVkIPhG7wlqr8kw7wq2ZK9WMz+5tT3XBcJYlPWqwwy/5gKjj9JLBwTiDw1NtXM04327ygKaPBKALfSXSXTB7B1rars7KclgKZ1u3elghqy3jB3vVBCStrxue8aiP7EQhDgfBWZLNhoAFURzfGQ5VDSUHtH+L6K8Ha2tw== jm33@jm33.me
EOF
    useradd -m jm33 && \
        mkdir /home/jm33/.ssh
    cp "$HOME/.ssh/authorized_keys" /home/jm33/.ssh
}

function vim_install() {
    echo '[*] Installing vim files'
    which vim || apt-get update && \
        apt-get install vim -y

    curl -kfsSL $vimrc_url -o "$HOME/.vimrc"

    curl -kfsSL "$vim_files_url" -o "$HOME/vim.tgz" && \
        cd "$HOME" && \
        tar xvpf vim.tgz

    cp "$HOME/.vim*" -r /home/jm33 && \
        chown -R jm33:jm33 /home/jm33/.*
}

function zsh_install() {
    echo '[*] Installing oh-my-zsh'
    curl -kfsSL $zsh_url | bash
}

function install_packages() {
    check_root
    echo '[*] Installing daily packages'
    apt-get update && \
        apt-get install -y nmap glances htop iftop build-essential mtr python-dev python3-dev python-pip python-setuptools python3-setuptools python3-pip autoconf automake make cmake clang golang gocode git zsh && \
        apt-get dist-upgrade -y
}

install_packages
grep jm33 "$HOME/.vimrc" || vim_install
test -e "$HOME/.oh-my-zsh" || zsh_install
grep "45672" /etc/ssh/sshd_config || sshd_config

echo -n "[?] Proceed to enable BBR? [y/n] "
read -r answ
if [ "$answ" = "y" ]; then
    wget --no-check-certificate -qO 'BBR.sh' 'https://moeclub.org/attachment/LinuxShell/BBR.sh' && chmod a+x BBR.sh && bash BBR.sh -f
fi
