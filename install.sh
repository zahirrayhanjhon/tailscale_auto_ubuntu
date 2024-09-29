#!/bin/bash

# Update the package list
apt update
sleep 1  # Wait for 1 seconds

# Upgrade the installed packages
apt upgrade -y
sleep 1  # Wait for 1 seconds

# Install sudo and curl
apt install -y sudo curl
sleep 1  # Wait for 1 seconds

# Enable IPv4 forwarding
sudo sysctl -w net.ipv4.ip_forward=1
sleep 1  # Wait for 1 seconds

# Enable IPv6 forwarding
sudo sysctl -w net.ipv6.conf.all.forwarding=1
sleep 1  # Wait for 1 seconds

# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh
sleep 1  # Wait for 1 seconds

# Start Tailscale daemon
sudo tailscaled --state=/var/lib/tailscale/tailscaled.state &
sleep 1  # Wait for 1 seconds

# Install Netbird
curl -fsSL https://pkgs.netbird.io/install.sh | sh
sleep 1  # Wait for 1 seconds 

# Bring up Tailscale
sudo tailscale up
sleep 3  # Wait for 3 seconds

# Bring up Netbird
sudo netbird up
sleep 15  # Wait for 15 seconds to copy Netbird login command
