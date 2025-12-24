{ pkgs, ... }:

let
  mechabar-src = pkgs.fetchFromGitHub {
    owner = "sejjy";
    repo = "mechabar";
    rev = "fix/v0.14.0";
    sha256 = "sha256-pBiPGbrFciHW76h+eyf1xmGu7BeemF6PzE3qLR92jy4="; # Placeholder, will be filled in by the build error
  };

  mechabar-patched = pkgs.runCommand "mechabar-nixos" {} ''
    # Create the output directory and copy the original source
    mkdir -p $out
    cp -r ${mechabar-src}/. $out/
    
    # Make the destination file writable before overwriting
    chmod +w $out/scripts/system-update.sh

    # Copy our NixOS-specific update script over the original one
    cp ${../scripts/nixos-update.sh} $out/scripts/system-update.sh
    
    # Make all scripts executable
    chmod +x $out/scripts/*
  '';
in
{
  # Enable xdg-desktop-portal-hyprland
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];

  # Set environment variables for Wayland
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  # Link the hyprland.conf file
  home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;

  # Waybar configuration
  programs.waybar.enable = true;
  home.file.".config/waybar" = {
    source = mechabar-patched;
    recursive = true;
  };

  # Hyprpaper configuration
  home.file.".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;
  home.file.".config/hypr/wallpaper.jpg".source = ../wallpapers/desk.jpg;

  # Hyprlock configuration
  home.file.".config/hypr/hyprlock.conf".source = ./hyprlock.conf;

  # Autolock with swayidle
  systemd.user.services.swayidle = {
    Unit = {
      Description = "Lock screen on idle";
      After = [ "hyprland-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = ''
        ${pkgs.swayidle}/bin/swayidle \
          timeout 180 '${pkgs.hyprlock}/bin/hyprlock' \
          before-sleep '${pkgs.hyprlock}/bin/hyprlock'
      '';
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
