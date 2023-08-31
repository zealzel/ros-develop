#!/bin/bash
script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$script_dir/../scripts/utils.sh"
source "$script_dir/../scripts/argparse_ros.sh"
WORKSPACE="simulations"
UBUNTU_CODENAME=$(cat /etc/os-release |grep VERSION_CODENAME|cut -d"=" -f2)
parse_args "$@"
source /opt/ros/${ROSDISTRO}/setup.bash
ROS_DISTRO="$(printenv ROS_DISTRO)"
../../ros2/scripts/prepare_ros2_workspace.sh -u $UBUNTU_CODENAME -r $ROS_DISTRO -w $WORKSPACE

echo ===============================================
echo Download gazebo classic models
echo ===============================================
./download_gazebo_models.sh

echo ===============================================
echo 1. Install robots from package manager
echo ===============================================
./install_from_apt.sh $WORKSPACE "false" "simulations_turtlebot3/ros_packages.sh"

echo ===============================================
echo 2. Build/Install robots/worlds from source
echo ===============================================
./install_from_source.sh $WORKSPACE "false" "simulations_zbot_artic/zbot_artic.repos"
./install_from_source.sh $WORKSPACE "false" "simulations_neobotix/neobotix.repos"
./install_from_source.sh $WORKSPACE "false" "world_aws_robotmaker/deps.repos"


echo ===============================================
echo 3. Build/Install robots by customed scripts
echo ===============================================
./simulations_tiago/tiago.sh $WORKSPACE

rm -f $WORKSPACE/*.repos
rm -f $WORKSPACE/*.rosinstall
