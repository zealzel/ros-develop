#!/bin/bash
UBUNTU_CODENAME="focal"
ROSDISTRO="galactic"
WORKSPACE="zbotartic_ws"
echo "UBUNTU_CODENAME=$UBUNTU_CODENAME"
echo "ROSDISTRO=$ROSDISTRO"
echo "WORKSPACE=$WORKSPACE"
../../ros2/scripts/prepare_ros2_workspace.sh -u $UBUNTU_CODENAME -r $ROSDISTRO -w $WORKSPACE

ORIGINAL_IMAGE="[488d07354c8b92592c3c0e759b0f4730dce21dce]ubuntu-20.04.5-preinstalled-server-arm64+raspi.img.xz"
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
../../scripts/install_from_apt.sh $WORKSPACE $ROSDISTRO "ros_packages.sh" "false"

echo
echo ===============================================
echo Build/Install robots packages from source
echo ===============================================
source "/opt/ros/${ROSDISTRO}/setup.bash" && ../../scripts/install_from_source.sh $WORKSPACE $ROSDISTRO "zbot1.5_articubot_$ROSDISTRO.repos" "false"
