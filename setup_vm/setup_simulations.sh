#!/bin/bash
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../scripts/utils.sh"

WORKSPACE="${1:-simulations}"
ROS_DISTRO="${ROS_DISTRO-galactic}"

./simulations_turtlebot3/turtlebot3.sh

./simulations_articubot_one/articubot.sh $WORKSPACE
./simulations_tiago/tiago.sh $WORKSPACE

rm -f $WORKSPACE/*.repos
rm -f $WORKSPACE/*.rosinstall
