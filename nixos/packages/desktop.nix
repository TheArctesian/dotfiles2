# packages/desktop.nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Window Manager and Desktop Environment
    bspwm
    sxhkd
    polybar
    picom
    feh
    alacritty
    rofi
    dunst           # For notifications
    xdo
    libnotify       # For sending notifications
    
    # Applications
    firefox
    obsidian
    zotero
    slack
    spotify
    tor-browser
    signal-desktop
    ghostty
    obs-studio
    
    # Media controls
    playerctl
  ];
  
  # Define these services properly
  services.blueman.enable = true;
}
