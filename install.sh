#!/bin/bash

# Update the package list
apt update
sleep 5  # Wait for 5 seconds

# Upgrade the installed packages
apt upgrade -y
sleep 5  # Wait for 5 seconds

# Install sudo and curl
apt install -y sudo curl
sleep 5  # Wait for 5 seconds

# Enable IPv4 forwarding
sudo sysctl -w net.ipv4.ip_forward=1
sleep 5  # Wait for 5 seconds

# Enable IPv6 forwarding
sudo sysctl -w net.ipv6.conf.all.forwarding=1
sleep 5  # Wait for 5 seconds

# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh
sleep 5  # Wait for 5 seconds

# Start Tailscale daemon
sudo tailscaled --state=/var/lib/tailscale/tailscaled.state &
sleep 5  # Wait for 5 seconds

# Bring up Tailscale
sudo tailscale up
