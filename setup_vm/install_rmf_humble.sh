#!/bin/bash
script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
install_from_source_sh="$(readlink -f $script_dir/../scripts/install_from_source.sh)"
install_from_apt_sh="$(readlink -f $script_dir/../scripts/install_from_apt.sh)"
source "$script_dir/../scripts/utils.sh"
source "$script_dir/../scripts/argparse_ros.sh"

WORKSPACE="simulations"
UBUNTU_CODENAME=$(cat /etc/os-release |grep VERSION_CODENAME|cut -d"=" -f2)
if [[ "$UBUNTU_CODENAME" == "focal" ]]; then
  ROSDISTRO="galactic"
elif [[ "$UBUNTU_CODENAME" == "jammy" ]]; then
  ROSDISTRO="humble"
else
  echo "Ubuntu $UBUNTU_CODENAME is not supported"
  exit 1
fi

parse_args "$@"
# echo "UBUNTU_CODENAME=$UBUNTU_CODENAME"
# echo "ROSDISTRO=$ROSDISTRO"
# echo "WORKSPACE=$WORKSPACE"

ros_packages=(
  "ros-$ROSDISTRO-rmf-dev"
  "ros-$ROSDISTRO-rmf-traffic-editor"
  "ros-$ROSDISTRO-rmf-building-map-tools"
  "ros-$ROSDISTRO-rmf-traffic-editor-assets"
  "ros-$ROSDISTRO-rmf-traffic-editor-test-maps"
)

echo ===============================================
echo Install from package manager
echo ===============================================
install_ubuntu_packages "${ros_packages[@]}"


echo ===============================================
echo Build/Install from source
echo ===============================================
"$install_from_source_sh" $WORKSPACE "$script_dir/rmf/install_rmf_$ROS_DISTRO.repos"
