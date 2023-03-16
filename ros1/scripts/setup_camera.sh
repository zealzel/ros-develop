#!/bin/bash
source env.sh
source utils.sh

echo ===============================================
echo Append start_x=1 into /boot/firmware/config.txt
echo ===============================================
append_config_txt() {
  file="/boot/firmware/config.txt"
  line1="start_x=1"
  echo "line1: $line1"
  idpt-append-sudo "$line1" "$file"
  echo "file: $file"
  echo "configure lines added into $file"
}

append_config_txt
