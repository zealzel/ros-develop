#!/bin/bash
WORKSPACE="${1:-simulations}"

if [[ -d "$HOME/$WORKSPACE" ]]; then
  echo "$HOME/$WORKSPACE exist"
else
  echo "$HOME/$WORKSPACE does not exist"
  exit
fi

TARGET_SCRIPT_ABSOLUTE_PATH="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/../install_from_source.sh")"
"${TARGET_SCRIPT_ABSOLUTE_PATH}" $WORKSPACE "false" "simulations_zbot_artic/zbot_artic.repos"
