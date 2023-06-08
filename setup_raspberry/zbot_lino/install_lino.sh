set -e

ROSDISTRO="$(printenv ROS_DISTRO)"
BASE=$1
LASER_SENSOR=$2
DEPTH_SENSOR=$3
ARCH="$(uname -m)"
WORKSPACE="$HOME/linorobot2_ws"

ROBOT_TYPE_ARRAY=(2wd 4wd mecanum)
DEPTH_SENSOR_ARRAY=(realsense zed zedm zed2 zed2i)
LASER_SENSOR_ARRAY=(rplidar ldlidar ydlidar xv11)
LASER_SENSOR_ARRAY+=("${DEPTH_SENSOR_ARRAY[@]}")

if [ "$LASER_SENSOR" = "" ]; then
  LASER_SENSOR="rplidar"
fi

if [ "$DEPTH_SENSOR" = "" ]; then
  DEPTH_SENSOR="realsense"
fi

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

if [[ "$ROSDISTRO" == "" || "$ROSDISTRO" == "<unknown>" ]]; then
  echo "No ROS2 distro detected"
  echo "Try running $ source /opt/ros/<ros_distro>/setup.bash and try again."
  exit 1
fi

if [ "$*" == "" ]; then
  echo "No arguments provided"
  echo
  echo "Example: $ bash install_linorobot2.bash 2wd rplidar"
  echo "Example: $ bash install_linorobot2.bash 2wd rplidar realsense"
  echo "Example: $ bash install_linorobot2.bash 2wd - realsense"
  echo "Example: $ bash install_linorobot2.bash 2wd"

  echo
  exit 1
fi

if [[ "$BASE" != "ci" ]] && !(printf '%s\n' "${ROBOT_TYPE_ARRAY[@]}" | grep -xq "$BASE"); then
  echo "Invalid linorobot base: $1"
  echo
  echo "Valid Options:"
  for key in "${!ROBOT_TYPE_ARRAY[@]}"; do echo "${ROBOT_TYPE_ARRAY[$key]}"; done
  echo
  exit 1
fi

if [[ "$BASE" != "ci" && "$LASER_SENSOR" != "" && "$LASER_SENSOR" != "-" ]] && !(printf '%s\n' "${LASER_SENSOR_ARRAY[@]}" | grep -xq "$LASER_SENSOR"); then
  echo "Invalid linorobot2 laser sensor: $LASER_SENSOR"
  echo
  echo "Valid Options:"
  for key in "${!LASER_SENSOR_ARRAY[@]}"; do echo "${LASER_SENSOR_ARRAY[$key]}"; done
  echo
  exit 1
fi

if [[ "$BASE" != "ci" && "$DEPTH_SENSOR" != "" ]] && !(printf '%s\n' "${DEPTH_SENSOR_ARRAY[@]}" | grep -xq "$DEPTH_SENSOR"); then
  echo "Invalid linorobot2 depth sensor: $DEPTH_SENSOR"
  echo
  echo "Valid Options:"
  for key in "${!DEPTH_SENSOR_ARRAY[@]}"; do echo "${DEPTH_SENSOR_ARRAY[$key]}"; done
  echo
  exit 1
fi

if [[ "$BASE" != "ci" ]]; then
  echo
  echo "You are installing linorobot2 on your robot computer."
  echo
  echo "===========SUMMARY============"
  echo "ROBOT TYPE   : $BASE"
  echo "LASER SENSOR : $LASER_SENSOR"
  echo "DEPTH SENSOR : $DEPTH_SENSOR"
  echo
  echo "This installer will edit your ~/.bashrc."
  echo "Create a linorobot2_ws on your $HOME directory."
  echo "Install linorobot2 ROS2 dependencies."
  echo "Install udev rules on /etc/udev/rules.d folder."
  echo -n "Enter [y] to continue. "
  read reply
  if [[ "$reply" != "y" && "$reply" != "Y" ]]; then
    echo "Exiting now."
    exit 1
  fi
fi

echo
echo "INSTALLING NOW...."
echo

echo
echo "===================================================================="
echo "Create workspace"
echo "===================================================================="
mkdir -p "$WORKSPACE"/src
source /opt/ros/"$ROS_DISTRO"/setup.bash

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
if (printf '%s\n' "${LASER_SENSOR_ARRAY[@]}" | grep -xq "$LASER_SENSOR"); then
  install_"$LASER_SENSOR"
fi

if (printf '%s\n' "${DEPTH_SENSOR_ARRAY[@]}" | grep -xq "$DEPTH_SENSOR"); then
  install_"$DEPTH_SENSOR"
fi

if [[ "$BASE" == "ci" ]]; then
  for key in "${!LASER_SENSOR_ARRAY[@]}"; do install_"${LASER_SENSOR_ARRAY[$key]}"; done
fi

echo
echo "===================================================================="
echo "Install apt packages"
echo "===================================================================="
sudo apt install -y python3-vcstool build-essential ros-${ROS_DISTRO}-robot-localization

echo
echo "===================================================================="
echo "Install micro_ros_setup"
echo "===================================================================="
cd "$WORKSPACE"
vcs_source="$VCS_REPOS"
vcs import src < "$vcs_source"
cd "$WORKSPACE/src/zbot_lino/linorobot2" && touch COLCON_IGNORE
cd $WORKSPACE
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
cd $WORKSPACE && colcon build
source "$WORKSPACE"/install/setup.bash

## ENV Variables
echo ======== Env Variables ========
if [[ "$BASE" != "ci" ]]; then
  ### 1. Robot Type
  echo "export LINOROBOT2_BASE=$BASE" >> ~/.bashrc
  ### 2. Sensors
  if [[ "$LASER_SENSOR" != "-" || "$LASER_SENSOR" != "" ]]; then
    echo "export LINOROBOT2_LASER_SENSOR=$LASER_SENSOR" >> ~/.bashrc
  fi

  if [[ "$DEPTH_SENSOR" != "-" || "$DEPTH_SENSOR" != "" ]]; then
    echo "export LINOROBOT2_DEPTH_SENSOR=$DEPTH_SENSOR" >> ~/.bashrc
  fi
  echo
  echo "Do you want to add sourcing of linorobot2_ws on your ~/.bashrc?"
  echo -n "Yes [y] or No [n]: "
  read reply
  if [[ "$reply" == "y" || "$reply" == "Y" ]]; then
    echo "source \$HOME/linorobot2_ws/install/setup.bash" >> ~/.bashrc
  else
    echo
    echo "Remember to run $ source ~/linorobot2_ws/install/setup.bash every time you open a terminal."
  fi
fi

echo
echo "INSTALLATION DONE."
echo
echo "Restart your robot computer now."

