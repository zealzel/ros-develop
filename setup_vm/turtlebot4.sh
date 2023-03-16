#!/bin/bash

ORIGINAL_IMAGE="ubuntu-20.04.4-desktop-amd64.iso"
IMAGE_DOWNLOAD_SITE=

echo "The original image: $ORIGINAL_IMAGE"
echo "The original image donwload site: $IMAGE_DOWNLOAD_SITE"

echo
echo ====================================================================
echo Install ROS2
echo ====================================================================
./install_ros2_Galactic.sh

echo
echo ====================================================================
echo Install turtlebot4
echo ====================================================================
./install_tb4.sh

echo
echo ====================================================================
echo Append bashrc file
echo ====================================================================
append_bashrc 'source /opt/ros/galactic/setup.bash'

append_bashrc 'export LIBGL_ALWAYS_SOFTWARE=1'
append_bashrc 'export OGRE_RTT_MODE=Copy'

append_bashrc 'ROS_DOMAIN_ID=0'
append_bashrc 'RMW_IMPLEMENTATION=rmw_cyclonedds_cpp'
append_bashrc 'CYCLONEDDS_URI=/etc/turtlebot4/cyclonedds_pc.xml'
