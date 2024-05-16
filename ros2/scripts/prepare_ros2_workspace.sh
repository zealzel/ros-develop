#!/bin/bash
script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$script_dir/../../scripts/utils.sh"
source "$script_dir/../../scripts/argparse_ros.sh"
parse_args "$@"

"$script_dir/../../scripts/create_workspace.sh" $WORKSPACE || exit_code=$?
if [[ $exit_code -ne 0 ]]; then
  exit
fi

echo
echo ====================================================================
echo Install ROS2
echo ====================================================================
"$script_dir/install_ros2.sh" -u $UBUNTU_CODENAME -r $ROS_DISTRO
"$script_dir/install_ros2_packages.sh" -u $UBUNTU_CODENAME -r $ROS_DISTRO

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
export ROS_DISTRO=$ROS_DISTRO
export WORKSPACE=$WORKSPACE
export ROS_INSTALL_TYPE=$ROS_INSTALL_TYPE
