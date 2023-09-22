#!/bin/bash
script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

source "$script_dir/../scripts/argparse.sh"
declare -A arg_desc=(
  ["-w,--WORKSPACE"]="Workspace name (default: colcon_ws)"
  ["-v,--VCS_REPOS"]="vcs repos"
  ["-x,--EXCLUDES"]="excluded ros packages"
)
declare -A parsed_args
parse_args "$@"
WORKSPACE=${parsed_args["workspace"]-ros2_ws}
VCS_REPOS=${parsed_args["VCS_REPOS"]}
EXCLUDES=${parsed_args["EXCLUDES"]}
IFS=',' read -ra EXCLUDES_ARRAY <<< "$EXCLUDES"

echo "WORKSPACE: $WORKSPACE"
echo "VCS_REPOS: $VCS_REPOS"
if [ -n "$EXCLUDES" ]; then
    echo "EXCLUDES: "
    for ex in "${EXCLUDES_ARRAY[@]}"; do
      echo "$ex"
    done
fi

echo
echo ====================================================================
echo Prepare VCS sources
echo ====================================================================
prepare_vcs_sh="$(readlink -f $script_dir/prepare_vcs.sh)"
"$prepare_vcs_sh" $WORKSPACE $VCS_REPOS || exit_code=$?
if [[ $exit_code -ne 0 ]]; then
  echo "prepare_vcs_sh failed"
  exit
fi

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
