#!/usr/bin/bash
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../../scripts/utils.sh"
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../../scripts/argparse_ros.sh"
parse_args "$@"

echo "ROSDISTRO=$ROSDISTRO"
echo "WORKSPACE=$WORKSPACE"

if [[ $ROSDISTRO == "humble" ]]; then
  echo "Install mppi_controllers from source."
  # ref: MPPI crashing on loading plug-ings #3767
  # https://github.com/ros-planning/navigation2/issues/3767
  rm -rf /tmp/navigation2 > /dev/null 2>&1
  git clone https://github.com/ros-planning/navigation2 /tmp/navigation2 -b "$ROSDISTRO"
  cp -R /tmp/navigation2/nav2_mppi_controller "$HOME/$WORKSPACE/src"
fi
