#!/bin/bash
WORKSPACE="${1:-simulations}"
ROS_DISTRO="${ROS_DISTRO-galactic}"

if [[ -d "$HOME/$WORKSPACE" ]]; then
  echo "$HOME/$WORKSPACE exist"
else
  echo "$HOME/$WORKSPACE does not exist"
  exit
fi

TARGET_SCRIPT_ABSOLUTE_PATH="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/../install_from_source.sh")"
"${TARGET_SCRIPT_ABSOLUTE_PATH}" $WORKSPACE "false" "world_aws_robotmaker/deps.repos"
