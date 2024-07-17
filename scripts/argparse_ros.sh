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
  ["-v,--verbose"]="verbose (flag)"
  ["-h,--help"]="help"
)

# 用於存儲解析後的參數
declare -A parsed_args

# 解析參數
parse_args "$@"

declare -A default_flags=(
  ["--verbose"]=false
)
VERBOSE=$(parse_flag "verbose")

# UBUNTU_CODENAME=${parsed_args["ubuntu_codename"]-focal}
# ROSDISTRO=${parsed_args["rosdistro"]-galactic}
WORKSPACE=${parsed_args["workspace"]-ros2_ws}
TOKEN=${parsed_args["token"]-}
ROS_INSTALL_TYPE=${parsed_args["ros_install_type"]:-desktop}

UBUNTU_CODENAME=$(cat /etc/os-release |grep VERSION_CODENAME|cut -d"=" -f2)
if [[ "$UBUNTU_CODENAME" == "focal" ]]; then
  echo "Ubuntu 20.04 detected. Set ROSDISTRO to galactic."
  ROSDISTRO="galactic"
elif [[ "$UBUNTU_CODENAME" == "jammy" ]]; then
  echo "Ubuntu 22.04 detected. Set ROSDISTRO to humble."
  ROSDISTRO="humble"
else
  echo "Ubuntu $UBUNTU_CODENAME is not supported"
  exit 1
fi

export UBUNTU_CODENAME ROS_DISTRO WORKSPACE TOKEN


print_args() {
  echo ===============================
  echo "UBUNTU_CODENAME: $UBUNTU_CODENAME"
  echo "ROSDISTRO: $ROSDISTRO"
  echo "WORKSPACE: $WORKSPACE"
  echo "ROS_INSTALL_TYPE: $ROS_INSTALL_TYPE"
  echo "TOKEN: $TOKEN"
}

if [ "$VERBOSE" == true ]; then
  print_args
fi
