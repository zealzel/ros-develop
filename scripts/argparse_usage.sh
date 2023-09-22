#!/bin/bash
source argparser.sh

# 選項描述
declare -A arg_desc=(
  ["-u,--ubuntu-codename"]="Ubuntu codename (default: focal)"
  ["-r,--rosdistro"]="ROS distribution (default: noetic)"
  ["-w,--workspace"]="Workspace name (default: my_ws)"
  ["-a,--appendbashrc"]="append bashrc"
  ["-x,--excludes"]="excluded packages"
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
EXCLUDES=${parsed_args["excludes"]}
IFS=',' read -ra EXCLUDES_ARRAY <<< "$EXCLUDES"

echo "UBUNTU_CODENAME: $UBUNTU_CODENAME"
echo "ROSDISTRO: $ROSDISTRO"
echo "WORKSPACE: $WORKSPACE"
echo "APPENDBASHRC: $APPENDBASHRC"
echo "EXCLUDES: $EXCLUDES"
echo "EXCLUDES_ARRAY: $EXCLUDES_ARRAY"
for ex in "${EXCLUDES_ARRAY[@]}"; do
  echo "$ex"
done
