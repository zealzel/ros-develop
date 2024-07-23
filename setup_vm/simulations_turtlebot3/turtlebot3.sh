#!/bin/bash
script_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
# shellcheck source=../../scripts/argparse.sh
source "$script_dir/../../scripts/argparse.sh"

declare -A arg_desc=(
  ["-w,--workspace"]="Workspace name (default: colcon_ws)"
  ["-s,--install_from_source"]="install from source. false if from package (default: false)"
)

declare -A parsed_args
parse_args "$@"

declare -A default_flags=(
  ["--install_from_source"]=false
)
FROM_SOURCE=$(parse_flag "install_from_source")
WORKSPACE=${parsed_args["WORKSPACE"]-ros2_ws}

if [ "$FROM_SOURCE" = true ]; then
  "$script_dir/turtlebot3_src.sh" "$WORKSPACE"
else
  "$script_dir/turtlebot3_apt.sh" "$ROS_DISTRO"
fi
