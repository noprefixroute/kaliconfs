#!/bin/bash

# Ensure Neovim is installed using yay
if ! command -v nvim &> /dev/null; then
    echo "Neovim is not installed. Installing Neovim..."
    yay -S --noconfirm neovim yazi || { echo "Failed to install Neovim. Exiting."; exit 1; }
fi

# Check if .config/nvim exists and move it to .bak before cloning a new one
if [ -d "$HOME/.config/nvim" ]; then
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak" || { echo "Failed to move existing nvim directory. Exiting."; exit 1; }
fi

# Clone your fork of NormalNvim
git clone https://github.com/identityapproved/NormalNvim.git "$HOME/.config/nvim" || { echo "Failed to clone NormalNvim. Exiting."; exit 1; }

# Change to the specified branch
cd "$HOME/.config/nvim" || { echo "Failed to change directory. Exiting."; exit 1; }
git checkout identityapproved\'s || { echo "Failed to switch to branch 'identityapproved's'. Exiting."; exit 1; }

# Run Neovim
nvim

