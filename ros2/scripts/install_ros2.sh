#!/usr/bin/bash

# galactic: https://docs.ros.org/en/galactic/Installation/Ubuntu-Install-Debians.html
# foxy: https://docs.ros.org/en/foxy/Installation/Ubuntu-Install-Debians.html
# humble: https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debians.html

source ../../scripts/utils.sh
source ../../scripts/argparse_ros.sh

parse_args "$@"

echo "UBUNTU_CODENAME=$UBUNTU_CODENAME"
echo "ROSDISTRO=$ROSDISTRO"
echo "ROS_INSTALL_TYPE=$ROS_INSTALL_TYPE"
echo "APPEND_SOURCE_SCRIPT_TO_BASHRC=$APPEND_SOURCE_SCRIPT_TO_BASHRC"

ensure_sudo
sudo apt-get update && sudo apt-get install -y curl gnupg

echo
echo =======================
echo set locale
echo =======================
locale # check for UTF-8
sudo apt install locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8
locale # verify settings

export DEBIAN_FRONTEND=noninteractive
ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime
dpkg-reconfigure -f noninteractive tzdata

echo
echo =============================
echo Setup Sources
echo =============================
sudo apt install -y software-properties-common
sudo add-apt-repository universe
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

echo
echo =============================
echo Install ROS 2 packages
echo =============================
sudo apt update
sudo apt upgrade -y
sudo apt install -y ros-${ROS_DISTRO}-${ROS_INSTALL_TYPE}
sudo apt install -y ros-dev-tools

echo
echo ====================================================================
echo Sourcing the setup script
echo ====================================================================
if [ "$APPEND_SOURCE_SCRIPT_TO_BASHRC" = true ] ; then
  append_bashrc "source /opt/ros/${ROS_DISTRO}/setup.bash"
fi
