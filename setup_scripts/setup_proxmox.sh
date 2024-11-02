#!/bin/bash

# setup_proxmox.sh
# This script sets up NVIDIA drivers and NVIDIA container toolkit on the Proxmox host.
bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/post-pve-install.sh)"
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet amd_iommu=on"/' /etc/default/grub
update-grub

# Update package lists
apt update && apt upgrade

# Install tools
apt install -y neovim git btop tmux lshw lm-sensors
sensors-detect

# Install Proxmox VE headers
apt install -y build-essential dkms pve-headers-$(uname -r)

apt update && apt upgrade

# Install necessary packages
apt install -y dirmngr ca-certificates software-properties-common apt-transport-https dkms curl

git clone git@github.com:jamster/proxmox-beast.git
# cat /etc/apt/preferences.d/nvidia-pin > ~/proxmox-beast/setup_scripts/nvidia-pin
cat setup_scripts/nvidia-pin > /etc/apt/preferences.d/nvidia-pin

echo "blacklist nouveau" >> /etc/modprobe.d/blacklist-nouveau.conf
echo "options nouveau modeset=0" >> /etc/modprobe.d/blacklist-nouveau.conf
update-initramfs -u
apt update && apt upgrade

reboot



# Add NVIDIA package repository GPG key
curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/3bf863cc.pub | gpg --dearmor -o /usr/share/keyrings/nvidia-drivers.gpg

# Add NVIDIA package repository
echo 'deb [signed-by=/usr/share/keyrings/nvidia-drivers.gpg] https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/ /' | tee /etc/apt/sources.list.d/nvidia-drivers.list

# Update package lists again
apt update

# This is more important than the next PLEASE READ, so do this for now:
wget https://developer.download.nvidia.com/compute/cuda/12.6.2/local_installers/cuda_12.6.2_560.35.03_linux.run
wget  https://us.download.nvidia.com/XFree86/Linux-x86_64/550.127.05/NVIDIA-Linux-x86_64-550.127.05.run
chmod +x NVIDIA-Linux-x86_64-550.127.05.run 
./NVIDIA-Linux-x86_64-550.127.05.run 
chmod +x cuda_12.6.2_560.35.03_linux.run 
./cuda_12.6.2_560.35.03_linux.run 



#### PLEASE READ ######
# 2024/10/30
# Looks like nvidia updated half their packages (i don't even know what that means)
# Someone has a solution here:
# https://forums.developer.nvidia.com/t/missing-packages-in-compute-cuda-repos-debian12-apt-repo/311742/4


# Install NVIDIA drivers and utilities
apt install -y nvidia-driver=560.35.03-1
apt install -y cuda nvidia-smi nvidia-settings 
apt install -y nvtop

# Install NVIDIA container toolkit
apt install -y nvidia-container-toolkit

# Configure NVIDIA container toolkit for Docker runtime
nvidia-ctk runtime configure --runtime=docker

# Reboot the system
echo "Installation complete. The system will reboot now."
reboot

