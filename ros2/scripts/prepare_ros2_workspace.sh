#!/bin/bash
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../../scripts/utils.sh"
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../../scripts/argparse_ros.sh"
parse_args "$@"
# echo "UBUNTU_CODENAME=$UBUNTU_CODENAME"
# echo "ROSDISTRO=$ROSDISTRO"
# echo "WORKSPACE=$WORKSPACE"

../../scripts/create_workspace.sh $WORKSPACE || exit_code=$?
if [[ $exit_code -ne 0 ]]; then
  exit
fi

echo
echo ====================================================================
echo Install ROS2
echo ====================================================================
"$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/install_ros2.sh")" -u $UBUNTU_CODENAME -r $ROSDISTRO
"$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/install_ros2_packages.sh")" -u $UBUNTU_CODENAME -r $ROSDISTRO
# ./install_ros2.sh -u $UBUNTU_CODENAME -r $ROSDISTRO
# ./install_ros2_packages.sh -r $ROSDISTRO

echo
echo ====================================================================
echo Ensure rosdep is initialized
echo ====================================================================
rosdep update || exit_code=$?
if [[ $exit_code -ne 0 ]]; then
  sudo rosdep init
  rosdep update --include-eol-distros
fi

export UBUNTU_CODENAME=$UBUNTU_CODENAME
export ROSDISTRO=$ROSDISTRO
export WORKSPACE=$WORKSPACE
export ROS_INSTALL_TYPE=$ROS_INSTALL_TYPE
