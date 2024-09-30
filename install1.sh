#!/bin/bash

# Function to display colored animation (spinner) for major steps
spinner() {
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    local color=$1
    tput civis  # Hide cursor
    while [ "$(ps a | awk '{print $1}' | grep "$pid")" ]; do
        local temp=${spinstr#?}
        printf "\e[%sm [%c]  %s\r" "$color" "$spinstr" "$2"
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
    done
    tput cnorm  # Restore cursor
}

# Update the package list
echo -e "\e[34mUpdating package list...\e[0m"
apt update & spinner 34 "Updating package list"
sleep 1  # Wait for 1 second

# Upgrade the installed packages
echo -e "\e[33mUpgrading installed packages...\e[0m"
apt upgrade -y & spinner 33 "Upgrading installed packages"
sleep 1  # Wait for 1 second

# Install sudo and curl
echo -e "\e[32mInstalling sudo and curl...\e[0m"
apt install -y sudo curl & spinner 32 "Installing sudo and curl"
sleep 1  # Wait for 1 second

# Enable IPv4 forwarding
echo -e "\e[36mEnabling IPv4 forwarding...\e[0m"
sudo sysctl -w net.ipv4.ip_forward=1 & spinner 36 "Enabling IPv4 forwarding"
sleep 1  # Wait for 1 second

# Enable IPv6 forwarding
echo -e "\e[35mEnabling IPv6 forwarding...\e[0m"
sudo sysctl -w net.ipv6.conf.all.forwarding=1 & spinner 35 "Enabling IPv6 forwarding"
sleep 1  # Wait for 1 second

# Install Tailscale
echo -e "\e[34mInstalling Tailscale...\e[0m"
curl -fsSL https://tailscale.com/install.sh | sh & spinner 34 "Installing Tailscale"
sleep 1  # Wait for 1 second

# Start Tailscale daemon
echo -e "\e[33mStarting Tailscale daemon...\e[0m"
sudo tailscaled --state=/var/lib/tailscale/tailscaled.state & spinner 33 "Starting Tailscale daemon"
sleep 5  # Wait for 5 seconds

# Install Netbird
echo -e "\e[32mInstalling Netbird...\e[0m"
curl -fsSL https://pkgs.netbird.io/install.sh | sh & spinner 32 "Installing Netbird"
sleep 1  # Wait for 1 second

# Ask to initiate Tailscale
echo -e "\e[36mDo you want to bring up Tailscale? (y/n)\e[0m"
read -r tailscale_choice
if [[ "$tailscale_choice" == "y" ]]; then
    echo -e "\e[34mBringing up Tailscale...\e[0m"
    sudo tailscale up & spinner 34 "Bringing up Tailscale"
    sleep 6  # Wait for 6 seconds
    echo -e "\e[32mTailscale is up!\e[0m"
else
    echo -e "\e[31mSkipped bringing up Tailscale.\e[0m"
fi

# Ask to initiate Netbird
echo -e "\e[36mDo you want to bring up Netbird? (y/n)\e[0m"
read -r netbird_choice
if [[ "$netbird_choice" == "y" ]]; then
    echo -e "\e[34mBringing up Netbird...\e[0m"
    sudo netbird up & spinner 34 "Bringing up Netbird"
    sleep 15  # Wait for 15 seconds to copy Netbird login command
    echo -e "\e[32mNetbird is up!\e[0m"
else
    echo -e "\e[31mSkipped bringing up Netbird.\e[0m"
fi

# Final message with colored output
echo -e "\e[32mAll steps completed successfully!\e[0m"

# Final message and reset color
print_color 32 "All steps completed successfully!"
tput sgr0  # Reset terminal colors to default
