#!/bin/bash
script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
install_from_source_sh="$(readlink -f $script_dir/../scripts/install_from_source.sh)"
install_from_apt_sh="$(readlink -f $script_dir/../scripts/install_from_apt.sh)"
source "$script_dir/../scripts/utils.sh"
source "$script_dir/../scripts/argparse_ros.sh"

WORKSPACE="simulations"
UBUNTU_CODENAME=$(cat /etc/os-release |grep VERSION_CODENAME|cut -d"=" -f2)
if [[ "$UBUNTU_CODENAME" == "focal" ]]; then
  echo "Ubuntu 20.04 detected. Set defualt ROSDISTRO to galactic."
  ROSDISTRO="galactic"
elif [[ "$UBUNTU_CODENAME" == "jammy" ]]; then
  echo "Ubuntu 22.04 detected. Set defualt ROSDISTRO to humble."
  ROSDISTRO="humble"
else
  echo "Ubuntu $UBUNTU_CODENAME is not supported"
  exit 1
fi

parse_args "$@"
echo "UBUNTU_CODENAME=$UBUNTU_CODENAME"
echo "ROSDISTRO=$ROSDISTRO"
echo "WORKSPACE=$WORKSPACE"

echo ===============================================
echo Prepare workspace for ROS2 development
echo ===============================================
../ros2/scripts/prepare_ros2_workspace.sh -u $UBUNTU_CODENAME -r $ROSDISTRO -w $WORKSPACE

ROS_DISTRO="$(printenv ROS_DISTRO)"
source /opt/ros/${ROSDISTRO}/setup.bash >/dev/null 2>&1 || exit_code=$?
if [[ $exit_code -ne 0 ]]; then
  echo "/opt/ros/$ROSDISTRO/setup.sh does not exist."
  print_usage
  exit
fi

# Added temporarily for testing
../ros2/scripts/install_mppi_controllers.sh -r $ROS_DISTRO -w $WORKSPACE

echo ===============================================
echo Download gazebo classic models
echo ===============================================
./download_gazebo_models.sh

echo ===============================================
echo 1. Install robots from package manager
echo ===============================================
"$install_from_apt_sh" $WORKSPACE $ROS_DISTRO "$script_dir/simulations_turtlebot3/ros_packages.sh"

echo ===============================================
echo 2. Build/Install robots/worlds from source
echo ===============================================
"$install_from_source_sh" -w $WORKSPACE -v "$script_dir/simulations_zbot_artic/zbot_artic_$ROS_DISTRO.repos"
"$install_from_source_sh" -w $WORKSPACE -v "$script_dir/simulations_zbot_lino/zbot_lino_$ROS_DISTRO.repos"
# "$install_from_source_sh" $WORKSPACE "$script_dir/simulations_neobotix/neobotix.repos"
# "$install_from_source_sh" $WORKSPACE "$script_dir/world_aws_robotmaker/deps.repos"

echo ===============================================
echo 3. Build/Install robots by customed scripts
echo ===============================================
# ./simulations_tiago/tiago.sh $WORKSPACE
./install_rmf.sh -w $WORKSPACE -r $ROSDISTRO

WORKSPACEPATH="$HOME/$WORKSPACE"
rm -f $WORKSPACEPATH/*.repos
rm -f $WORKSPACEPATH/*.rosinstall

echo ===============================================
echo Set env variables
echo ===============================================
./ros2_append_bashrc.sh
