#!/bin/bash

# Set colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting NixOS configuration integration...${NC}"

# Check if we're running on NixOS
if [ ! -d "/etc/nixos" ]; then
    echo -e "${RED}This script must be run on a NixOS system.${NC}"
    exit 1
fi

# Create backup of existing NixOS config
echo -e "${YELLOW}Creating backup of existing NixOS configuration...${NC}"
BACKUP_DIR="/etc/nixos.backup.$(date +%Y%m%d%H%M%S)"
sudo cp -r /etc/nixos "$BACKUP_DIR"
echo -e "${GREEN}Backup created at $BACKUP_DIR${NC}"

# Copy modular configuration files
REPO_DIR="$PWD/nixos"
if [ ! -d "$REPO_DIR" ]; then
    echo -e "${RED}No nixos directory found in the current path.${NC}"
    exit 1
fi

echo -e "${BLUE}Copying module files to /etc/nixos...${NC}"

# Create packages directory
sudo mkdir -p /etc/nixos/packages

# Copy all modules except boot.nix, networking.nix, users.nix, and configuration.nix
for file in "$REPO_DIR"/*.nix; do
    filename=$(basename "$file")
    if [[ "$filename" != "boot.nix" && "$filename" != "networking.nix" && 
          "$filename" != "users.nix" && "$filename" != "configuration.nix" && 
          "$filename" != "hardware-configuration.nix" ]]; then
        echo -e "${GREEN}Copying $filename...${NC}"
        sudo cp "$file" /etc/nixos/
    fi
done

# Copy packages directory
echo -e "${GREEN}Copying packages directory...${NC}"
sudo cp -r "$REPO_DIR/packages"/* /etc/nixos/packages/

# Create new configuration.nix that integrates both approaches
echo -e "${BLUE}Creating integrated configuration.nix...${NC}"

cat << 'EOF' | sudo tee /etc/nixos/configuration.nix > /dev/null
# /etc/nixos/configuration.nix
# Integrated configuration from Calamares installer and modular dotfiles
{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan
    ./hardware-configuration.nix
    
    # Import modular configurations
    ./desktop.nix
    ./audio.nix
    ./packages/default.nix
    ./appearance.nix
    ./services.nix
    
    # We don't import these as they conflict with Calamares settings
    # ./boot.nix
    # ./networking.nix
    # ./users.nix
  ];

  # Bootloader configuration from Calamares
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.enableCryptodisk = true;

  # LUKS encryption configuration from Calamares
  boot.initrd.luks.devices."luks-ef2f0619-39d3-4e76-90bc-dbc48e82d90e".device = 
    "/dev/disk/by-uuid/ef2f0619-39d3-4e76-90bc-dbc48e82d90e";
  
  # Setup keyfile
  boot.initrd.secrets = { 
    "/boot/crypto_keyfile.bin" = null;
  };

  boot.initrd.luks.devices."luks-c9b47fe3-360e-46f0-bdf7-fe68a641c06c".keyFile = "/boot/crypto_keyfile.bin";
  boot.initrd.luks.devices."luks-ef2f0619-39d3-4e76-90bc-dbc48e82d90e".keyFile = "/boot/crypto_keyfile.bin";

  # Networking configuration from Calamares
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  services.openssh.enable = true;

  # User configuration from Calamares
  users.users.okita = {
    isNormalUser = true;
    description = "okita";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    packages = with pkgs; [];
  };

  # Global settings
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";

  # Base packages that should always be available
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
  ];
}
EOF

echo -e "${GREEN}Created integrated configuration.nix${NC}"

# Copy dotfiles to ~/.config
echo -e "${BLUE}Setting up user dotfiles in ~/.config...${NC}"

# Function to backup existing config
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

# Ask to rebuild NixOS
echo -e "${YELLOW}Would you like to rebuild NixOS now? (y/n)${NC}"
read -r answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}Rebuilding NixOS...${NC}"
    sudo nixos-rebuild switch
    
    echo -e "${GREEN}Configuration integration complete!${NC}"
    echo -e "${YELLOW}You may need to log out and back in for all changes to take effect.${NC}"
else
    echo -e "${YELLOW}Skipping NixOS rebuild. Remember to run 'sudo nixos-rebuild switch' later.${NC}"
    echo -e "${GREEN}Configuration files have been set up.${NC}"
fi
