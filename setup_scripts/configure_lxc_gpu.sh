#!/bin/bash

# configure_lxc_gpu.sh
# This script configures the LXC container to pass through NVIDIA GPUs.

# Usage: ./configure_lxc_gpu.sh <container_id>

if [ -z "$1" ]; then
    echo "Usage: $0 <container_id>"
    exit 1
fi

CONTAINER_ID=$1
CONF_FILE="/etc/pve/lxc/${CONTAINER_ID}.conf"

if [ ! -f "$CONF_FILE" ]; then
    echo "Container configuration file ${CONF_FILE} not found."
    exit 1
fi


features: keyctl=1,nesting=1
hostname: docker

# Change memory
# Change cores
# Make it privileged
sudo sed -i 's/memory: 2048/memory: 65536/' $CONF_FILE 
sudo sed -i 's/cores: 2/cores 16/' $CONF_FILE 
sudo sed -i 's/unprivileged: 0/unprivileged: 1/' $CONF_FILE 

# Add cgroup device permissions
echo "lxc.cgroup2.devices.allow: c 195:* rwm" >> "$CONF_FILE"
echo "lxc.cgroup2.devices.allow: c 511:* rwm" >> "$CONF_FILE"

# Add mount entries for NVIDIA devices
for device in /dev/nvidia*; do
    devname=$(basename "$device")
    echo "lxc.mount.entry: ${device} dev/${devname} none bind,optional,create=file" >> "$CONF_FILE"
done

echo "GPU passthrough configuration added to ${CONF_FILE}."
echo "Please reboot the container for changes to take effect."

