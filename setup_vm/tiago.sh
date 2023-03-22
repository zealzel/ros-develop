#!/bin/bash

ORIGINAL_IMAGE="ubuntu-20.04.4-desktop-amd64.iso"
IMAGE_DOWNLOAD_SITE=
ROS_DISTRO="galactic"
WORKSPACE="${1:-colcon_ws}"

echo
echo ====================================================================
echo Build tiago from source
echo ====================================================================
# source1="https://github.com/ros/ros_tutorials"
# package1_location="~/$WORKSPACE/src/ros_tutorials"
# git clone "$source1" -b "$ROS_DISTRO-devel" "$package1_location"
# cd "~/$WORKSPACE"
cd $WORKSPACE || exit
vcs import src < tiago_public-galactic.rosinstall

# find $package1_location -type f -name "COLCON_IGNORE" -exec rm {} \;
colcon build --symlink-install

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

