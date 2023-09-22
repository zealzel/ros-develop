#!/bin/bash
source argparser.sh

# 選項描述
declare -A arg_desc=(
  ["-u,--ubuntu-codename"]="Ubuntu codename (default: focal)"
  ["-r,--rosdistro"]="ROS distribution (default: noetic)"
  ["-w,--workspace"]="Workspace name (default: my_ws)"
  ["-a,--appendbashrc"]="append bashrc"
)

# 用於存儲解析後的參數
declare -A parsed_args

# 解析參數
parse_args "$@"

# 打印使用說明
#print_usage

UBUNTU_CODENAME=${parsed_args["ubuntu_codename"]-focal}
ROSDISTRO=${parsed_args["rosdistro"]-galactic}
WORKSPACE=${parsed_args["workspace"]-ros2_ws}
APPENDBASHRC=${parsed_args["appendbashrc"]-true}

echo "UBUNTU_CODENAME: $UBUNTU_CODENAME"
echo "ROSDISTRO: $ROSDISTRO"
echo "WORKSPACE: $WORKSPACE"
echo "APPENDBASHRC: $APPENDBASHRC"
