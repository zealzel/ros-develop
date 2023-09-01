#!/bin/bash
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../../scripts/utils.sh"
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../../scripts/argparse_ros.sh"
parse_args "$@"

echo "ROSDISTRO=$ROSDISTRO"

ros_packages=(
  # basic
  "ros-$ROSDISTRO-xacro"
  "ros-$ROSDISTRO-joy-teleop"
  # tools
  "ros-$ROSDISTRO-joint-state-publisher-gui"
  "ros-$ROSDISTRO-twist-mux"
  # rqt
  "ros-$ROSDISTRO-rqt-tf-tree"
  # gazebo
  "ros-$ROSDISTRO-gazebo-plugins"
  # learning
  "ros-$ROSDISTRO-turtlesim"
  # ros2_control stack
  "ros-$ROSDISTRO-ros2-control"
  "ros-$ROSDISTRO-ros2-controllers"
  "ros-$ROSDISTRO-control-toolbox"
  "ros-$ROSDISTRO-control-msgs"
  "ros-$ROSDISTRO-gazebo-ros2-control"
  # slam/nav
  "ros-$ROSDISTRO-slam-toolbox"
  "ros-$ROSDISTRO-navigation2"
  "ros-$ROSDISTRO-nav2-bringup"
  # dds
  "ros-$ROSDISTRO-rmw-cyclonedds-cpp"
  # robot
  # "ros-$ROS_DISTRO-turtlebot3-simulation"
)

install_ubuntu_packages "${ros_packages[@]}"
