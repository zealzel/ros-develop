#!/bin/bash
script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$script_dir/../../scripts/utils.sh"
source sensors.sh
script_start_time=$(date +%s)
prepare_vcs_sh="$(readlink -f "$script_dir"/../../scripts/prepare_vcs.sh)"

# Detect Ubuntu version and set ROS distribution accordingly
. /etc/os-release
case $VERSION_CODENAME in
  focal)
    ROSDISTRO="galactic"
    ORIGINAL_IMAGE="[488d07354c8b92592c3c0e759b0f4730dce21dce]ubuntu-20.04.5-preinstalled-server-arm64+raspi.img.xz"
    ;;
  jammy)
    ROSDISTRO="humble"
    ORIGINAL_IMAGE="[1ebe853ca69ce507a69f97bb70f13bc1ffcfa7a2]ubuntu-22.04.2-preinstalled-server-arm64+raspi.img.xz"
    ;;
  *)
    echo "Ubuntu $VERSION_CODENAME is not supported."
    exit 1
    ;;
esac
#
# Common setup for all supported Ubuntu versions
echo "Setting up for ROS Distro: $ROSDISTRO"
WORKSPACE="zbotlino_ws"
WORKSPACEPATH="$HOME/$WORKSPACE"
disable_needrestart # Workaround for the needrestart issue

echo "UBUNTU_CODENAME=$VERSION_CODENAME"
echo "ROSDISTRO=$ROSDISTRO"
echo "WORKSPACE=$WORKSPACE"

echo
echo ====================================================================
echo Prepare ROS2 environment and workspace
echo ====================================================================
stage1_start_time=$(date +%s)
../../ros2/scripts/prepare_ros2_workspace.sh -u "$UBUNTU_CODENAME" -r "$ROSDISTRO" -w "$WORKSPACE"
calculate_and_store_time $stage1_start_time "Prepare ROS2 environment and workspace"

source /opt/ros/"$ROSDISTRO"/setup.bash
ROS_DISTRO="$(printenv ROS_DISTRO)"

BASE=zbotlino2
case $BASE in
  zbotlino)
    LASER_SENSOR=rplidar
    ;;
  zbotlinoinvert | zbotlinosick1 | zbotlinosick2 | zbotlino2)
    LASER_SENSOR=nanoscan3
    ;;
  *)
    echo "Invalid robot type"
    exit 1
    ;;
esac

if [[ "$ROS_DISTRO" == "" || "$ROS_DISTRO" == "<unknown>" ]]; then
  echo "No ROS2 distro detected"
  echo "Try running $ source /opt/ros/<ros_distro>/setup.bash and try again."
  exit 1
fi

echo "You are installing zbot_lino on your robot computer."
echo
echo "===========SUMMARY============"
echo "ROBOT TYPE   : $BASE"
echo "LASER SENSOR : $LASER_SENSOR"
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
echo "===================================================================="
echo "Install LIDAR/Depth Sensor ROS2 drivers"
echo "===================================================================="
stage2_start_time=$(date +%s)
# install_rplidar
install_librealsense2
calculate_and_store_time $stage2_start_time "Install LIDAR/Depth Sensor ROS2 drivers"

echo
echo "===================================================================="
echo "Install apt packages"
echo "===================================================================="
stage3_start_time=$(date +%s)
sudo apt install -y python3-vcstool build-essential ros-"$ROS_DISTRO"-robot-localization ros-"$ROS_DISTRO"-rosbridge-server
sudo apt install -y python3-websocket # for fitrobot_lino.status.service
calculate_and_store_time $stage3_start_time "Install apt packages"

echo
echo "===================================================================="
echo "Install rosdep dependencies"
echo "===================================================================="
stage4_start_time=$(date +%s)
vcs_repo_path="$script_dir/zbot_linov2_$ROS_DISTRO.repos"
"$prepare_vcs_sh" "$WORKSPACE" "$vcs_repo_path"
cd "$WORKSPACEPATH"
vcs import src < "$vcs_repo_path"
rosdep install --from-path src --ignore-src -y
calculate_and_store_time $stage4_start_time "Install rosdep dependencies"

echo
echo "===================================================================="
echo "Install micro_ros_setup"
echo "===================================================================="
stage5_start_time=$(date +%s)
colcon build --packages-select micro_ros_setup && source "$WORKSPACEPATH"/install/setup.bash
calculate_and_store_time $stage5_start_time "Install micro_ros_setup"

echo
echo "===================================================================="
echo "Setup micro-ROS agent"
echo "===================================================================="
stage6_start_time=$(date +%s)
ros2 run micro_ros_setup create_agent_ws.sh
ros2 run micro_ros_setup build_agent.sh
source "$WORKSPACEPATH"/install/setup.bash
calculate_and_store_time $stage6_start_time "Setup micro-ROS agent"

echo
echo "===================================================================="
echo "Build zbot_lino"
echo "===================================================================="
stage7_start_time=$(date +%s)
touch "$WORKSPACEPATH/src/zbot_lino/linorobot2/linorobot2_gazebo"/COLCON_IGNORE
cd "$WORKSPACEPATH" && colcon build --symlink-install
source "$WORKSPACEPATH"/install/setup.bash
calculate_and_store_time $stage7_start_time "Build zbot_lino"

echo "===================================================================="
echo "Use newest nav2 mppi_controllers                                    "
echo "===================================================================="
stage8_start_time=$(date +%s)
../../ros2/scripts/install_mppi_controllers.sh -r "$ROS_DISTRO" -w "$WORKSPACE"
calculate_and_store_time $stage8_start_time "Use newest nav2 mppi_controllers"

echo "===================================================================="
echo "Setup environment variables                                         "
echo "===================================================================="
append_bashrc "export LINOROBOT2_BASE=$BASE"
append_bashrc "export LINOROBOT2_LASER_SENSOR=$LASER_SENSOR"
append_bashrc "export LINOROBOT2_DEPTH_SENSOR=$DEPTH_SENSOR"
append_bashrc "export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp"
append_bashrc "source ${WORKSPACEPATH}/install/setup.bash"

echo
echo "===================================================================="
echo "setup systemd services                                              "
echo "===================================================================="
sudo cp "$WORKSPACEPATH/src/fitrobot/systemd/fitrobot.lino.service" /etc/systemd/system
sudo cp "$WORKSPACEPATH/src/fitrobot/systemd/fitrobot_lino.bringup.service" /etc/systemd/system
sudo cp "$WORKSPACEPATH/src/fitrobot/systemd/fitrobot_lino.status.service" /etc/systemd/system
sudo systemctl enable fitrobot.lino.service
sudo systemctl enable fitrobot_lino.bringup.service
sudo systemctl enable fitrobot_lino.status.service

echo
echo "===================================================================="
echo "Setup audio"
echo "===================================================================="
stage9_start_time=$(date +%s)
./setup_audio.sh
calculate_and_store_time $stage9_start_time "Setup audio"

echo
echo "===================================================================="
echo "setup network including additional wifi driver                      "
echo "===================================================================="
./overclock.sh # for pi4

# better to run this script manually
stage10_start_time=$(date +%s)
./install_rtl88x2bu.sh
calculate_and_store_time $stage10_start_time "setup network including additional wifi driver"
# ./set_network.sh
