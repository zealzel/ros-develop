#!/bin/bash
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../../scripts/utils.sh"

WORKSPACE="${1:-zbot_ws}"
ROS_DISTRO="${ROS_DISTRO-humble}"
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
../../ros2/scripts/install_ros2.sh -u jammy -r humble
../../ros2/scripts/install_ros2_packages.sh

echo
echo ====================================================================
echo Create udev rules
echo ====================================================================
./create_udev.sh

echo "==============================================="
echo "Install robots from package manager"
echo "==============================================="
# install_from_apt="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/../../scripts/install_from_apt.sh")"
# "${install_from_apt}" $WORKSPACE "false" "zbot1.5_articubot/ros_packages.sh"
../../scripts/install_from_apt.sh $WORKSPACE "false" "ros_packages.sh"

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
# install_from_source="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/../../scripts/install_from_source.sh")"
# "${install_from_source}" $WORKSPACE "false" "zbot1.5_articubot/zbot1.5_articubot.repos"
../../scripts/install_from_source.sh $WORKSPACE "false" "zbot1.5_articubot.repos"

echo
echo ====================================================================
echo Append bashrc file
echo ====================================================================
append_bashrc 'source /opt/ros/${ROS_DISTRO}/setup.bash'
