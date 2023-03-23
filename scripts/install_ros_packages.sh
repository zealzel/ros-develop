#!/bin/bash
source ../scripts/utils.sh

ROS_DISTRO="${1-galactic}"
ROS_PACKAGES=$2

# ex:
# ros_packages=(
#   "xacro"
#   "joy-teleop"
#   "turtlebot3-simulation"
# )
#  ->
# apt_packages=(
#  "ros-$ROS_DISTRO-xacro"
#  "ros-$ROS_DISTRO-joy-teleop"
#  "ros-$ROS_DISTRO-turtlebot3-simulation"
# )

apt_packages=()
for ros_package in "${ros_packages[@]}"; do
  apt_packages+=("ros-$ROS_DISTRO-$ros_package")
done
install_ubuntu_packages "${apt_packages[@]}"
