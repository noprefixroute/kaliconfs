#!/bin/bash

# Function to determine the running shell and source the appropriate configuration file
source_shell_config() {
    case "$SHELL" in
        */bash)
            echo "Sourcing ~/.bashrc"
            source ~/.bashrc
            ;;
        */zsh)
            echo "Sourcing ~/.zshrc"
            source ~/.zshrc
            ;;
        */fish)
            echo "Sourcing ~/.config/fish/config.fish"
            source ~/.config/fish/config.fish
            ;;
        *)
            echo "Unknown shell. Please source the appropriate shell config manually."
            ;;
    esac
}

# Detect if running in Zsh or Bash
# SHELL_NAME=$(basename "$SHELL")

# Install Neovim, Go, and other dependencies via apt-get
sudo apt-get update

# Replace non-existing packages with correct names or omit them
sudo apt-get install luarocks python3-pytest delta rustc gcc binutils java-common nasm r-base golang python3 ruby perl lua5.3 elixir make doxygen python3-pip pipx

# Install FNM for NodeJS management
if ! command -v fnm &> /dev/null; then
    echo "Installing FNM..."
    curl -fsSL https://fnm.vercel.app/install | bash
    source ~/.bashrc # || source ~/.zshrc
fi

npm install -g yarn typescript sass live-server

# Use FNM to install NodeJS and npm
# fnm install --lts

# Installing Rust
# Check if Rust is installed; if not, install Rust
if ! command -v cargo &> /dev/null; then
    echo "Rust is not installed. Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"  # Load Rust environment
fi

# Check if Neovim config exists and back it up
if [ -d "$HOME/.config/nvim" ]; then
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
fi

# Clone NormalNvim repository
git clone https://github.com/identityapproved/NormalNvim.git "$HOME/.config/nvim" || { echo "Failed to clone NormalNvim. Exiting."; exit 1; }

# Switch to the correct branch
cd "$HOME/.config/nvim" || { echo "Failed to change directory. Exiting."; exit 1; }
git checkout "identityapproved's" || { echo "Failed to switch to branch 'identityapproved's'. Exiting."; exit 1; }

# Install required packages using pip and yarn
pip install --break-system-packages pyinstaller nuitka
yarn global add jest jsdoc typedoc

# Install yazi with cargo if Rust is installed
if command -v cargo &> /dev/null; then
    cargo install --locked yazi-fm yazi-cli
else
    echo "Rust is not installed. Skipping yazi installation."
fi

# Install godoc for Go
if command -v go &> /dev/null; then
    go install golang.org/x/tools/cmd/godoc@latest
else
    echo "Go is not installed. Skipping godoc installation."
fi

# Final message
echo "All dependencies installed successfully."

# Run Neovim
nvim
