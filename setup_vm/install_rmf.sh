#!/usr/bin/env bash
script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
install_from_source_sh="$(readlink -f $script_dir/../../scripts/install_from_source.sh)"
source "$(readlink -f "$script_dir/../../scripts/argparse_ros.sh")"
parse_args "$@"
WORKSPACE=${parsed_args["workspace"]-simulations}

ros_packages=(
  # rmf
  "ros-$ROS_DISTRO-rmf-dev"
  # traffic-editor
  "ros-$ROS_DISTRO-rmf-traffic-editor"
  "ros-$ROS_DISTRO-rmf-building-map-tools"
  "ros-$ROS_DISTRO-rmf-traffic-editor-assets"
  "ros-$ROS_DISTRO-rmf-traffic-editor-test-maps"
)

echo ===============================================
echo Install from package manager
echo ===============================================
install_ubuntu_packages "${ros_packages[@]}"

echo ===============================================
echo Build/Install from source
echo ===============================================
# "$install_from_source_sh" "$WORKSPACE" "$script_dir/rmf/rmf_$ROS_DISTRO.repos"

if [[ "$ROS_DISTRO" == "humble" ]]; then
  # temporary ignore ignition related packages since they will fail during building
  "$install_from_source_sh" -w "$WORKSPACE" -v "$script_dir/rmf/rmf_$ROS_DISTRO.repos" -i rmf_building_sim_gz_plugins,rmf_robot_sim_gz_plugins
fi
