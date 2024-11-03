#!/bin/bash

# bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/docker.sh)"
# setup_docker_lxc.sh
# This script sets up NVIDIA drivers and NVIDIA container toolkit inside the Docker LXC container.

# Update and upgrade packages
sudo apt update -y && sudo apt upgrade -y
apt install -y neovim git btop tmux lshw 

# Install necessary packages
sudo apt install -y gpg nvtop glances git dirmngr ca-certificates software-properties-common apt-transport-https dkms curl

# Add NVIDIA package repository GPG key
curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/3bf863cc.pub | \
sudo gpg --dearmor -o /usr/share/keyrings/nvidia-drivers.gpg

# Add NVIDIA package repository
echo 'deb [signed-by=/usr/share/keyrings/nvidia-drivers.gpg] https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/ /' | \
sudo tee /etc/apt/sources.list.d/nvidia-drivers.list

# Update package lists
sudo apt update

# Install NVIDIA drivers and utilities
sudo apt install -y nvidia-driver nvidia-cuda-driver  nvidia-settings

# Install NVIDIA container toolkit
sudo apt install -y nvidia-container-toolkit

# Configure NVIDIA container toolkit for Docker runtime
sudo nvidia-ctk runtime configure --runtime=docker

# Modify /etc/nvidia-container-runtime/config.toml
sudo sed -i 's/#no-cgroups = false/no-cgroups = true/' /etc/nvidia-container-runtime/config.toml

# Reboot the system
echo "Installation complete. The container will reboot now."
sudo reboot
