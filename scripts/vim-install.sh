#!/bin/bash

vimplug_uri="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

curl -fLo ~/.vim/autoload/plug.vim --create-dirs $vimplug_uri

echo "vim-plug has been installed, please :PlugInstall to install other plugins"
