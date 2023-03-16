#!/usr/bin/bash
source utils.sh

echo =======================
echo set locale
echo =======================
echo "before"
locale # check for UTF-8
sudo apt install locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

echo "after"
locale # verify settings

append_bashrc "export LC_ALL=en_US.UTF-8"
