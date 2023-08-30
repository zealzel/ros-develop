#!/bin/bash
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../../scripts/utils.sh"
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../../scripts/argparse_ros.sh"
parse_args "$@"

WORKSPACE="zbot_ws"
ROSDISTRO="${ROSDISTRO-humble}"
echo "UBUNTU_CODENAME=$UBUNTU_CODENAME"
echo "ROSDISTRO=$ROSDISTRO"
echo "WORKSPACE=$WORKSPACE"

../../scripts/create_workspace.sh $WORKSPACE || exit_code=$?
if [[ $exit_code -ne 0 ]]; then
  exit
fi

ORIGINAL_IMAGE="[1ebe853ca69ce507a69f97bb70f13bc1ffcfa7a2]ubuntu-22.04.2-preinstalled-server-arm64+raspi.img.xz"
IMAGE_DOWNLOAD_SITE=
echo "The original image: $ORIGINAL_IMAGE"
echo "The original image donwload site: $IMAGE_DOWNLOAD_SITE"

echo
echo ====================================================================
echo Install ROS2
echo ====================================================================
../../ros2/scripts/install_ros2.sh -u $UBUNTU_CODENAME -r $ROSDISTRO
../../ros2/scripts/install_ros2_packages.sh -r $ROSDISTRO

echo
echo ====================================================================
echo Create udev rules
echo ====================================================================
./create_udev.sh

echo "==============================================="
echo "Install robots from package manager"
echo "==============================================="
../../scripts/install_from_apt.sh $WORKSPACE "humble" "ros_packages.sh" "false"

echo
echo "===================================================================="
echo "Ensure rosdep is initialized"
echo "===================================================================="
rosdep update || exit_code=$?
if [[ $exit_code -ne 0 ]]; then
  sudo rosdep init
  rosdep update --include-eol-distros
fi

echo
echo ===============================================
echo Build/Install robots packages from source
echo ===============================================
../../scripts/install_from_source.sh $WORKSPACE "false" "zbot1.5_articubot_humble.repos"

echo
echo ====================================================================
echo Append bashrc file
echo ====================================================================
append_bashrc 'source /opt/ros/${ROSDISTRO}/setup.bash'
