#!/bin/bash

source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../../scripts/utils.sh"

WORKSPACE="${1:-colcon_ws}"
ROS_DISTRO="${ROS_DISTRO-galactic}"

./simulations_articubot_one/articubot.sh $WORKSPACE
./simulations_tiago/tiago.sh $WORKSPACE
