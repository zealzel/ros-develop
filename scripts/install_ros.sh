#!/usr/bin/bash

# === ROS1 distros ===
# melodic: https://wiki.ros.org/melodic/Installation/Ubuntu
# noetic: http://wiki.ros.org/noetic/Installation/Ubuntu
# === ROS2 distros ===
# galactic: https://docs.ros.org/en/galactic/Installation/Ubuntu-Install-Debians.html
# foxy: https://docs.ros.org/en/foxy/Installation/Ubuntu-Install-Debians.html
# humble: https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debians.html

# source ./utils.sh
# source ./argparse_ros.sh
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/utils.sh"
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/argparse_ros.sh"

parse_args "$@"

echo "UBUNTU_CODENAME=$UBUNTU_CODENAME"
echo "ROSDISTRO=$ROSDISTRO"
echo "ROS_INSTALL_TYPE=$ROS_INSTALL_TYPE"
echo "APPEND_SOURCE_SCRIPT_TO_BASHRC=$APPEND_SOURCE_SCRIPT_TO_BASHRC"
ROS1DISTRO_ARRY=("melodic" "noetic")
ROS2DISTRO_ARRY=("galactic" "foxy" "humble")

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
# based on ROS1 and ROS2 distro, setup different sources
if [[ " ${ROS1DISTRO_ARRY[@]} " =~ " ${ROSDISTRO} " ]]; then
  sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
  curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
elif [[ " ${ROS2DISTRO_ARRY[@]} " =~ " ${ROSDISTRO} " ]]; then
  sudo apt install -y software-properties-common
  sudo add-apt-repository universe -y
  sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo "$UBUNTU_CODENAME") main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
else
  echo "ROS distro: $ROSDISTRO is not supported"
  exit 1
fi

echo
echo =============================
echo Install ROS packages
echo =============================
sudo apt update
sudo apt upgrade -y
sudo apt install -y ros-"$ROSDISTRO-$ROS_INSTALL_TYPE"
if [[ " ${ROS2DISTRO_ARRY[@]} " =~ " ${ROSDISTRO} " ]]; then
  sudo apt install -y ros-dev-tools
fi

if [ "$APPEND_SOURCE_SCRIPT_TO_BASHRC" = "true" ]; then
  echo
  echo ====================================================================
  echo Sourcing the setup script
  echo ====================================================================
  source "/opt/ros/${ROSDISTRO}/setup.bash"
  append_bashrc "source /opt/ros/${ROSDISTRO}/setup.bash"
fi
