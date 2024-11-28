#!/bin/bash

CONFIG_DIR="$HOME/.config"

# Get the current directory
DOTFILES_DIR=$(pwd)

# Check if the script is being run from the dotfiles directory
if [ "$(basename "$DOTFILES_DIR")" != "dotfiles" ]; then
    # Prompt the user for the path to dotfiles
    echo -n "Enter the full path to your dotfiles directory (or press Enter to use the current directory): "
    read -r DOTFILES_DIR
fi

# Check if the dotfiles directory exists
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Error: Dotfiles directory not found."
    exit 1
fi

# Get a list of subdirectories in the dotfiles directory
dotfiles_dirs=$(find "$DOTFILES_DIR" -type d -maxdepth 1 -mindepth 1 | grep -v "^\.")

# Check if there are any subdirectories
if [ -z "$dotfiles_dirs" ]; then
    echo "Error: No subdirectories found in the dotfiles directory."
    exit 1
fi

# Display the available subdirectories
echo "Available directories inside $DOTFILES_DIR:"
while read -r dir; do
    echo "- $((i+1)) - $(basename "$dir")"
    ((i++))
done < <(printf "%s\n" "$dotfiles_dirs")

# Prompt the user for the numbers of the directories to link
read -p "Enter the numbers of the directories you want to link, separated by commas (e.g. '1,2,4-6'), or press Enter to exit: " selected_dirs

# Parse the selected directories
selected_dirs=($(echo "$selected_dirs" | tr ',' ' '))
for (( i=0; i<${#selected_dirs[@]}; ++i )); do
    if [[ ${selected_dirs[i]} =~ ^([0-9]+)-([0-9]+)$ ]]; then
        start=${BASH_REMATCH[1]}
        end=${BASH_REMATCH[2]}
        for (( j=start; j<=end; ++j )); do
            selected_dirs+=("$j")
        done
        unset selected_dirs[i]
    fi
done

# Check if any selected directories are invalid
for dir in "${selected_dirs[@]}"; do
    if [[ ! "$dir" =~ ^[0-9]+$ ]]; then
        echo "Error: Invalid input: $dir"
        exit 1
    fi
done

# Create symlinks
for dir in "${selected_dirs[@]}"; do
    if [[ "$dir" -gt 0 && "$dir" -le ${#dotfiles_dirs[@]} ]]; then
        target_dir=$(find "$DOTFILES_DIR" -type d -maxdepth 1 -mindepth 1 -printf "%f\n" | awk "NR==$dir")
        ln -sfn "$DOTFILES_DIR/$target_dir" "$CONFIG_DIR/$target_dir"
        echo "Created symlink to $DOTFILES_DIR/$target_dir at $CONFIG_DIR/$target_dir"
    else
        echo "Error: Invalid directory number: $dir"
        exit 1
    fi
done

echo "Symbolic links created successfully."
