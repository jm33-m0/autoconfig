#!/bin/bash
pacman -Syyu
wait
echo "Preparing to install software from official repo..."
pacman -S iw wpa_supplicant git zsh wipe vim alsa xorg-server xf86-input-evdev xf86-input-synaptics xf86-video-intel android-tools android-udev htop linux-headers dkms i3 xfce4-terminal dmenu sddm networkmanager intel-ucode leafpad mtr nmapnet-tools pcmanfm feh wayland openssh  plasma chromium firefox hexchat libreoffice gimp keepnote virtualbox virtualbox-host-modules virtualbox-ext-oracle virtualbox-guest-iso virtualbox-host-dkms qt4 wget axel whois
wait
echo "Enabling services..."
systemctl enable sddm.service dkms.service NetworkManager.service
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo "Please reboot and install nvidia drivers"
exit 0
