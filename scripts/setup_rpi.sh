#!/bin/bash

if [[ $(dpkg -L sudo) ]]; then
  echo "sudo is installed"
else
  echo "sudo is not installed"
  apt-get update; apt-get install -y sudo
fi
sudo apt-get update && sudo apt-get install -y curl gnupg

cd ~ && ./setup_locale.sh && ./install_ros2_Galactic.sh

sudo apt-get install -y \
  ros-galactic-xacro \
  ros-galactic-control-msgs \
  ros-galactic-gazebo-ros \
  ros-galactic-joint-state-publisher \
  ros-galactic-ros-ign-interfaces \
  ros-galactic-nav2-simple-commander \
  ros-galactic-nav2-bringup \
  ros-galactic-gazebo-ros2-control \
  ros-galactic-ros-ign-bridge \
  ros-galactic-ros-ign-gazebo \
  ros-galactic-gazebo-plugins

sudo apt-get install -y \
  libgpiod-dev \
  ros-galactic-depthai-ros-msgs \
  ros-galactic-depthai-bridge \
  ros-galactic-depthai-examples \
  ros-galactic-rplidar-ros \
  ros-galactic-joy-linux
