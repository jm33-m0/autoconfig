#!/bin/bash
if [ $EUID != 0 ];
then
    echo "You are not root !"
    exit 1
fi
pacman -Syyu
wait
printf "\n\nPreparing to install software from official repo...\n\n"
pacman -S iw wpa_supplicant git zsh wipe vim xorg-server xf86-input-evdev xf86-input-synaptics xf86-video-intel android-tools android-udev htop linux-headers dkms i3 xfce4-terminal dmenu sddm networkmanager intel-ucode leafpad mtr nmap net-tools pcmanfm feh wayland openssh gdm gnome chromium firefox hexchat libreoffice gimp keepnote virtualbox virtualbox-host-modules virtualbox-ext-oracle virtualbox-guest-iso virtualbox-host-dkms qt4 wget axel whois
wait
pacman -Rdd empathy evolution-data-server
wait
printf "\n\nRemoved floatware"
printf "\n\nEnabling services...\n\n"
systemctl enable sddm.service dkms.service NetworkManager.service && systemctl status dkms.service NetworkManager.service | grep -B4 "Active"
printf "\n\n"
pacman -Rdd empathy evolution-data-server
wait
printf "\n\nRemoved floatware"
printf "\n\nEnabling services...\n\n"
systemctl enable sddm.service dkms.service NetworkManager.service && systemctl status dkms.service NetworkManager.service | grep -B4 "Active"
printf "\n\n"
dkms autoinstall
wait
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
wait
printf "\n\nplease reboot and install nvidia drivers\n\n"
exit 0
