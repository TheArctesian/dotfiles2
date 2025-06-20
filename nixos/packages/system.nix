{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim             
    neovim

    wget
    fish
    brightnessctl
    acpi
    networkmanagerapplet
  ];
}
