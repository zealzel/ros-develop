#!/bin/bash
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../scripts/utils.sh"

ROS_DISTRO="${ROS_DISTRO-galactic}"

echo
echo ====================================================================
echo Append bashrc file
echo ====================================================================
append_bashrc "source /opt/ros/${ROS_DISTRO}/setup.bash"

append_bashrc "export LIBGL_ALWAYS_SOFTWARE=1"
append_bashrc "export OGRE_RTT_MODE=Copy"

append_bashrc "ROS_DOMAIN_ID=0"
append_bashrc "RMW_IMPLEMENTATION=rmw_cyclonedds_cpp"
append_bashrc "CYCLONEDDS_URI=/etc/turtlebot4/cyclonedds_pc.xml"
