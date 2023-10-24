#!/usr/bin/env bash
script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$script_dir/../../scripts/utils.sh"

# copy netplan config file
filepath="/etc/netplan/50-cloud-init.yaml"
sudo cp "$filepath" "$filepath.bak"
sudo cp 50-cloud-init.yaml "$filepath"

# copy cyclonedds config file
cp cyclonedds.xml $HOME
append_bashrc 'export CYCLONEDDS_URI=$HOME/cyclonedds_config.xml'
