#!/usr/bin/env bash
script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$script_dir/../../scripts/utils.sh"

filepath="/etc/netplan/50-cloud-init.yaml"

lines=$(cat << EOL
    ethernets:
        eth0:
            dhcp4: false
            addresses: [192.168.1.3/24]
            routes:
              - to: 192.168.1.2/32
                via: 192.168.1.3
        enx7cc2c64a19b7:
            dhcp4: false
            addresses: [192.168.1.12/24]
            routes:
              - to: 192.168.1.4/32
                via: 192.168.1.12
EOL
)

append_content "$filepath" "$contents"
