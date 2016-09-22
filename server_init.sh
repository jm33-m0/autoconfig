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
echo "
export TERM=xterm
alias re='reboot'
alias off='poweroff'
alias c='reset -Q'
alias x='clear'
alias la='ls -la'
alias q='exit'
alias m='echo 1 > /proc/sys/vm/drop_caches'
alias ref='apt-get update'
alias up='apt-get update && apt-get dist-upgrade -y'
alias i='apt-get install'
alias cln='apt-get autoremove && apt-get autoclean'
" >> ~/.zshrc
wait

echo '
**************************************************'
echo 'Now installing config files for Vim...'
echo '**************************************************
'

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
apt-get install hydra nmap -y
git clone $hkurl

echo '
[+] Done
'
zshurl='https://raw.githubusercontent.com/jm33-m0/autoconfig/master/install.sh'
sh -c $(curl -k $zshurl);
