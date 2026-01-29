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

  services.flatpak.enable = true;

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  xdg.portal.config.common.default = "gtk";
  
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

  system.activationScripts.install-flatpaks = ''
    # Wait for network to be online by pinging a known host
    echo "Waiting for network connectivity..."
    for i in $(seq 1 30); do
        if ${pkgs.iputils}/bin/ping -c 1 8.8.8.8 &> /dev/null; then
            echo "Network is online."
            break
        fi
        sleep 1
    done

    if ! ${pkgs.iputils}/bin/ping -c 1 8.8.8.8 &> /dev/null; then
        echo "Network is not online after 30 seconds, skipping flatpak installation."
        exit 0
    fi

    ${pkgs.flatpak}/bin/flatpak install --system --noninteractive flathub \
      us.zoom.Zoom
  '';
}
