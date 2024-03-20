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
echo Install ROS2 from source
echo ====================================================================
"$script_dir/install_ros2_from_source.sh" -u $UBUNTU_CODENAME -r $ROSDISTRO
# "$script_dir/install_ros2_packages_from_source.sh" -u $UBUNTU_CODENAME -r $ROSDISTRO

install_script=$(readlink -f "$script_dir/../../scripts/install_from_source.sh")
# $install_script -w $WORKSPACE -v "$script_dir/pi5_$ROSDISTRO.repos"
$install_script -w $WORKSPACE -v "$script_dir/pi5_$ROSDISTRO.repos" -i \
    "image_geometry,opencv_tests,gazebo_dev,gazebo_msgs,gazebo_plugins,gazebo_ros,gazebo_ros_control"

# only need cv_bridge
touch $HOME/$WORKSPACE/src/vision_opencv/{image_geometry,opencv_tests}/COLCON_IGNORE

# only need gazebo_ros_pkgs
touch $HOME/$WORKSPACE/src/gazebo_ros_pkgs/{gazebo_dev,gazebo_msgs,gazebo_plugins,gazebo_ros,gazebo_ros_control}/COLCON_IGNORE

# export UBUNTU_CODENAME=$UBUNTU_CODENAME
# export ROSDISTRO=$ROSDISTRO
# export WORKSPACE=$WORKSPACE
# export ROS_INSTALL_TYPE=$ROS_INSTALL_TYPE
