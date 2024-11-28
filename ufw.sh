#!/bin/bash

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Update package list
apt update

# Install UFW if it's not already installed
apt install -y ufw

# Disable ufw if it's enabled
ufw disable

# Reset all firewall rules
ufw --force reset

# Set firewall rules
# Set default policies
ufw default deny incoming
ufw default allow outgoing

ufw limit 22/tcp

# Allow HTTP (port 80) and HTTPS (port 443) from any IP address
ufw allow 80/tcp
ufw allow 443/tcp

# Allow SSH (port 22) with limit to prevent brute-force attacks
ufw limit ssh

# Allow DNS (port 53) from any IP address
ufw allow dns

# Allow NTP (port 123) from any IP address
ufw allow ntp

# Enable UFW
ufw enable

# Show UFW status
ufw status verbose
