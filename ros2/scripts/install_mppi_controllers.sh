#!/usr/bin/bash
script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$script_dir/../../scripts/utils.sh"
source "$script_dir/../../scripts/argparse_ros.sh"

UBUNTU_CODENAME=$(cat /etc/os-release |grep VERSION_CODENAME|cut -d"=" -f2)
if [[ "$UBUNTU_CODENAME" == "focal" ]]; then
  echo "Ubuntu 20.04 detected. Set defualt ROSDISTRO to galactic."
  ROSDISTRO="galactic"
elif [[ "$UBUNTU_CODENAME" == "jammy" ]]; then
  echo "Ubuntu 22.04 detected. Set defualt ROSDISTRO to humble."
  ROSDISTRO="humble"
else
  echo "Ubuntu $UBUNTU_CODENAME is not supported"
  exit 1
fi

parse_args "$@"

# LATEST_WORKED_COMMIT="1.1.12"
LATEST_WORKED_COMMIT="3ed4c2df"

echo "ROSDISTRO=$ROSDISTRO"
echo "WORKSPACE=$WORKSPACE"
echo "LATEST_WORKED_COMMIT=$LATEST_WORKED_COMMIT"

"$script_dir/../../scripts/create_workspace.sh" $WORKSPACE || exit_code=$?
if [[ $exit_code -ne 0 ]]; then
  exit
fi

if [[ $ROSDISTRO == "humble" ]]; then
  echo "Install mppi_controllers from source."
  # In order to build the latest mppi_controllers, we need to build navigation2 from source.
  #
  # 1. remove the mppi_controllers binary package
  sudo apt remove ros-$ROSDISTRO-mppi-controllers -y
  #
  # when comping from source, trying out several commit, below is the latest results
  #
  # humble (57f55c) failed (10/16)
  # 3b791e failed (10/13)
  # 1b97e3 failed [MPPI Optimization] (10/10)
  # 1.1.12 ok (10/4)
  # 1.1.11 failed
  # 1.1.10 ok
  # 1.1.9 ok (8/4)

  # ref: MPPI crashing on loading plug-ings #3767
  # https://github.com/ros-planning/navigation2/issues/3767
  #
  rm -rf /tmp/navigation2 > /dev/null 2>&1
  git clone https://github.com/ros-planning/navigation2 /tmp/navigation2 -b "$ROSDISTRO"
  cd /tmp/navigation2 && git checkout $LATEST_WORKED_COMMIT
  cp -R /tmp/navigation2/nav2_mppi_controller "$HOME/$WORKSPACE/src"

  # 2. build
  cd "$HOME/$WORKSPACE"
  rm -rf build/nav2_mppi_controller install/nav2_mppi_controller > /dev/null 2>&1
  colcon build --symlink-install --packages-select nav2_mppi_controller
  #
  # 3. re-install nav2-bringup
  sudo apt install ros-$ROSDISTRO-nav2-bringup -y
fi
