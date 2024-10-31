#!/bin/bash

# setup_proxmox.sh
# This script sets up NVIDIA drivers and NVIDIA container toolkit on the Proxmox host.

# Update package lists
apt update

# Install Proxmox VE headers
apt install -y pve-headers-$(uname -r)



# Install necessary packages
apt install -y dirmngr ca-certificates software-properties-common apt-transport-https dkms curl


apt install -y nvim git btop

# Add NVIDIA package repository GPG key
curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/3bf863cc.pub | \
gpg --dearmor -o /usr/share/keyrings/nvidia-drivers.gpg

# Add NVIDIA package repository
echo 'deb [signed-by=/usr/share/keyrings/nvidia-drivers.gpg] https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/ /' | \
tee /etc/apt/sources.list.d/nvidia-drivers.list

# Update package lists again
apt update

# Install NVIDIA drivers and utilities
apt install -y nvidia-driver cuda nvidia-smi nvidia-settings nvtop

# Install NVIDIA container toolkit
apt install -y nvidia-container-toolkit

# Configure NVIDIA container toolkit for Docker runtime
nvidia-ctk runtime configure --runtime=docker

# Reboot the system
echo "Installation complete. The system will reboot now."
reboot

