#!/bin/bash
#
# source utils.sh
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/utils.sh"

# ROS_DISTRO="${1-galactic}"
# ROS_PACKAGES=$2
ROS_DISTRO="${1-galactic}"
shift
ROS_PACKAGES=("${@}")

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
for ros_package in "${ROS_PACKAGES[@]}"; do
  apt_packages+=("ros-$ROS_DISTRO-$ros_package")
done
install_ubuntu_packages "${apt_packages[@]}"
