#!/bin/bash
# source ../../scripts/utils.sh
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/utils.sh"

ROS1DISTRO_ARRY=("melodic" "noetic")
ROS2DISTRO_ARRY=("galactic" "foxy" "humble")

if [[ " ${ROS1DISTRO_ARRY[@]} " =~ " ${ROS_DISTRO} " ]]; then
  echo "ROS1 distro: $ROS_DISTRO currently is not supported"
  exit 1
elif [[ " ${ROS2DISTRO_ARRY[@]} " =~ " ${ROS_DISTRO} " ]]; then
  ros_packages=(
    # basic
    "ros-$ROS_DISTRO-xacro"
    "ros-$ROS_DISTRO-joy-teleop"
    # tools
    "ros-$ROS_DISTRO-joint-state-publisher-gui"
    "ros-$ROS_DISTRO-twist-mux"
    # rqt
    "ros-$ROS_DISTRO-rqt-tf-tree"
    # gazebo
    "ros-$ROS_DISTRO-gazebo-plugins"
    # learning
    "ros-$ROS_DISTRO-turtlesim"
    # ros2_control stack
    "ros-$ROS_DISTRO-ros2-control"
    "ros-$ROS_DISTRO-ros2-controllers"
    "ros-$ROS_DISTRO-control-toolbox"
    "ros-$ROS_DISTRO-control-msgs"
    "ros-$ROS_DISTRO-gazebo-ros2-control"
    # slam/nav
    "ros-$ROS_DISTRO-slam-toolbox"
    "ros-$ROS_DISTRO-navigation2"
    "ros-$ROS_DISTRO-nav2-bringup"
    # robot
    # "ros-$ROS_DISTRO-turtlebot3-simulation"
  )
else
  echo "ROS distro: $ROS_DISTRO is not supported"
  exit 1
fi

install_ubuntu_packages "${ros_packages[@]}"
