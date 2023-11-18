#!/bin/bash
script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
install_from_source_sh="$(readlink -f $script_dir/../../scripts/install_from_source.sh)"
source "$script_dir/../../scripts/argparse_ros.sh"

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

source /opt/ros/${ROSDISTRO}/setup.bash >/dev/null 2>&1 || exit_code=$?
if [[ $exit_code -ne 0 ]]; then
  echo "/opt/ros/$ROSDISTRO/setup.sh does not exist."
  print_usage
  exit
fi

../../ros2/scripts/install_mppi_controllers.sh -r $ROS_DISTRO -w $WORKSPACE

../install_rmf.sh -w $WORKSPACE -r $ROSDISTRO

ROS_DISTRO="$(printenv ROS_DISTRO)"
"$install_from_source_sh" -w $WORKSPACE -v "zbot_lino_$ROS_DISTRO.repos" -i linorobot2_bringup
