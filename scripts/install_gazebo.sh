#!/bin/bash
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/utils.sh"
ROS1DISTRO_ARRY=("noetic")
ROS2DISTRO_ARRY=("galactic" "foxy" "humble")

# one-liner installation
# ref: https://classic.gazebosim.org/tutorials?tut=install_ubuntu
curl -sSL http://get.gazebosim.org | sh

# Install gazebo_ros_pkgs
# ref: http://classic.gazebosim.org/tutorials?tut=ros2_installing&cat=connect_ros
if [[ " ${ROS1DISTRO_ARRY[@]} " =~ " ${ROS_DISTRO} " ]]; then
  sudo apt install "ros-${ROS_DISTRO}-gazebo-ros-pkgs"
elif [[ " ${ROS2DISTRO_ARRY[@]} " =~ " ${ROS_DISTRO} " ]]; then
  sudo apt install "ros-${ROS_DISTRO}-gazebo-ros-pkgs"
else
  echo "ROS1 distro: $ROS_DISTRO currently is not supported"
  exit 1
fi
