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
$prepare_vcs_sh $WORKSPACE $VCS_REPOS

echo "WORKSPACE: $WORKSPACE"
echo "VCS_REPOS: $VCS_REPOS"

echo
echo ====================================================================
echo Build from source
echo ====================================================================
cd $HOME/"$WORKSPACE"
vcs import src < "$vcs_source"
rosdep install --from-paths src --ignore-src -r -y
colcon build --symlink-install

echo ====================================================================
echo Append bashrc file
echo ====================================================================
append_bashrc "RMW_IMPLEMENTATION=rmw_cyclonedds_cpp"
