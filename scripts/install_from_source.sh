#!/bin/bash
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../scripts/utils.sh"

WORKSPACE="${1:-colcon_ws}"
ROS_DISTRO="${ROS_DISTRO-galactic}"
CURRENT_SCRIPT_PATH="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
ADD_BASHRC=${2-"false"}
VCS_REPOS=$3

echo
echo ====================================================================
echo Basic check
echo ====================================================================
# vcs_source="$CURRENT_SCRIPT_PATH/articubot.repos"
vcs_source="$VCS_REPOS"

if [ -d ~/"$WORKSPACE" ]; then
  if [ -f "$vcs_source" ]; then
    echo "vcs_source: $vcs_source exists"
  else
    echo "ERROR: $vcs_source does not exist"
    exit 1
  fi
  cp "$vcs_source" ~/"$WORKSPACE" > /dev/null 2>&1
else
  echo "ERROR: $WORKSPACE does not exist"
  exit 1
fi

echo "ROS_DISTRO: $ROS_DISTRO"
echo "WORKSPACE: $WORKSPACE"
echo "vcs_source: $vcs_source"

echo
echo ====================================================================
echo Install ROS packages for ROS_DISTRO "$ROS_DISTRO"
echo ====================================================================
TARGET_SCRIPT_ABSOLUTE_PATH="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/../ros2/scripts/install_ros2_packages.sh")"
"$TARGET_SCRIPT_ABSOLUTE_PATH" "$ROS_DISTRO"

echo
echo ====================================================================
echo Build from source
echo ====================================================================
# customed repos file
cd ~/"$WORKSPACE"
vcs import src < "$vcs_source"
rosdep install --from-paths src --ignore-src -r -y
colcon build --symlink-install

if [ "$ADD_BASHRC" = "true" ]; then
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
fi
