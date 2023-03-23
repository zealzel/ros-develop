#!/bin/bash

# Define usage
usage() {
  echo "Usage: $0 [-u|--UBUNTU_CODENAME <ubuntu-codename>] [-r|--ROSDISTRO <ros-distro>] [-i|--ROS_INSTALL_TYPE <ros-install-type>] [-a|--APPEND_SOURCE_SCRIPT_TO_BASHRC]"
  exit 1
}

function parse_args {
  # 将命令行参数转换为短选项和长选项
  OPTIONS=u:r:i:a
  LONGOPTIONS=UBUNTU_CODENAME:,ROSDISTRO:,ROS_INSTALL_TYPE:,APPEND_SOURCE_SCRIPT_TO_BASHRC

  # 解析命令行参数
  PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTIONS --name "$0" -- "$@")

  if [[ $? -ne 0 ]]; then
    # 解析失败，输出错误信息并退出
    exit 1
  fi

  # 将解析后的命令行参数存储到相应的变量中
  eval set -- "$PARSED"
  while true; do
    case "$1" in
      -u|--UBUNTU_CODENAME)
        UBUNTU_CODENAME="${2#*=}"
        shift 2
        ;;
      -r|--ROSDISTRO)
        ROSDISTRO="${2#*=}"
        shift 2
        ;;
      -i|--ROS_INSTALL_TYPE)
        ROS_INSTALL_TYPE="${2#*=}"
        shift 2
        ;;
      -a|--APPEND_SOURCE_SCRIPT_TO_BASHRC)
        APPEND_SOURCE_SCRIPT_TO_BASHRC=true
        shift
        ;;
      --)
        shift
        break
        ;;
      *)
        echo "Unknown option: $1"
        exit 1
        ;;
    esac
  done

  # 处理短选项 + 空格的情况
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -r|--ROSDISTRO)
        ROSDISTRO="$2"
        shift 2
        ;;
      *)
        echo "Unknown argument: $1"
        exit 1
        ;;
    esac
  done

  # 设置默认参数值
  UBUNTU_CODENAME="${UBUNTU_CODENAME:-focal}"
  ROSDISTRO="${ROSDISTRO:-galactic}"
  ROS_INSTALL_TYPE="${ROS_INSTALL_TYPE:-desktop}"
  APPEND_SOURCE_SCRIPT_TO_BASHRC="${APPEND_SOURCE_SCRIPT_TO_BASHRC:-false}"
}
