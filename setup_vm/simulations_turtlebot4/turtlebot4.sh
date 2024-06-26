#!/bin/bash
# source ../../scripts/utils.sh
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../../scripts/utils.sh"

WORKSPACE="${1:-colcon_ws}"

if [ "$ROS_DISTRO" = "" ]; then
  echo "ERROR: ROS_DISTRO is not set"
  exit 1
fi

echo
echo ====================================================================
echo Basic check
echo ====================================================================
vcs_source=tb4-"$ROS_DISTRO".repos

if [ -d ~/"$WORKSPACE" ]; then
  cp "$vcs_source" ~/"$WORKSPACE" > /dev/null 2>&1
else
  echo "ERROR: $WORKSPACE does not exist"
  exit 1
fi

echo
echo ====================================================================
echo Install ignition gazebo
echo ====================================================================
sudo apt-get install wget
sudo sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
sudo apt-get update && sudo apt-get install ignition-edifice -y

echo
echo ====================================================================
echo Install turtlebot4 ros2 packages
echo ====================================================================
ros_packages=(
  "turtlebot4-desktop"
  "turtlebot4-base"
  "turtlebot4-bringup"
  "turtlebot4-description"
  "turtlebot4-diagnostics"
  "turtlebot4-msgs"
  "turtlebot4-navigation"
  "turtlebot4-node"
  "turtlebot4-robot"
  "turtlebot4-tests"
  "turtlebot4-simulator"
  "irobot-create-nodes"
)
../../scripts/install_ros_packages.sh "$ROS_DISTRO" "${ros_packages[@]}"

echo
echo ====================================================================
echo Install ROS packages for ROS_DISTRO $ROS_DISTRO
echo ====================================================================
# ../../ros2/scripts/install_ros2_packages.sh $ROS_DISTRO
TARGET_SCRIPT_ABSOLUTE_PATH="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/../../ros2/scripts/install_ros2_packages.sh")"
"${TARGET_SCRIPT_ABSOLUTE_PATH}" "$ROS_DISTRO"

# echo
# echo ====================================================================
# echo Build turtlebot4 from source
# echo ====================================================================
# # rosinstall/repos files are modified from https://github.com/pal-robotics/tiago_tutorials
# cd ~/"$WORKSPACE"
# vcs import src < "$vcs_source"
# rosdep install --from-paths src --ignore-src -r -y
# colcon build --symlink-install

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
