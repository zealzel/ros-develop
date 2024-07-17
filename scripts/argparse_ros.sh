#!/usr/bin/env bash
current_script="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$(readlink -f "$current_script/argparse.sh")"

# 選項描述
declare -A arg_desc=(
  # ["-u,--ubuntu-codename"]="Ubuntu codename (default: focal)"
  # ["-r,--rosdistro"]="ROS distribution (default: noetic)"
  ["-w,--workspace"]="Workspace name (default: my_ws)"
  ["-t,--token"]="github token"
  ["-i,--ros_install_type"]="the type of ROS installation (desktop|ros-base) (default: desktop)"
  ["-v,--verbose"]="verbose (default: false)"
  ["-o,--install_ros2"]="install ros2 dev environment (default: false)"
  ["-g,--download_gz_models"]="download gazebo models (default: false)"
  ["-m,--enable_mppi_fix"]="enable mppi fix (default: false)"
  ["-r,--enable_rmf"]="enable rmf environment (default: false)"
  ["-f,--force"]="Delete workspace repositories (default: false)"
  ["-h,--help"]="help"
)

# 用於存儲解析後的參數
declare -A parsed_args

# 解析參數
parse_args "$@"

declare -A default_flags=(
  ["--verbose"]=false
  ["--install_ros2"]=false
  ["--download_gz_models"]=false
  ["--enable_mppi_fix"]=false
  ["--enable_rmf"]=false
  ["--force"]=false
)
VERBOSE=$(parse_flag "verbose")
ROS2_DEV=$(parse_flag "install_ros2")
DOWNLOAD_GZ=$(parse_flag "download_gz_models")
MPPI=$(parse_flag "enable_mppi_fix")
RMF=$(parse_flag "enable_rmf")
FORCE=$(parse_flag "force")

# UBUNTU_CODENAME=${parsed_args["ubuntu_codename"]-focal}
# ROSDISTRO=${parsed_args["rosdistro"]-galactic}
WORKSPACE=${parsed_args["workspace"]-ros2_ws}
TOKEN=${parsed_args["token"]-}
ROS_INSTALL_TYPE=${parsed_args["ros_install_type"]:-desktop}

UBUNTU_CODENAME=$(cat /etc/os-release | grep VERSION_CODENAME | cut -d"=" -f2)
if [[ "$UBUNTU_CODENAME" == "focal" ]]; then
  echo "Ubuntu 20.04 detected. Set ROSDISTRO to galactic."
  ROSDISTRO="galactic"
elif [[ "$UBUNTU_CODENAME" == "jammy" ]]; then
  echo "Ubuntu 22.04 detected. Set ROSDISTRO to humble."
  ROSDISTRO="humble"
else
  if [ ! -n $UBUNTU_CODENAME ]; then
    echo "Ubuntu $UBUNTU_CODENAME is not supported"
  else
    echo "No Ubuntu version detected"
  fi
  # exit 1
fi

export UBUNTU_CODENAME ROSDISTRO WORKSPACE TOKEN

print_args() {
  echo ===============================
  echo "UBUNTU_CODENAME: $UBUNTU_CODENAME"
  echo "ROSDISTRO: $ROSDISTRO"
  echo "WORKSPACE: $WORKSPACE"
  echo "ROS_INSTALL_TYPE: $ROS_INSTALL_TYPE"
  echo "ROS2_DEV: $ROS2_DEV"
  echo "DOWNLOAD_GZ: $DOWNLOAD_GZ"
  echo "MPPI: $MPPI"
  echo "RMF: $RMF"
  echo "FORCE: $FORCE"
  echo "TOKEN: $TOKEN"
}

if [ "$VERBOSE" == true ]; then
  print_args
fi
