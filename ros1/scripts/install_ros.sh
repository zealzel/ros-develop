#!/usr/bin/bash
source utils.sh

echo =======================
echo install ros stack
echo =======================

ros_package="ros-noetic-ros-base"
if is_ubuntu_package_installed "$ros_package"; then
  echo "ROS Noetic is already installed"
  exit 0
fi

echo "Set up ROS Noetic repo for Ubuntu 20.04"
echo "deb http://packages.ros.org/ros/ubuntu focal main" | sudo tee /etc/apt/sources.list.d/ros-focal.list

echo "Add official ROS keyring"
# sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | sudo apt-key add -

echo "sudo apt-get update"
sudo apt-get update

# sudo dpkg --configure -a

export DEBIAN_FRONTEND=noninteractive
ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime
dpkg-reconfigure -f noninteractive tzdata


echo "Install ROS Noetic package"
# options: ros-noetic-desktop-full | ros-noetic-desktop | ros-noetic-ros-base | ros-noetic-ros-core
sudo apt-get install -y "$ros_package"
