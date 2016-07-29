#!/bin/sh

if test -e i3wm-config; then
    echo ''
    echo '+ERROR: Folder already exists'
    exit 1
fi

echo '
***********************************'
echo 'Installing config files for i3wm'
echo '***********************************
'

echo '+INFO: Make sure you have i3blocks and git installed, along with other necessary packages'
echo ''

printf "+INFO: Ready to install config files..."
echo ''

echo '____________________________________________________________________________'
git clone https://github.com/jm33-m0/i3wm-config.git && cd i3wm-config
echo '____________________________________________________________________________'

echo ''
echo '+INFO: Installing...'

echo '____________________________________________________________________________'
cp ./i3blocks.conf /home/$USER/.i3blocks.conf -v
cp ./config /home/$USER/.config/i3/ -v
echo '____________________________________________________________________________'
echo ''
echo '+INFO: Requesting root privilege...'
echo '____________________________________________________________________________'
sudo cp ./i3status.conf /etc/ -v
sudo cp ./v6.sh /etc/ -v && sudo chmod 755 /etc/v6.sh
echo '____________________________________________________________________________'

echo ''
echo '+INFO: Cleaning up...'

cd .. && sudo rm ./i3wm-config -rf

echo ''
echo '+SUCCESS: Copied config files, reload your i3wm to see the effect'

echo '
**************************************************'
echo 'Now installing config files for Vim and Emacs...'
echo '**************************************************
'

echo '+INFO: Make sure you are running this script as the user you want to install these config files for
'
sleep 1

if [ $(id -u) -eq 0 ]; then
    echo 'Installing for root...' && echo ''
else
    echo 'Installing for '$USER && echo ''
fi

echo 'Setting up Emacs...
'
cp ./emacs ~/.emacs

echo 'now Vim...
'
cp ./vimrc ~/.vimrc

cat ~/.vimrc | grep 'jm33' > /dev/null && cat ~/.emacs | grep 'tango-dark' > /dev/null
if [ $? -eq 0 ]; then
    echo '+SUCCESS: Done!' && echo ''
else
    echo '+ERROR: Failed to install
    '
fi
