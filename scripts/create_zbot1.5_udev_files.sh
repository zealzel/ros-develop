#!/bin/bash

echo
echo ====================================================================
echo Update udev rules
echo ====================================================================
echo "remap the device serial port(ttyUSBX) to  rplidar"
echo "rplidar usb connection as /dev/rplidar , check it using the command : ls -l /dev|grep ttyUSB"
echo "start copy zbot1.5-arti.rules to  /etc/udev/rules.d/"
udev_lines=$(cat <<EOL
SUBSYSTEM=="i2c-dev", GROUP="i2c", MODE="0666"
SUBSYSTEM=="gpio*", GROUP="gpio", MODE="0666"
SUBSYSTEM=="usb", ATTRS{idVendor}=="03e7", MODE="0666"
SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", SYMLINK="rplidar", MODE="0666"
SUBSYSTEM=="tty", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="7523", SYMLINK+="arduino", MODE="0666"
EOL
)

udev_files="/etc/udev/rules.d/zbot1.5-arti.rules"
echo "$udev_lines" | sudo tee $udev_files

echo ====================================================================
echo Restarting udev
echo ====================================================================
sudo udevadm control --reload-rules && sudo service udev restart && sudo udevadm trigger
