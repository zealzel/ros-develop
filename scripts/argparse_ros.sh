#!/bin/bash

function print_usage {
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "OPTIONS:"
  echo "  -u, --UBUNTU_CODENAME  the codename of Ubuntu LTS (focal|jammy) (default: focal)"
  echo "  -r, --ROS_DISTRO        the ROS distribution to install (noetic|galactic|foxy|humble) (default: galactic)"
  echo "  -i, --ROS_INSTALL_TYPE the type of ROS installation (desktop|ros-base) (default: desktop)"
  echo "  -w, --WORKSPACE the workspace to install ROS2 (default: ros2_ws)"
  echo "  -a, --APPEND_SOURCE_SCRIPT_TO_BASHRC"
  echo "                         whether to append the setup script to ~/.bashrc (default: false)"
  echo "  -h, --help             print this help message and exit"
}

function parse_args {
  # 将命令行参数转换为短选项和长选项
  OPTIONS=u:r:i:w:ah
  LONGOPTIONS=UBUNTU_CODENAME:,ROS_DISTRO:,ROS_INSTALL_TYPE:,WORKSPACE:,APPEND_SOURCE_SCRIPT_TO_BASHRC,help

  # 解析命令行参数
  PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTIONS --name "$0" -- "$@")

  if [[ $? -ne 0 ]]; then
    # 解析失败，输出错误信息并退出
    print_usage
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
      -r|--ROS_DISTRO)
        ROS_DISTRO="${2#*=}"
        shift 2
        ;;
      -i|--ROS_INSTALL_TYPE)
        ROS_INSTALL_TYPE="${2#*=}"
        shift 2
        ;;
      -w|--WORKSPACE)
        WORKSPACE="${2#*=}"
        shift 2
        ;;
      -a|--APPEND_SOURCE_SCRIPT_TO_BASHRC)
        APPEND_SOURCE_SCRIPT_TO_BASHRC=true
        shift
        ;;
      -h|--help)
        print_usage
        exit 0
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
      -r|--ROS_DISTRO)
        ROS_DISTRO="$2"
        shift 2
        ;;
      *)
        echo "Unknown argument: $1"
        exit 1
        ;;
    esac
  done

  # 设置默认参数值
  # UBUNTU_CODENAME="${UBUNTU_CODENAME:-focal}"
  UBUNTU_CODENAME="${UBUNTU_CODENAME:-jammy}"
  # ROS_DISTRO="${ROS_DISTRO:-galactic}"
  ROS_DISTRO="${ROS_DISTRO:-humble}"
  ROS_INSTALL_TYPE="${ROS_INSTALL_TYPE:-desktop}"
  WORKSPACE="${WORKSPACE:-ros2_ws}"
  APPEND_SOURCE_SCRIPT_TO_BASHRC="${APPEND_SOURCE_SCRIPT_TO_BASHRC:-false}"
}
