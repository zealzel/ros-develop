#!/usr/bin/bash
# source ../../scripts/utils.sh
# source ../../scripts/argparse_ros.sh
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../../scripts/utils.sh"
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../../scripts/argparse_ros.sh"

parse_args "$@"
echo "UBUNTU_CODENAME=$UBUNTU_CODENAME"
echo "ROSDISTRO=$ROSDISTRO"
#
# references:
# 1. https://colcon.readthedocs.io/en/released/user/installation.html
# 2. https://docs.ros.org/en/foxy/Tutorials/Beginner-Client-Libraries/Colcon-Tutorial.html
#

export DEBIAN_FRONTEND=noninteractive
sudo ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime
dpkg-reconfigure -f noninteractive tzdata

echo =============================
echo Setup apt-key sources
echo =============================
sudo apt update && sudo apt install -y curl lsb-release
sudo sh -c 'echo "deb [arch=amd64,arm64] http://repo.ros2.org/ubuntu/main `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list'
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

echo =============================
echo Install colcon
echo =============================
sudo apt update
sudo apt install -y python3-colcon-common-extensions ros-$ROSDISTRO-ament-cmake python3-pip

echo ====================================================================
echo Sourcing the colcon-argcomplete setup script
echo ====================================================================
source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash
append_bashrc "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash"
