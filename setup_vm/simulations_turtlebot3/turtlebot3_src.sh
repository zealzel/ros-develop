#!/bin/bash
script_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
install_from_source_sh="$(realpath "$script_dir"/../../scripts/install_from_source.sh)"

ROS_DISTRO="${ROS_DISTRO-humble}"
WORKSPACE="${1-simulations}"

echo
echo ====================================================================
echo Install turtlebot3 from source
echo ====================================================================
"$install_from_source_sh" "$WORKSPACE" "$script_dir/tb3-{ROS_DISTRO}.repos"
