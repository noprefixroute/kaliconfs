#!/bin/bash

# Script to install Neovim and configure it with NvChad on Kali Linux
# Ensure the script is run with proper permissions (sudo if required)

# Function: Print usage
print_usage() {
    echo "Usage: $0 [-v] [-h]"
    echo "Options:"
    echo "  -v  Enable verbose output"
    echo "  -h  Display this help message"
}

# Variables
VERBOSE=false
NEOVIM_CONFIG_DIR="$HOME/.config/nvim"
NEOVIM_STATE_DIR="$HOME/.local/state/nvim"
NEOVIM_SHARE_DIR="$HOME/.local/share/nvim"
NVCHAD_REPO="https://github.com/NvChad/starter"

# Function: Log messages if verbose mode is enabled
log() {
    if [ "$VERBOSE" = true ]; then
        echo "$@"
    fi
}

# Parse options
while getopts "vh" opt; do
    case $opt in
        v) VERBOSE=true ;;
        h) print_usage; exit 0 ;;
        *) print_usage; exit 1 ;;
    esac
done

# Function: Install required packages
install_prerequisites() {
    log "Updating package lists..."
    sudo apt update || { echo "Failed to update package lists. Exiting."; exit 1; }
    
    log "Installing prerequisites: Neovim, Git, Nerd Fonts, and Ripgrep..."
    sudo apt install -y neovim git fonts-jetbrains-mono ripgrep build-essential || { echo "Failed to install prerequisites. Exiting."; exit 1; }
}

# Function: Backup and clean old Neovim configuration
backup_and_clean() {
    log "Backing up and removing old Neovim directories..."
    for dir in "$NEOVIM_CONFIG_DIR" "$NEOVIM_STATE_DIR" "$NEOVIM_SHARE_DIR"; do
        if [ -d "$dir" ]; then
            mv "$dir" "${dir}.bak.$(date +%s)" || { echo "Failed to backup $dir. Exiting."; exit 1; }
        fi
    done
}

# Function: Clone NvChad configuration
clone_nvchad() {
    log "Cloning NvChad configuration from $NVCHAD_REPO..."
    git clone "$NVCHAD_REPO" "$NEOVIM_CONFIG_DIR" || { echo "Failed to clone NvChad. Exiting."; exit 1; }
}

# Function: Finalize setup
finalize_setup() {
    log "Running Neovim to initialize plugins..."
    nvim --headless +Lazy! sync +qall || { echo "Failed to initialize Neovim plugins. Exiting."; exit 1; }
    
    log "Deleting .git folder from NvChad configuration..."
    rm -rf "$NEOVIM_CONFIG_DIR/.git" || { echo "Failed to remove .git folder. Exiting."; exit 1; }
}

# Main script execution
main() {
    log "Starting installation and configuration process..."
    
    install_prerequisites
    backup_and_clean
    clone_nvchad
    finalize_setup
    
    echo "Installation and configuration of NvChad completed successfully!"
    echo "To customize NvChad, run :h nvui in Neovim."
}

# Execute main function
main

