#!/bin/bash
if [ $EUID != 0 ];
then
    echo "You are not root !"
    exit 1
fi
#pacman -Syyu
wait
printf "\n\nPreparing to install software from official repo..."
#pacman -S iw wpa_supplicant git zsh wipe vim alsa xorg-server xf86-input-evdev xf86-input-synaptics xf86-video-intel android-tools android-udev htop linux-headers dkms i3 xfce4-terminal dmenu sddm networkmanager intel-ucode leafpad mtr nmapnet-tools pcmanfm feh wayland openssh  plasma chromium firefox hexchat libreoffice gimp keepnote virtualbox virtualbox-host-modules virtualbox-ext-oracle virtualbox-guest-iso virtualbox-host-dkms qt4 wget axel whois
wait
printf "\n\nEnabling services...\n\n"
systemctl enable sddm.service dkms.service NetworkManager.service && systemctl status dkms.service NetworkManager.service | grep -B4 "Active"
printf "\n\n"
wait
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
wait
printf "\n\nPlease reboot and install nvidia drivers\n\n"
exit 0
