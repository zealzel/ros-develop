#!/usr/bin/bash
source ../../scripts/utils.sh
#
# references:
# 1. https://colcon.readthedocs.io/en/released/user/installation.html
# 2. https://docs.ros.org/en/foxy/Tutorials/Beginner-Client-Libraries/Colcon-Tutorial.html
#
UBUNTU_CODENAME="focal"
ROS_DISTRO="galactic"

export DEBIAN_FRONTEND=noninteractive
ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime
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
sudo apt install -y python3-colcon-common-extensions ros-$ROS_DISTRO-ament-cmake python3-pip

echo ====================================================================
echo Sourcing the colcon-argcomplete setup script
echo ====================================================================
source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash
append_bashrc "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash"
