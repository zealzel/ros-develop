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
  "python3-catkin-tools"
  "python3-dotenv"
  "python3-pip"
)
install_ubuntu_packages "${catkin_packages[@]}"

