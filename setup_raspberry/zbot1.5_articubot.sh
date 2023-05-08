#!/bin/bash
source ../scripts/utils.sh

ORIGINAL_IMAGE="[488d07354c8b92592c3c0e759b0f4730dce21dce]ubuntu-20.04.5-preinstalled-server-arm64+raspi.img.xz"
IMAGE_DOWNLOAD_SITE=

echo "The original image: $ORIGINAL_IMAGE"
echo "The original image donwload site: $IMAGE_DOWNLOAD_SITE"

echo
echo ====================================================================
echo Install ROS2
echo ====================================================================
../ros2/scripts/install_ros2.sh
../ros2/scripts/install_ros2_packages.sh

echo
echo ====================================================================
echo Create udev rules
echo ====================================================================
../scripts/create_zbot1.5_udev_files.sh

echo
echo ====================================================================
echo Append bashrc file
echo ====================================================================
append_bashrc 'source /opt/ros/galactic/setup.bash'
