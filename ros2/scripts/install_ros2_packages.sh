#!/bin/bash
source utils.sh

ROS_DISTRO="galactic"

ros_packages=(
  "ros-$ROS_DISTRO-turtlesim"

  # ros2_control stack
  "ros-$ROS_DISTRO-ros2-control"
  "ros-$ROS_DISTRO-ros2-controllers"
  "ros-$ROS_DISTRO-control-toolbox"
  "ros-$ROS_DISTRO-control-msgs"
  "ros-$ROS_DISTRO-gazebo-ros2-control"
)

install_ubuntu_packages "${catkin_packages[@]}"
