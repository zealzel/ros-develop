#!/bin/bash
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../scripts/utils.sh"

WORKSPACE="${1:-colcon_ws}"
ROS_DISTRO="${ROS_DISTRO-galactic}"
CURRENT_SCRIPT_PATH="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
ADD_BASHRC=${2-"false"}
APT_PACKAGE_FILE=$3

echo
echo ====================================================================
echo Basic check
echo ====================================================================
ros_package_file="$CURRENT_SCRIPT_PATH/$APT_PACKAGE_FILE"

if [ -d ~/"$WORKSPACE" ]; then
  if [ -f "$ros_package_file" ]; then
    echo "ros_package_file: $ros_package_file exists"
  else
    echo "ERROR: $ros_package_file does not exist"
    exit 1
  fi
  source "$ros_package_file"
else
  echo "ERROR: $WORKSPACE does not exist"
  exit 1
fi

# for ros_package in "${ros_packages[@]}"; do
#   apt_packages+=("ros-$ROS_DISTRO-$ros_package")
#   echo $ros_package
# done
# for apt_package in "${apt_packages[@]}"; do
#   echo $apt_package
# done

echo
echo ====================================================================
echo Install ROS packages for ROS_DISTRO "$ROS_DISTRO"
echo ====================================================================
TARGET_SCRIPT_ABSOLUTE_PATH="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/../scripts/install_ros_packages.sh")"
echo "TARGET_SCRIPT_ABSOLUTE_PATH: $TARGET_SCRIPT_ABSOLUTE_PATH"
"${TARGET_SCRIPT_ABSOLUTE_PATH}" "$ROS_DISTRO" "${ros_packages[@]}"


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
