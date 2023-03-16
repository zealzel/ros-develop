#!/bin/bash

catkin_init() {
  CATKIN_ROOT="$1"
  CATKIN_SRC_SPACE="$CATKIN_ROOT/src"
  cd && mkdir -p "$CATKIN_SRC_SPACE"
  cd "$CATKIN_ROOT" && source /opt/ros/noetic/setup.bash && catkin init
}
