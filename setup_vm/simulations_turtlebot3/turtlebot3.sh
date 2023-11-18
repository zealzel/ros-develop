#!/bin/bash
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../../scripts/utils.sh"

ROS_DISTRO="${ROS_DISTRO-galactic}"
CURRENT_SCRIPT_PATH="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
WORKSPACE="${1:-colcon_ws}"

echo
echo ====================================================================
echo Install turtlebot3 ros2 packages
echo ====================================================================
ros_packages=(
  "turtlebot3"
  "turtlebot3-msgs"
  "turtlebot3-simulations"
  "turtlebot3-navigation2"
)
TARGET_SCRIPT_ABSOLUTE_PATH="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/../../scripts/install_ros_packages.sh")"
"${TARGET_SCRIPT_ABSOLUTE_PATH}" "$ROS_DISTRO" "${ros_packages[@]}"
