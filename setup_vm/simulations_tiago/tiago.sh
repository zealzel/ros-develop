#!/bin/bash

source ../../scripts/utils.sh

ORIGINAL_IMAGE="ubuntu-20.04.4-desktop-amd64.iso"
IMAGE_DOWNLOAD_SITE=
ROS_DISTRO="galactic"
WORKSPACE="${1:-colcon_ws}"

echo
echo ====================================================================
echo Build tiago from source
echo ====================================================================
# rosinstall/repos files are modified from https://github.com/pal-robotics/tiago_tutorials

if [ -d ~/$WORKSPACE ]; then
  cp tiago_public-"$ROS_DISTRO".rosinstall ~/"$WORKSPACE" > /dev/null 2>&1
  cp tiago_public-"$ROS_DISTRO".repos ~/"$WORKSPACE" > /dev/null 2>&1
  cd ~/$WORKSPACE
else
  echo "ERROR: $WORKSPACE does not exist"
  exit 1
fi
if [ "$ROS_DISTRO" = "humble" ]; then
  vcs import src < tiago_public-"$ROS_DISTRO".repos
else
  vcs import src < tiago_public-"$ROS_DISTRO".rosinstall
fi
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
