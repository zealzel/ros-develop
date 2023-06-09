#!/bin/bash
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../scripts/utils.sh"

WORKSPACE="${1:-simulations}"
ROS_DISTRO="${ROS_DISTRO-galactic}"

./create_workspace.sh $WORKSPACE || exit_code=$?
if [[ $exit_code -ne 0 ]]; then
  exit
fi

echo "==============================================="
echo "Install ROS2 important packages"
echo "==============================================="
TARGET_SCRIPT_ABSOLUTE_PATH="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/../ros2/scripts/install_ros2_packages.sh")"
"${TARGET_SCRIPT_ABSOLUTE_PATH}" "$ROS_DISTRO"


echo "==============================================="
echo "Download gazebo classic models"
echo "==============================================="
./download_gazebo_models.sh


echo "==============================================="
echo "Install robots from package manager"
echo "==============================================="
./install_from_apt.sh $WORKSPACE "false" "simulations_turtlebot3/ros_packages.sh"

echo
echo "===================================================================="
echo "Ensure rosdep is initialized"
echo "===================================================================="
rosdep update || exit_code=$?
if [[ $exit_code -ne 0 ]]; then
  sudo rosdep init
  rosdep update --include-eol-distros
fi


echo "==============================================="
echo "Build/Install robots/worlds from source"
echo "==============================================="
./install_from_source.sh $WORKSPACE "false" "simulations_zbot_artic/zbot_artic.repos"
./install_from_source.sh $WORKSPACE "false" "simulations_neobotix/neobotix.repos"
./install_from_source.sh $WORKSPACE "false" "world_aws_robotmaker/deps.repos"


echo "==============================================="
echo "Build/Install robots by customed scripts"
echo "==============================================="
./simulations_tiago/tiago.sh $WORKSPACE


echo "==============================================="
echo "append bashrc for ROS2"
echo "==============================================="
./ros2_append_bashrc.sh

rm -f $WORKSPACE/*.repos
rm -f $WORKSPACE/*.rosinstall
