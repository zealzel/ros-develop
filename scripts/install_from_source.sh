#!/bin/bash
script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$script_dir/../scripts/utils.sh"
prepare_vcs_sh="$(readlink -f $script_dir/prepare_vcs.sh)"

WORKSPACE="${1:-colcon_ws}"
VCS_REPOS=$2

echo
echo ====================================================================
echo Prepare VCS sources
echo ====================================================================
"$prepare_vcs_sh" $WORKSPACE $VCS_REPOS

echo "WORKSPACE: $WORKSPACE"
echo "VCS_REPOS: $VCS_REPOS"

echo
echo ====================================================================
echo Build from source
echo ====================================================================
cd $HOME/"$WORKSPACE"
vcs import src < "$VCS_REPOS"


# ignored_ros_packages=(
#   "ros-$ROSDISTRO-xacro"
#   "ros-$ROSDISTRO-joy-teleop"
# )

# for pkg in "${ignored_ros_packages[@]}"; do
#     pkg_path=$(find src -type d -name $pkg)
#     echo $pkg_path
# done

# find src -type d -name rmf_building_sim_gz_classic_plugins

rosdep install --from-paths src --ignore-src -r -y
colcon build --symlink-install

echo ====================================================================
echo Append bashrc file
echo ====================================================================
append_bashrc "RMW_IMPLEMENTATION=rmw_cyclonedds_cpp"
