#!/bin/bash
source utils.sh

ROS_DISTRO="galactic"

ros_packages=(
  "ros-$ROS_DISTRO-turtlesim"
)

install_ubuntu_packages "${catkin_packages[@]}"
