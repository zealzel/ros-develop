#!/bin/bash

# source ../../scripts/utils.sh
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../../scripts/utils.sh"

WORKSPACE="${1:-colcon_ws}"
ROS_DISTRO="${ROS_DISTRO-galactic}"

echo
echo ====================================================================
echo Basic check
echo ====================================================================
vcs_source=articubot.repos
if [ -d ~/$WORKSPACE ]; then
  cp $vcs_source ~/"$WORKSPACE" > /dev/null 2>&1
else
  echo "ERROR: $WORKSPACE does not exist"
  exit 1
fi

echo "ROS_DISTRO: $ROS_DISTRO"
echo "WORKSPACE: $WORKSPACE"
echo "vcs_source: $vcs_source"

echo
echo ====================================================================
echo Install ROS packages for ROS_DISTRO $ROS_DISTRO
echo ====================================================================
# ../../ros2/scripts/install_ros2_packages.sh $ROS_DISTRO
TARGET_SCRIPT_ABSOLUTE_PATH="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/../../ros2/scripts/install_ros2_packages.sh")"
"${TARGET_SCRIPT_ABSOLUTE_PATH}" "$ROS_DISTRO"

echo
echo ====================================================================
echo Build from source
echo ====================================================================
# customed repos file
cd ~/$WORKSPACE
vcs import src < $vcs_source
rosdep install --from-paths src --ignore-src -r -y
colcon build --symlink-install

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
