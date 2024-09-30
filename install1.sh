#!/bin/bash

# Function to display colored messages
print_color() {
    local color=$1
    local message=$2
    echo -e "\e[${color}m${message}\e[0m"
}

# Function to add sleep with a spinner
spinner_sleep() {
    local seconds=$1
    local message=$2
    local color=$3
    tput civis  # Hide cursor
    for ((i=0; i<$seconds; i++)); do
        printf "\e[%sm [%c] %s\r" "$color" "${SPIN:$i%${#SPIN}:1}" "$message"
        sleep 1
    done
    tput cnorm  # Restore cursor
    echo -e "\e[${color}m${message}... Done!\e[0m"
}

SPIN='|/-\'

# Update the package list
print_color 34 "Updating package list..."
apt update > /dev/null 2>&1 &
spinner_sleep 3 "Updating package list" 34

# Upgrade the installed packages
print_color 33 "Upgrading installed packages..."
apt upgrade -y > /dev/null 2>&1 &
spinner_sleep 3 "Upgrading installed packages" 33

# Install sudo and curl
print_color 32 "Installing sudo and curl..."
apt install -y sudo curl > /dev/null 2>&1 &
spinner_sleep 3 "Installing sudo and curl" 32

# Enable IPv4 forwarding
print_color 36 "Enabling IPv4 forwarding..."
sudo sysctl -w net.ipv4.ip_forward=1 > /dev/null 2>&1 &
spinner_sleep 3 "Enabling IPv4 forwarding" 36

# Enable IPv6 forwarding
print_color 35 "Enabling IPv6 forwarding..."
sudo sysctl -w net.ipv6.conf.all.forwarding=1 > /dev/null 2>&1 &
spinner_sleep 3 "Enabling IPv6 forwarding" 35

# Install Tailscale
print_color 34 "Installing Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh > /dev/null 2>&1 &
spinner_sleep 3 "Installing Tailscale" 34

# Start Tailscale daemon
print_color 33 "Starting Tailscale daemon..."
sudo tailscaled --state=/var/lib/tailscale/tailscaled.state > /dev/null 2>&1 &
spinner_sleep 5 "Starting Tailscale daemon" 33

# Install Netbird
print_color 32 "Installing Netbird..."
curl -fsSL https://pkgs.netbird.io/install.sh | sh > /dev/null 2>&1 &
spinner_sleep 3 "Installing Netbird" 32

# Ask to initiate Tailscale
print_color 36 "Do you want to bring up Tailscale? (y/n)"
read -r tailscale_choice
if [[ "$tailscale_choice" == "y" ]]; then
    print_color 34 "Bringing up Tailscale..."
    sudo tailscale up > /dev/null 2>&1 &
    spinner_sleep 6 "Bringing up Tailscale" 34
    print_color 32 "Tailscale is up!"
else
    print_color 31 "Skipped bringing up Tailscale."
fi

# Ask to initiate Netbird
print_color 36 "Do you want to bring up Netbird? (y/n)"
read -r netbird_choice
if [[ "$netbird_choice" == "y" ]]; then
    print_color 34 "Bringing up Netbird..."
    sudo netbird up > /dev/null 2>&1 &
    spinner_sleep 6 "Bringing up Netbird" 34
    print_color 32 "Netbird is up!"
else
    print_color 31 "Skipped bringing up Netbird."
fi

# Final message and reset color
print_color 32 "All steps completed successfully!"
tput sgr0  # Reset terminal colors to default
