#!/bin/bash
script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
install_from_source_sh="$(readlink -f $script_dir/../../scripts/install_from_source.sh)"
source "$script_dir/../../scripts/argparse_ros.sh"

WORKSPACE="simulations"
UBUNTU_CODENAME=$(cat /etc/os-release | grep VERSION_CODENAME | cut -d"=" -f2)
if [[ "$UBUNTU_CODENAME" == "focal" ]]; then
    echo "Ubuntu 20.04 detected. Set defualt ROS_DISTRO to galactic."
    ROS_DISTRO="galactic"
elif [[ "$UBUNTU_CODENAME" == "jammy" ]]; then
    echo "Ubuntu 22.04 detected. Set defualt ROS_DISTRO to humble."
    ROS_DISTRO="humble"
else
    echo "Ubuntu $UBUNTU_CODENAME is not supported"
    exit 1
fi

parse_args "$@"
echo "UBUNTU_CODENAME=$UBUNTU_CODENAME"
echo "ROS_DISTRO=$ROS_DISTRO"
echo "WORKSPACE=$WORKSPACE"

source /opt/ros/${ROS_DISTRO}/setup.bash >/dev/null 2>&1 || exit_code=$?
if [[ $exit_code -ne 0 ]]; then
    echo "/opt/ros/$ROS_DISTRO/setup.sh does not exist."
    print_usage
    exit
fi

ROS_DISTRO="$(printenv ROS_DISTRO)"
"$install_from_source_sh" -w $WORKSPACE -v "zbot_artic_$ROS_DISTRO.repos" -i linorobot2_bringup

# TARGET_SCRIPT_ABSOLUTE_PATH="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/../install_from_source.sh")"
# "${TARGET_SCRIPT_ABSOLUTE_PATH}" $WORKSPACE "false" "simulations_zbot_artic/zbot_artic.repos"
