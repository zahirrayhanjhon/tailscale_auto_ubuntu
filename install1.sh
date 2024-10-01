#!/bin/bash 

# Define colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fun start message with icons
echo -e "${YELLOW}🚀 Starting the installation process... Sit tight! 🚀${NC}"

# Update the package list
echo -e "${BLUE}📦 Updating package list...${NC}"
apt update
sleep 1  # Wait for 1 seconds
echo -e "${GREEN}✅ Package list updated successfully!${NC}"

# Upgrade the installed packages
echo -e "${BLUE}⬆️  Upgrading installed packages...${NC}"
apt upgrade -y
sleep 1  # Wait for 1 seconds
echo -e "${GREEN}✅ Packages upgraded successfully!${NC}"

# Install sudo and curl
echo -e "${BLUE}🔧 Installing sudo and curl...${NC}"
apt install -y sudo curl
sleep 1  # Wait for 1 seconds
echo -e "${GREEN}✅ Sudo and curl installed successfully!${NC}"

# Enable IPv4 forwarding
echo -e "${BLUE}🌐 Enabling IPv4 forwarding...${NC}"
sudo sysctl -w net.ipv4.ip_forward=1
sleep 1  # Wait for 1 seconds
echo -e "${GREEN}✅ IPv4 forwarding enabled!${NC}"

# Enable IPv6 forwarding
echo -e "${BLUE}🌐 Enabling IPv6 forwarding...${NC}"
sudo sysctl -w net.ipv6.conf.all.forwarding=1
sleep 1  # Wait for 1 seconds
echo -e "${GREEN}✅ IPv6 forwarding enabled!${NC}"

# Install Tailscale
echo -e "${BLUE}🌀 Installing Tailscale...${NC}"
curl -fsSL https://tailscale.com/install.sh | sh
sleep 1  # Wait for 1 seconds
echo -e "${GREEN}✅ Tailscale installed successfully!${NC}"

# Start Tailscale daemon
echo -e "${BLUE}🔄 Starting Tailscale daemon...${NC}"
# sudo tailscaled --state=/var/lib/tailscale/tailscaled.state &
echo -e "[Unit]\nDescription=Tailscale Daemon\nAfter=network.target\n\n[Service]\nExecStart=/usr/sbin/tailscaled --state=/var/lib/tailscale/tailscaled.state\nRestart=on-failure\n\n[Install]\nWantedBy=multi-user.target" | sudo tee /etc/systemd/system/tailscale.service && sudo systemctl enable tailscale.service && sudo systemctl start tailscale.service
sleep 5  # Wait for 5 seconds
echo -e "${GREEN}✅ Tailscale daemon started!${NC}"

# Install Netbird
echo -e "${BLUE}🕊️  Installing Netbird...${NC}"
curl -fsSL https://pkgs.netbird.io/install.sh | sh
sleep 1  # Wait for 1 seconds
echo -e "${GREEN}✅ Netbird installed successfully!${NC}"

# Completion message
echo -e "${YELLOW}🎉 Installation completed successfully! 🎉${NC}"

# Define colors
WHITE='\033[0;37m'  # White color for normal text
GOLD='\033[1;33m'   # Golden/yellow color for the commands
NC='\033[0m'        # No Color (reset)

sleep 1  # Wait for 1 seconds
for i in {1..3}; do echo ""; done
sleep 1  # Wait for 1 seconds

# Print ZRAYHAN in large text using asterisks and some emojis
echo -e " "
echo -e "@@@@@@@@  @@@@@@@    @@@@@@   @@@ @@@  @@@  @@@   @@@@@@   @@@  @@@  "
echo -e "@@@@@@@@  @@@@@@@@  @@@@@@@@  @@@ @@@  @@@  @@@  @@@@@@@@  @@@@ @@@  "
echo -e "     @@!  @@!  @@@  @@!  @@@  @@! !@@  @@!  @@@  @@!  @@@  @@!@!@@@  "
echo -e "    !@!   !@!  @!@  !@!  @!@  !@! @!!  !@!  @!@  !@!  @!@  !@!!@!@!  "
echo -e "   @!!    @!@!!@!   @!@!@!@!   !@!@!   @!@!@!@!  @!@!@!@!  @!@ !!@!  "
echo -e "  !!!     !!@!@!    !!!@!!!!    @!!!   !!!@!!!!  !!!@!!!!  !@!  !!!  "
echo -e " !!:      !!: :!!   !!:  !!!    !!:    !!:  !!!  !!:  !!!  !!:  !!!  "
echo -e ":!:       :!:  !:!  :!:  !:!    :!:    :!:  !:!  :!:  !:!  :!:  !:!  "
echo -e " :: ::::  ::   :::  ::   :::     ::    ::   :::  ::   :::   ::   ::  "
echo -e ": :: : :   :   : :   :   : :     :      :   : :   :   : :  ::    :   "
echo -e " "
sleep 1  # Wait for 1 seconds
for i in {1..3}; do echo ""; done
sleep 1  # Wait for 1 seconds

# Instructions to run Tailscale and Netbird
echo -e "${WHITE}To connect using Tailscale, run: ${GOLD}sudo tailscale up${NC}"
echo -e "${WHITE}To connect using Netbird, run: ${GOLD}sudo netbird up${NC}"
sleep 1  # Wait for 1 seconds
for i in {1..3}; do echo ""; done
sleep 1  # Wait for 1 seconds
echo -e "${WHITE}   ${NC}"
