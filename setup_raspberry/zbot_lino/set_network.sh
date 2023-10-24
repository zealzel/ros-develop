#!/usr/bin/env bash

filepath="/etc/netplan/50-cloud-init.yaml"
sudo cp "$filepath" "$filepath.bak"
sudo cp 50-cloud-init.yaml "$filepath"
