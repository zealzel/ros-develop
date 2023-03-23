#!/usr/bin/bash
source ../../scripts/utils.sh
echo ====================
echo Install catkin_tools
echo ====================

catkin_packages=(
  "wget"
  "lsb-release"
  "gnupg"
  "make"
  "vim"
  "git"
  "g++"
  "python3-dotenv"
  "python3-pip"
  # Installing ROS will include below packages. Since we don't install ROS, we need to install them manually.
  "cmake" # Require setting area non-interactively
  "python3-empy"
  "python3-rospkg"
  "libboost-all-dev"
  "liblog4cxx-dev" # Apache Log4cxx is a C++ port of Apache Log4j
  "libbz2-dev"
  "liblz4-dev"
  "libconsole-bridge-dev"
  "libtinyxml2-dev"
  #
  # catkin-tools need to install ros apt-key. So we download it from source and use pip3 to install
  # "python3-catkin-tools"
)

# In oroder to skip manual area setting when installing cmake
export DEBIAN_FRONTEND=noninteractive
ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime
dpkg-reconfigure -f noninteractive tzdata

install_ubuntu_packages "${catkin_packages[@]}"

# ref: https://answers.ros.org/question/364445/having-issues-with-installations-of-catkin-tools/?answer=364447#post-id-364447
pip3 install git+https://github.com/catkin/catkin_tools.git
