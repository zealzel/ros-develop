#!/bin/bash
#
cd
sudo apt install -y linux-headers-generic dkms unzip
wget https://github.com/RinCat/RTL88x2BU-Linux-Driver/archive/master.zip
unzip master.zip
cd RTL88x2BU-Linux-Driver-master
sudo make uninstall
make clean
make
sudo make install
sudo modprobe 88x2bu
