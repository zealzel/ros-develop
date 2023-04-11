#!/bin/bash
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../scripts/utils.sh"

WORKSPACE="${1:-simulations}"
ROS_DISTRO="${ROS_DISTRO-galactic}"

echo "==============================================="
echo "Install robots from package manager"
echo "==============================================="
# ./simulations_turtlebot3/turtlebot3.sh

echo
echo "===================================================================="
echo "Ensure rosdep is initialized"
echo "===================================================================="
rosdep update || exit_code=$?
if [ $exit_code -ne 0 ]; then
  sudo rosdep init
  rosdep update --include-eol-distros
fi

echo "==============================================="
echo "Build/Install robots from source"
echo "==============================================="
./install_from_source.sh $WORKSPACE "false" "simulations_articubot_one/articubot.repos"
./install_from_source.sh $WORKSPACE "false" "simulations_neobotix/neobotix.repos"

# exceptions not using install_from_source.sh
./simulations_tiago/tiago.sh $WORKSPACE

echo "==============================================="
echo "append bashrc for ROS2"
echo "==============================================="
./ros2_append_bashrc.sh

rm -f $WORKSPACE/*.repos
rm -f $WORKSPACE/*.rosinstall
