#!/bin/bash

# Translate long options to short options
OPTIONS=u:r:i:a
LONGOPTIONS=UBUNTU_CODENAME:,ROSDISTRO:,ROS_INSTALL_TYPE:,APPEND_SOURCE_SCRIPT_TO_BASHRC

echo
echo "========== usage ==========="
echo "./my_script.sh --UBUNTU_CODENAME=focal  (長選項, 等號)"
echo "./my_script.sh --UBUNTU_CODENAME focal  (長選項, 空格)"
echo "./my_script.sh -u=focal  (短選項, 等號)"
echo "./my_script.sh -u focal  (短選項, 空格)"
echo "./my_script.sh -a (--APPEND_SOURCE_SCRIPT_TO_BASHRC)  (開關選項)"
echo

# Parse command line arguments
PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTIONS --name "$0" -- "$@")
if [[ $? -ne 0 ]]; then
  # parse failed, output error message and exit
  exit 1
fi

# Save the parsed options to an array
eval set -- "$PARSED"
while true; do
  case "$1" in
    -u|--UBUNTU_CODENAME)
      UBUNTU_CODENAME="${2}"
      shift 2
      ;;
    -r|--ROSDISTRO)
      ROSDISTRO="${2}"
      shift 2
      ;;
    -i|--ROS_INSTALL_TYPE)
      ROS_INSTALL_TYPE="${2}"
      shift 2
      ;;
    -a|--APPEND_SOURCE_SCRIPT_TO_BASHRC)
      APPEND_SOURCE_SCRIPT_TO_BASHRC="true"
      shift
      ;;
    --APPEND_SOURCE_SCRIPT_TO_BASHRC)
      APPEND_SOURCE_SCRIPT_TO_BASHRC="true"
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

# Set default values
UBUNTU_CODENAME="${UBUNTU_CODENAME:-focal}"
ROSDISTRO="${ROSDISTRO:-galactic}"
ROS_INSTALL_TYPE="${ROS_INSTALL_TYPE:-desktop}"
APPEND_SOURCE_SCRIPT_TO_BASHRC="${APPEND_SOURCE_SCRIPT_TO_BASHRC:-false}"

# print the parsed options
echo "UBUNTU_CODENAME=$UBUNTU_CODENAME"
echo "ROSDISTRO=$ROSDISTRO"
echo "ROS_INSTALL_TYPE=$ROS_INSTALL_TYPE"
echo "APPEND_SOURCE_SCRIPT_TO_BASHRC=$APPEND_SOURCE_SCRIPT_TO_BASHRC"
