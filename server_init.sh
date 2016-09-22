#!/bin/bash

apt-get update && apt-get dist-upgrade -y
wait;
apt-get install git zsh build-essential -y
wait;
useradd -m jm33;
wait;
if ! test -e /home/jm33/.ssh; then
	mkdir /home/jm33/.ssh
fi
cp ~/.ssh/authorized_keys /home/jm33/.ssh/ && chown -R jm33:jm33 /home/jm33/.ssh/ && chmod 700 /home/jm33/.ssh/authorized_keys
wait
curl -k https://raw.githubusercontent.com/jm33-m0/autoconfig/master/sshd_config -o /etc/ssh/sshd_config
systemctl restart sshd.service

echo '
**************************************************'
echo 'Now installing config files for Vim...'
echo '**************************************************
'
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
curl -k https://raw.githubusercontent.com/jm33-m0/autoconfig/master/vimrc -o ./vimrc
echo '[*] INFO: Make sure you are running this script as the user you want to install these config files for
'
sleep 1

if [ $(id -u) -eq 0 ]; then
    echo 'Installing for root...' && echo ''
else
    echo 'Installing for '$USER && echo ''
fi

cp ./vimrc ~/.vimrc

cat ~/.vimrc | grep 'jm33' > /dev/null
if [ $? -eq 0 ]; then
    echo '[+] SUCCESS: Done!' && echo ''
else
    echo '[-] ERROR: Failed to install
    '
fi

echo '[*] Now lets install hacker toolchain
'
hkurl='https://github.com/shell-collection/pwnr-toolchain.git'
apt-get install tor hydra nmap -y
git clone $hkurl

echo '
[+] Done
'
zshurl='https://raw.githubusercontent.com/jm33-m0/autoconfig/master/install.sh'
curl -k $zshurl | bash
