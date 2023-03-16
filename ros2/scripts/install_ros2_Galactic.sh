#!/usr/bin/bash
# Offical ROS2 Documentation: https://docs.ros.org/en/galactic/Installation/Ubuntu-Install-Debians.html
source utils.sh

UBUNTU_CODENAME="focal"

ensure_sudo
sudo apt-get update && sudo apt-get install -y curl gnupg

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

echo =============================
echo Setup Sources
echo =============================
sudo apt install -y software-properties-common
sudo add-apt-repository universe
sudo apt update && sudo apt install -y curl
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo "$UBUNTU_CODENAME") main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

echo =============================
echo Install ROS 2 packages
echo =============================
sudo apt update
sudo apt install -y ros-galactic-desktop
# sudo apt install ros-galactic-ros-base
sudo apt install -y ros-dev-tools

# echo =============================
# echo Sourcing the setup script
# echo =============================
# # Replace ".bash" with your shell if you're not using bash
# # Possible values are: setup.bash, setup.sh, setup.zsh
# source /opt/ros/galactic/setup.bash
