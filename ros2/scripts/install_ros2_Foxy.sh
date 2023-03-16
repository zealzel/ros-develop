#!/usr/bin/bash
# Offical ROS2 Documentation: https://docs.ros.org/en/foxy/Installation/Alternatives/Ubuntu-Development-Setup.html#add-the-ros-2-apt-repository
source utils.sh

UBUNTU_CODENAME="focal"

echo =======================
echo set locale
echo =======================
locale # check for UTF-8
sudo apt update && sudo apt install locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8
locale # verify settings

echo =============================
echo Add the ROS 2 apt repository
echo =============================
sudo apt install software-properties-common
sudo add-apt-repository universe
sudo apt update && sudo apt install curl
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo "$UBUNTU_CODENAME") main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

echo =============================
echo install python dependencies
echo =============================
sudo apt update && sudo apt install -y \
  libbullet-dev \
  python3-pip \
  python3-pytest-cov \
  ros-dev-tools

echo =============================================
echo install some pip packages needed for testing
echo =============================================
python3 -m pip install -U \
  argcomplete \
  flake8-blind-except \
  flake8-builtins \
  flake8-class-newline \
  flake8-comprehensions \
  flake8-deprecated \
  flake8-docstrings \
  flake8-import-order \
  flake8-quotes \
  pytest-repeat \
  pytest-rerunfailures \
  pytest
echo =============================================
echo install Fast-RTPS dependencies
echo =============================================
sudo apt install --no-install-recommends -y \
  libasio-dev \
  libtinyxml2-dev
echo =============================================
echo install Cyclone DDS dependencies
echo =============================================
sudo apt install --no-install-recommends -y \
  libcunit1-dev
