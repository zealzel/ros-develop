#!/bin/bash
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../../scripts/utils.sh"

WORKSPACE_NAME="${1:-zbotlino_ws}"
WORKSPACE=$HOME/$WORKSPACE_NAME
ROS_DISTRO="${ROS_DISTRO-galactic}"
../../scripts/create_workspace.sh "$WORKSPACE_NAME" || exit_code=$?
if [[ $exit_code -ne 0 ]]; then
  exit
fi

ORIGINAL_IMAGE="[488d07354c8b92592c3c0e759b0f4730dce21dce]ubuntu-20.04.5-preinstalled-server-arm64+raspi.img.xz"
IMAGE_DOWNLOAD_SITE=
echo "The original image: $ORIGINAL_IMAGE"
echo "The original image donwload site: $IMAGE_DOWNLOAD_SITE"

echo
echo ====================================================================
echo Install ROS2
echo ====================================================================
../../ros2/scripts/install_ros2.sh
../../ros2/scripts/install_ros2_packages.sh

ROSDISTRO="$(printenv ROS_DISTRO)"
BASE=2wd
LASER_SENSOR=rplidar
DEPTH_SENSOR=realsense

function install_rplidar {
  sudo apt install -y ros-"$ROS_DISTRO"-rplidar-ros
  cd /tmp
  wget https://raw.githubusercontent.com/allenh1/rplidar_ros/ros2/scripts/rplidar.rules
  sudo cp rplidar.rules /etc/udev/rules.d/
}

function install_realsense {
  sudo apt install -y ros-"$ROS_DISTRO"-realsense2-camera
  cd /tmp
  wget https://raw.githubusercontent.com/IntelRealSense/librealsense/master/config/99-realsense-libusb.rules
  sudo cp 99-realsense-libusb.rules /etc/udev/rules.d
}

source /opt/ros/${ROS_DISTRO}/setup.bash
if [[ "$ROSDISTRO" == "" || "$ROSDISTRO" == "<unknown>" ]]; then
  echo "No ROS2 distro detected"
  echo "Try running $ source /opt/ros/<ros_distro>/setup.bash and try again."
  exit 1
fi

echo "You are installing zbot_lino on your robot computer."
echo
echo "===========SUMMARY============"
echo "ROBOT TYPE   : $BASE"
echo "LASER SENSOR : $LASER_SENSOR"
echo "DEPTH SENSOR : $DEPTH_SENSOR"
echo
echo "This installer will edit your ~/.bashrc."
echo "Create a zbotlino_ws on your $HOME directory."
echo "Install zbot_lino ROS2 dependencies."
echo "Install udev rules on /etc/udev/rules.d folder."
echo -n "Enter [y] to continue. "
read reply
if [[ "$reply" != "y" && "$reply" != "Y" ]]; then
  echo "Exiting now."
  exit 1
fi

echo
echo "INSTALLING NOW...."
echo

echo
echo "===================================================================="
echo "Ensure rosdep is initialized"
echo "===================================================================="
if [ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then
  sudo rosdep init
  rosdep update --include-eol-distros
fi

echo
echo ====================================================================
echo Basic check
echo ====================================================================
VCS_REPOS="zbot_lino.repos"
vcs_source="$VCS_REPOS"
if [ -d "$WORKSPACE" ]; then
  if [ -f "$vcs_source" ]; then
    echo "vcs_source: $vcs_source exists"
  else
    echo "ERROR: $vcs_source does not exist"
    exit 1
  fi
  cp "$vcs_source" "$WORKSPACE" > /dev/null 2>&1
  #cp "$vcs_source" "$WORKSPACE"
else
  echo "ERROR: $WORKSPACE does not exist"
  exit 1
fi

echo
echo "===================================================================="
echo "Install LIDAR/Depth Sensor ROS2 drivers"
echo "===================================================================="
install_rplidar
install_realsense

echo
echo "===================================================================="
echo "Install apt packages"
echo "===================================================================="
sudo apt install -y python3-vcstool build-essential ros-"$ROS_DISTRO"-robot-localization

echo
echo "===================================================================="
echo "Install micro_ros_setup"
echo "===================================================================="
cd "$WORKSPACE"
vcs_source="$VCS_REPOS"
vcs import src < "$vcs_source"
cd "$WORKSPACE/src/zbot_lino/linorobot2" && touch COLCON_IGNORE
cd "$WORKSPACE"
rosdep install --from-path src --ignore-src -y
colcon build && source "$WORKSPACE"/install/setup.bash

echo
echo "===================================================================="
echo "Setup micro-ROS agent"
echo "===================================================================="
ros2 run micro_ros_setup create_agent_ws.sh
ros2 run micro_ros_setup build_agent.sh
source "$WORKSPACE"/install/setup.bash

echo
echo "===================================================================="
echo "Build zbot_lino"
echo "===================================================================="
cd "$WORKSPACE/src/zbot_lino/linorobot2" && rm COLCON_IGNORE
cd "$WORKSPACE" && colcon build
source "$WORKSPACE"/install/setup.bash

## ENV Variables
echo ======== Env Variables ========
if [[ "$BASE" != "ci" ]]; then
  echo "export LINOROBOT2_BASE=$BASE" >> ~/.bashrc
  echo "export LINOROBOT2_LASER_SENSOR=$LASER_SENSOR" >> ~/.bashrc
  echo "export LINOROBOT2_DEPTH_SENSOR=$DEPTH_SENSOR" >> ~/.bashrc
  echo
  echo "Do you want to add sourcing of linorobot2_ws on your ~/.bashrc?"
  echo -n "Yes [y] or No [n]: "
  read reply
  if [[ "$reply" == "y" || "$reply" == "Y" ]]; then
    echo "source ${WORKSPACE}/install/setup.bash" >> ~/.bashrc
  else
    echo
    echo "Remember to run $ source ${WORKSPACE}/install/setup.bash every time you open a terminal."
  fi
fi

echo
echo "INSTALLATION DONE."
echo
echo "Restart your robot computer now."
