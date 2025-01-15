#!/bin/bash

# Script to install Oh My Zsh
# Checks for Zsh installation and installs it if necessary

# Function to check if Zsh is installed
check_zsh() {
    if ! command -v zsh &> /dev/null; then
        echo "Zsh is not installed. Installing Zsh..."
        sudo apt update || { echo "Failed to update package lists. Exiting."; exit 1; }
        sudo apt install -y zsh || { echo "Failed to install Zsh. Exiting."; exit 1; }
    else
        echo "Zsh is already installed."
    fi
}

# Function to install Oh My Zsh
install_oh_my_zsh() {
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || { echo "Failed to install Oh My Zsh. Exiting."; exit 1; }
}

# Main script execution
main() {
    check_zsh
    install_oh_my_zsh
    echo "Oh My Zsh installation completed successfully!"
}

main

