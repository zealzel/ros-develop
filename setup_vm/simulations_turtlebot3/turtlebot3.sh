#!/bin/bash
# source ../../scripts/utils.sh
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../../scripts/utils.sh"


ROS_DISTRO="${ROS_DISTRO-galactic}"
CURRENT_SCRIPT_PATH="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
WORKSPACE="${1:-colcon_ws}"

# if [ "$ROS_DISTRO" = "" ]; then
#   echo "ERROR: ROSDISTRO is not set"
#   exit 1
# fi

# echo
# echo ====================================================================
# echo Basic check
# echo ====================================================================
# vcs_source=tb3-"$ROS_DISTRO".repos

# if [ -d ~/"$WORKSPACE" ]; then
#   cp "$vcs_source" ~/"$WORKSPACE" > /dev/null 2>&1
# else
#   echo "ERROR: $WORKSPACE does not exist"
#   exit 1
# fi

# echo
# echo ====================================================================
# echo Install ignition gazebo
# echo ====================================================================
# sudo apt-get install wget
# sudo sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
# wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
# sudo apt-get update && sudo apt-get install ignition-edifice -y

echo
echo ====================================================================
echo Install turtlebot3 ros2 packages
echo ====================================================================
ros_packages=(
  "turtlebot3"
  "turtlebot3-msgs"
  "turtlebot3-simulations"
)
TARGET_SCRIPT_ABSOLUTE_PATH="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/../../scripts/install_ros_packages.sh")"
"${TARGET_SCRIPT_ABSOLUTE_PATH}" "$ROS_DISTRO" "${ros_packages[@]}"

# ../../scripts/install_ros_packages.sh "$ROS_DISTRO" "${ros_packages[@]}"

# echo
# echo ====================================================================
# echo Install ROS packages for ROS_DISTRO $ROS_DISTRO
# echo ====================================================================
# TARGET_SCRIPT_ABSOLUTE_PATH="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/../../ros2/scripts/install_ros2_packages.sh")"
# "${TARGET_SCRIPT_ABSOLUTE_PATH}" "$ROS_DISTRO"

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
