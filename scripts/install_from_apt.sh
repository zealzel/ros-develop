#!/bin/bash
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../scripts/utils.sh"
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../scripts/argparse_ros.sh"
parse_args "$@"

WORKSPACE="${1:-colcon_ws}"
ROSDISTRO="${ROSDISTRO-galactic}"
CURRENT_SCRIPT_PATH="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
ADD_BASHRC=${2-"false"}
APT_PACKAGE_FILE=$3

echo
echo ====================================================================
echo Basic check
echo ====================================================================
# ros_package_file="$CURRENT_SCRIPT_PATH/$APT_PACKAGE_FILE"
ros_package_file="$APT_PACKAGE_FILE"

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

echo
echo ====================================================================
echo Install ROS packages for ROSDISTRO "$ROSDISTRO"
echo ====================================================================
TARGET_SCRIPT_ABSOLUTE_PATH="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/../scripts/install_ros_packages.sh")"
echo "TARGET_SCRIPT_ABSOLUTE_PATH: $TARGET_SCRIPT_ABSOLUTE_PATH"
"${TARGET_SCRIPT_ABSOLUTE_PATH}" "$ROSDISTRO" "${ros_packages[@]}"


if [ "$ADD_BASHRC" = "true" ]; then
  echo
  echo ====================================================================
  echo Append bashrc file
  echo ====================================================================
  append_bashrc "source /opt/ros/${ROSDISTRO}/setup.bash"

  append_bashrc "export LIBGL_ALWAYS_SOFTWARE=1"
  append_bashrc "export OGRE_RTT_MODE=Copy"

  append_bashrc "ROS_DOMAIN_ID=0"
  append_bashrc "RMW_IMPLEMENTATION=rmw_cyclonedds_cpp"
  append_bashrc "CYCLONEDDS_URI=/etc/turtlebot4/cyclonedds_pc.xml"
fi
