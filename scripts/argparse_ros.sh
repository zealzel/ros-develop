#!/bin/bash

function parse_args() {
  # Translate long options to short options
  OPTIONS=r:i:u:a
  LONGOPTIONS=ROSDISTRO:,ROS_INSTALL_TYPE:,UBUNTU_CODENAME:,APPEND_SOURCE_SCRIPT_TO_BASHRC

  # Parse command line arguments
  PARSED=$(getopt --options="$OPTIONS" --longoptions="$LONGOPTIONS" --name "$0" -- "$@")
  if [[ $? -ne 0 ]]; then
    # parse failed, output error message and exit
    exit 1
  fi

  # Save the parsed options to an array
  eval set -- "$PARSED"
  while true; do
    case "$1" in
      -u | --UBUNTU_CODENAME)
        UBUNTU_CODENAME="$2"
        shift 2
        ;;
      -r | --ROSDISTRO)
        ROSDISTRO="$2"
        shift 2
        ;;
      -i | --ROS_INSTALL_TYPE)
        ROS_INSTALL_TYPE="$2"
        shift 2
        ;;
      -a | --APPEND_SOURCE_SCRIPT_TO_BASHRC)
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
}
