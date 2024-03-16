#!/bin/bash

function install_rplidar {
  sudo apt install -y ros-"$ROS_DISTRO"-rplidar-ros
  cd /tmp
  wget https://raw.githubusercontent.com/allenh1/rplidar_ros/ros2/scripts/rplidar.rules
  sudo cp rplidar.rules /etc/udev/rules.d/
}

function install_librealsense2 {
  cd /tmp
  # install librealsense2
  wget https://github.com/IntelRealSense/librealsense/raw/master/scripts/libuvc_installation.sh
  chmod +x ./libuvc_installation.sh
  ./libuvc_installation.sh
  # setup udev rules
  wget https://raw.githubusercontent.com/IntelRealSense/librealsense/master/config/99-realsense-libusb.rules
  sudo cp 99-realsense-libusb.rules /etc/udev/rules.d
  sudo udevadm control --reload-rules && sudo udevadm trigger
}
