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
"$script_dir/install_ros2_from_source.sh" -u $UBUNTU_CODENAME -r $ROSDISTRO
# "$script_dir/install_ros2_packages_from_source.sh" -u $UBUNTU_CODENAME -r $ROSDISTRO

install_script=$(readlink -f "$script_dir/../../scripts/install_from_source.sh"))
$install_script -w $WORKSPACE -v "pi5_$ROSDISTRO.repos"

# echo
# echo ====================================================================
# echo Ensure rosdep is initialized
# echo ====================================================================
# rosdep update || exit_code=$?
# if [[ $exit_code -ne 0 ]]; then
#   sudo rosdep init
#   rosdep update --include-eol-distros
# fi

export UBUNTU_CODENAME=$UBUNTU_CODENAME
export ROSDISTRO=$ROSDISTRO
export WORKSPACE=$WORKSPACE
export ROS_INSTALL_TYPE=$ROS_INSTALL_TYPE
