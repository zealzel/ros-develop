#!/usr/bin/bash
source utils.sh
echo ================================
echo install additional ros stack
echo ================================

basics=(
  "ros-noetic-catkin"
  "ros-noetic-urdf"
  # "ros-noetic-xacro"
  # "ros-noetic-robot-state-publisher"
  # "ros-noetic-joint-state-publisher"
  # "ros-noetic-map-server"
  # "ros-noetic-move-base"
  # "ros-noetic-amcl"
)
# "ros-noetic-tf"  <--- already installed by ros-noetic-robot-state-publisher
install_ubuntu_packages "${basics[@]}"

image=(
  "ros-noetic-diagnostic-updater"
  "ros-noetic-compressed-image-transport"
  "ros-noetic-camera-info-manager"
)
install_ubuntu_packages "${image[@]}"

apt_packages=(
  "libeigen3-dev" # required by ROS packages such as tf2_eigen, tf2_kdl, ...
)
install_ubuntu_packages "${apt_packages[@]}"

# libgdal-dev
#  - libgdal26

# ros-noetic-diagnostics
#  - ros-noetic-diagnostic-updater
# ros-noetic-image-transport-plugins
#  - ros-noetic-compressed-image-transport
# ros-noetic-image-common
#  - ros-noetic-camera-info-manager

rpi=(
  "libraspberrypi-dev"
  "libpigpiod-if-dev"
  # "libraspberyypi-bin"
)
install_ubuntu_packages "${rpi[@]}"

# others
# ros-noetic-gazebo-ros \
