#!/bin/bash
if [ $EUID != 0 ];
then
    echo "You are not root !"
    exit 1
fi
pacman -Syyu
wait
pacman -S nvidia bumblebee bbswitch mesa mesa-demos primus
wait
printf "\n\nSuccessfully installed required packages\n\nNow I'll enable bumblebee service and preparing for first use...\n\n"
systemctl enable bumblebeed.service
systemctl status bumblebeed.service | grep -A4 "Active"
printf "\n\n"
gpasswd -a $USER bumblebee
read -r -p "Do you want me to reboot for you? [y/n]" response
if [[ $response =~ [yY](es)* ]];
then
    echo "See you soon ..."
    reboot
else
    echo "Bye"
    exit 0
fi
