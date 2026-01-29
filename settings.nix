# /home/iershov/git/nixconf/settings.nix
{ config, pkgs, ... }:

let
  unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz") {
    config = { allowUnfree = true; allowBroken = true; };
  };
  home-manager-src = fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz";
in
{
  imports = [
    ./packages.nix
    ./services.nix
    ./desktop.nix
    ./castom/hugo.nix
    ./castom/gns3.nix
    (import "${home-manager-src}/nixos")
  ];

  home-manager.users.iershov = import ./home.nix;
  home-manager.backupFileExtension = "backup";



  { services.flatpak.enable = true; }

  {
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  xdg.portal.config.common.default = "gtk";
  } 
  
  nixpkgs.overlays = [ (import ./overlays.nix { unstable = unstable; }) ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.networkmanager.enable = true;
  services.upower.enable = true;
  nixpkgs.config.allowUnfree = true;

  boot.kernelParams = [ "acpi=strict" "nvidia_drm.modeset=1" ];
  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

  # NVIDIA settings
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;

  # Display Manager Configuration
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      extraPackages = with pkgs; [
        kdePackages.qtsvg
        kdePackages.qtmultimedia
        kdePackages.qtvirtualkeyboard
      ];
      theme = "catppuccin-mocha-mauve";
    };
  };

  # Enable Hyprland system-wide
  programs.hyprland.enable = true;
}
