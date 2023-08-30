#!/bin/bash
UBUNTU_CODENAME="jammy"
ROSDISTRO="humble"
WORKSPACE="zbotartic_ws"
echo "UBUNTU_CODENAME=$UBUNTU_CODENAME"
echo "ROSDISTRO=$ROSDISTRO"
echo "WORKSPACE=$WORKSPACE"
../../ros2/scripts/prepare_ros2_workspace.sh -u $UBUNTU_CODENAME -r $ROSDISTRO -w $WORKSPACE

ORIGINAL_IMAGE="[1ebe853ca69ce507a69f97bb70f13bc1ffcfa7a2]ubuntu-22.04.2-preinstalled-server-arm64+raspi.img.xz"
IMAGE_DOWNLOAD_SITE=
echo "The original image: $ORIGINAL_IMAGE"
echo "The original image donwload site: $IMAGE_DOWNLOAD_SITE"

echo
echo ====================================================================
echo Create udev rules
echo ====================================================================
./create_udev.sh

echo ===============================================
echo Install robots from package manager
echo ===============================================
../../scripts/install_from_apt.sh $WORKSPACE "humble" "ros_packages.sh" "false"

echo
echo ===============================================
echo Build/Install robots packages from source
echo ===============================================
source "/opt/ros/${ROSDISTRO}/setup.bash" && ../../scripts/install_from_source.sh $WORKSPACE $ROSDISTRO "zbot1.5_articubot_humble.repos" "false"
