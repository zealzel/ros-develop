#!/bin/bash
source ../../scripts/utils.sh

ROS_DISTRO="galactic"

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
  "ros-$ROS_DISTRO-turtlebot3-simulation"
)

install_ubuntu_packages "${ros_packages[@]}"
