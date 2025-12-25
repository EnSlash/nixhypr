{ pkgs, ... }:

let
  waybar-minimal-src = pkgs.fetchFromGitHub {
    owner = "ashish-kus";
    repo = "waybar-minimal";
    rev = "800e62cc790794bbacf50357492910ba165bdfe4"; # Pinned commit for reproducibility
    sha256 = "sha256-Hk/NFfCg3Jbf94u+5An206nLvBwaFtJPc4wVWX8+ZbQ="; # Correct hash from build error
  };

  waybar-minimal-patched = pkgs.runCommand "waybar-minimal-nixos" {
    nativeBuildInputs = [ pkgs.gnused ];
  } ''
    mkdir -p $out
    cp -r ${waybar-minimal-src}/. $out/
    chmod -R +w $out

    # Fix shebangs for NixOS compatibility
    sed -i 's|#!/bin/bash|#!/usr/bin/env bash|g' $out/src/scripts/*

    # Apply color changes: make grey text elements white
    sed -i 's|#clock{\n  color: #5fd1fa;\n}|#clock{\n  color: #FFFFFF;\n}|g' $out/src/style.css
    echo "/* Custom color override by Nix Agent */" >> $out/src/style.css
    echo "window#waybar { color: #FFFFFF; }" >> $out/src/style.css

    # Overwrite myupdate.sh with a NixOS compatible version
    cat > $out/src/scripts/myupdate.sh << EOF
#!/bin/sh
# NixOS-specific script to perform a system update.
echo "Starting NixOS system upgrade..."
sudo nixos-rebuild switch --upgrade
echo "Update process finished. Press Enter to close this window."
read
EOF

    chmod +x $out/src/scripts/myupdate.sh
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
    source = waybar-minimal-patched + "/src";
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