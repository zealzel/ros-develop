#!/bin/bash
WORKSPACE="${1:-simulations}"
BASE=2wd
LASER_SENSOR=rplidar
DEPTH_SENSOR=realsense

if [[ -d "$HOME/$WORKSPACE" ]]; then
  echo "$HOME/$WORKSPACE exist"
else
  echo "$HOME/$WORKSPACE does not exist"
  exit
fi

TARGET_SCRIPT_ABSOLUTE_PATH="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/../install_from_source.sh")"
"$TARGET_SCRIPT_ABSOLUTE_PATH" "$WORKSPACE" "false" "simulations_zbot_lino/zbot_lino.repos"

export LINOROBOT2_BASE=$BASE
export LINOROBOT2_LASER_SENSOR=$LASER_SENSOR
export LINOROBOT2_DEPTH_SENSOR=$DEPTH_SENSOR
echo "export LINOROBOT2_BASE=$BASE" >> ~/.bashrc
echo "export LINOROBOT2_LASER_SENSOR=$LASER_SENSOR" >> ~/.bashrc
echo "export LINOROBOT2_DEPTH_SENSOR=$DEPTH_SENSOR" >> ~/.bashrc
