#!/bin/bash

# Download the nvim.appimage from the neovim GitHub releases
wget https://github.com/neovim/neovim/releases/download/stable/nvim.appimage

# Check if the download was successful
if [[ ! -f "nvim.appimage" ]]; then
    echo "Error: Failed to download nvim.appimage"
    exit 1
fi

# Make the appimage executable and extract it
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract

rm nvim.appimage

# Move the nvim binary to the desired location
sudo mv squashfs-root/usr/bin/nvim .squashfs-root/usr/bin/nvim

# Define the path to the nvim binary
NVIM_PATH="$(pwd)/.squashfs-root/usr/bin/nvim"

# Check if the nvim binary exists at the specified path
if [[ ! -f "$NVIM_PATH" ]]; then
    echo "Error: nvim binary not found at $NVIM_PATH"
    exit 1
fi

# Add the directory to the PATH in ~/.bashrc if it's not already there
if ! grep -q "$NVIM_PATH" ~/.bashrc; then
    echo "export PATH=\$PATH:$(dirname $NVIM_PATH)" >> ~/.bashrc
    echo "alias nvim='$(dirname $NVIM_PATH)'" >> ~/.bashrc
    echo "Added nvim path to ~/.bashrc"
fi

# Create a symbolic link in /usr/local/bin
sudo ln -sf "$NVIM_PATH" /usr/local/bin/nvim
echo "Created symbolic link in /usr/local/bin/nvim"


# Inform the user to source ~/.bashrc or open a new terminal
echo "Please source ~/.bashrc or open a new terminal to use nvim command."
