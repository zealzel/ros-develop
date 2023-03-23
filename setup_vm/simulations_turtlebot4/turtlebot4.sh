#!/bin/bash
# source ../../scripts/utils.sh
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../../scripts/utils.sh"

ROSDISTRO="galactic"
WORKSPACE="colcon_ws"

echo
echo ====================================================================
echo Install turtlebot4 ros2 packages
echo ====================================================================
ros_packages=(
  "turtlebot4-desktop"
  "turtlebot4-base"
  "turtlebot4-bringup"
  "turtlebot4-description"
  "turtlebot4-diagnostics"
  "turtlebot4-msgs"
  "turtlebot4-navigation"
  "turtlebot4-node"
  "turtlebot4-robot"
  "turtlebot4-tests"
  "turtlebot4-simulator"
  "irobot-create-nodes"
  "turtlesim"
)
../../scripts/install_ros_packages.sh "$ROSDISTRO" "${ros_packages[@]}"

# echo
# echo ====================================================================
# echo Build additional ROS packages from source
# echo ====================================================================
# source1="https://github.com/ros/ros_tutorials"
# package1_location="~/$WORKSPACE/src/ros_tutorials"
# git clone "$source1" -b "$ROSDISTRO-devel" "$package1_location"
# cd "~/$WORKSPACE"
# # find $package1_location -type f -name "COLCON_IGNORE" -exec rm {} \;
# colcon build --symlink-install

# echo
# echo ====================================================================
# echo Append bashrc file
# echo ====================================================================
# append_bashrc 'source /opt/ros/galactic/setup.bash'

# append_bashrc 'export LIBGL_ALWAYS_SOFTWARE=1'
# append_bashrc 'export OGRE_RTT_MODE=Copy'

# append_bashrc 'ROS_DOMAIN_ID=0'
# append_bashrc 'RMW_IMPLEMENTATION=rmw_cyclonedds_cpp'
# append_bashrc 'CYCLONEDDS_URI=/etc/turtlebot4/cyclonedds_pc.xml'
