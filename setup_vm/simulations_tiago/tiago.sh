#!/bin/bash

source ../../scripts/utils.sh

ORIGINAL_IMAGE="ubuntu-20.04.4-desktop-amd64.iso"
IMAGE_DOWNLOAD_SITE=
WORKSPACE="${1:-colcon_ws}"
ROS_DISTRO="${ROS_DISTRO-galactic}"

echo
echo ====================================================================
echo Build tiago from source
echo ====================================================================
# rosinstall/repos files are modified from https://github.com/pal-robotics/tiago_tutorials

if [ "$ROS_DISTRO" = "humble" ]; then
  vcs_source=tiago_public-"$ROS_DISTRO".repos
else
  vcs_source=tiago_public-"$ROS_DISTRO".rosinstall
fi

if [ -d ~/$WORKSPACE ]; then
  cp $vcs_source ~/"$WORKSPACE" > /dev/null 2>&1
  cd ~/$WORKSPACE
else
  echo "ERROR: $WORKSPACE does not exist"
  exit 1
fi
vcs import src < $vcs_source
colcon build --symlink-install

echo
echo ====================================================================
echo Append bashrc file
echo ====================================================================
append_bashrc 'source /opt/ros/${ROS_DISTRO}/setup.bash'

append_bashrc 'export LIBGL_ALWAYS_SOFTWARE=1'
append_bashrc 'export OGRE_RTT_MODE=Copy'

append_bashrc 'ROS_DOMAIN_ID=0'
append_bashrc 'RMW_IMPLEMENTATION=rmw_cyclonedds_cpp'
append_bashrc 'CYCLONEDDS_URI=/etc/turtlebot4/cyclonedds_pc.xml'
