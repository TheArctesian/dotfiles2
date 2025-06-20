#!/bin/bash

# Set colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting dotfiles setup...${NC}"

# Function to create backup of existing configs
backup_config() {
    local config_path="$HOME/.config/$1"
    if [ -d "$config_path" ] || [ -f "$config_path" ]; then
        echo -e "${YELLOW}Backing up existing $1 config...${NC}"
        mv "$config_path" "$config_path.bak.$(date +%Y%m%d%H%M%S)"
    fi
}

# Function to copy configurations
copy_config() {
    local source="$PWD/$1"
    local target="$HOME/.config/$1"
    
    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$target")"
    
    # Copy the configuration
    echo -e "${GREEN}Copying $1 config...${NC}"
    if [ -d "$source" ]; then
        cp -r "$source" "$(dirname "$target")"
    else
        cp "$source" "$target"
    fi
}

# Install NixOS configuration if we're on NixOS
if [ -d "/etc/nixos" ]; then
    echo -e "${GREEN}NixOS detected, setting up system configuration...${NC}"
    
    # Check if nixos directory exists in our repo
    if [ -d "$PWD/nixos" ]; then
        echo -e "${YELLOW}Backing up existing NixOS config...${NC}"
        sudo cp -r /etc/nixos /etc/nixos.bak.$(date +%Y%m%d%H%M%S)
        
        echo -e "${GREEN}Copying NixOS configuration...${NC}"
        sudo cp -r "$PWD/nixos"/* /etc/nixos/
        
        echo -e "${YELLOW}Would you like to rebuild NixOS now? (y/n)${NC}"
        read -r answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            echo -e "${GREEN}Rebuilding NixOS...${NC}"
            sudo nixos-rebuild switch
        else
            echo -e "${YELLOW}Skipping NixOS rebuild. Remember to run 'sudo nixos-rebuild switch' later.${NC}"
        fi
    else
        echo -e "${RED}No nixos directory found in the repository. Skipping NixOS configuration.${NC}"
    fi
fi

# List of configs to copy
configs=(
    "alacritty"
    "bspwm"
    "sxhkd"
    "polybar"
    "rofi"
    "dunst"
    "picom"
    "fish"
    "ghostty"
    "gtk-3.0"
    "Kvantum"
    "qt5ct"
    "nvim"
    "btop"
    "neofetch"
    "ncspot"
    "greenclip.toml"
)

# Backup and copy configurations
for config in "${configs[@]}"; do
    backup_config "$config"
    copy_config "$config"
done

# Make scripts executable if the directory exists
if [ -d "$HOME/.config/scripts" ]; then
    echo -e "${GREEN}Making scripts executable...${NC}"
    find "$HOME/.config/scripts" -type f -name "*.sh" -exec chmod +x {} \;
fi

echo -e "${GREEN}Setup complete!${NC}"
echo -e "${YELLOW}Note: Some changes may require logging out and back in to take effect.${NC}"
