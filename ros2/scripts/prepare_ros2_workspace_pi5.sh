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
ros2_colcon_rm_ignore $WORKSPACE
"$script_dir/install_ros2_from_source.sh" -u $UBUNTU_CODENAME -r $ROS_DISTRO -w $WORKSPACE
ros2_colcon_ignore $WORKSPACE

echo
echo ====================================================================
echo Install ROS2 related packages from source
echo ====================================================================
sudo apt-get install -y xtensor-dev libompl-dev # for mppi_controller

install_script=$(readlink -f "$script_dir/../../scripts/install_from_source.sh")
$install_script -w $WORKSPACE -v "$script_dir/pi5_$ROS_DISTRO.repos" -i \
    "image_geometry,opencv_tests,gazebo_dev,gazebo_msgs,gazebo_plugins,gazebo_ros,gazebo_ros_control"

# only need cv_bridge
# touch $HOME/$WORKSPACE/src/vision_opencv/{image_geometry,opencv_tests}/COLCON_IGNORE

# only need gazebo_ros_pkgs
# touch $HOME/$WORKSPACE/src/gazebo_ros_pkgs/{gazebo_dev,gazebo_msgs,gazebo_plugins,gazebo_ros,gazebo_ros_control}/COLCON_IGNORE

# export UBUNTU_CODENAME=$UBUNTU_CODENAME
# export ROS_DISTRO=$ROS_DISTRO
# export WORKSPACE=$WORKSPACE
# export ROS_INSTALL_TYPE=$ROS_INSTALL_TYPE
