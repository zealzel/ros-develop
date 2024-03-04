#!/usr/bin/env bash

# for audio playing
sudo apt install -y alsa-utils

cd
git clone https://github.com/waveshare/WM8960-Audio-HAT

# Install WM8960 driver:
cd WM8960-Audio-HAT
sudo ./install.sh
# sudo reboot

# Check if the driver is installed.
# sudo dkms status

# pi@raspberrypi:~ $ sudo dkms status
# wm8960-soundcard, 1.0, 4.19.58-v7l+, armv7l: installed
