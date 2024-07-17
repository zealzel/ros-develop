#!/usr/bin/env bash
script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
install_from_source_sh="$(readlink -f $script_dir/../scripts/install_from_source.sh)"
install_from_apt_sh="$(readlink -f $script_dir/../scripts/install_from_apt.sh)"
source "$(readlink -f "$script_dir/../scripts/argparse_ros.sh")"
parse_args "$@"
WORKSPACE=${parsed_args["workspace"]-simulations}
[ "$VERBOSE" == true ] && print_args

echo ===============================================
echo Prepare workspace for ROS2 development
echo ===============================================
../ros2/scripts/prepare_ros2_workspace.sh -w $WORKSPACE

source /opt/ros/${ROSDISTRO}/setup.bash >/dev/null 2>&1 || exit_code=$?
if [[ $exit_code -ne 0 ]]; then
  echo "/opt/ros/$ROSDISTRO/setup.sh does not exist."
  print_usage
  exit
fi

# Added temporarily for testing
[ $MPPI == true ] && ../ros2/scripts/install_mppi_controllers.sh -w $WORKSPACE

echo ===============================================
echo Download gazebo classic models
echo ===============================================
./download_gazebo_models.sh

echo ===============================================
echo 1. Install robots from package manager
echo ===============================================
"$install_from_apt_sh" $WORKSPACE $ROSDISTRO "$script_dir/simulations_turtlebot3/ros_packages.sh"

echo ===============================================
echo 2. Build/Install robots/worlds from source
echo ===============================================
"$script_dir/simulations_zbot_lino/setup_zbot_lino.sh" -w "$WORKSPACE" ${TOKEN:+-t $TOKEN}
"$script_dir/simulations_zbot_artic/setup_zbot_artic.sh" -w $WORKSPACE ${TOKEN:+-t $TOKEN}
# "$install_from_source_sh" $WORKSPACE "$script_dir/simulations_neobotix/neobotix.repos"
# "$install_from_source_sh" $WORKSPACE "$script_dir/world_aws_robotmaker/deps.repos"

echo ===============================================
echo 3. Build/Install robots by customed scripts
echo ===============================================
./install_rmf.sh -w $WORKSPACE -r $ROSDISTRO

WORKSPACEPATH="$HOME/$WORKSPACE"
rm -f $WORKSPACEPATH/*.repos
rm -f $WORKSPACEPATH/*.rosinstall

echo ===============================================
echo Set env variables
echo ===============================================
./ros2_append_bashrc.sh
