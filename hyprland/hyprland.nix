{ pkgs, lib, ... }:

let
  mechabar-src = pkgs.fetchFromGitHub {
    owner = "sejjy";
    repo = "mechabar";
    rev = "fix/v0.14.0";
    sha256 = "sha256-pBiPGbrFciHW76h+eyf1xmGu7BeemF6PzE3qLR92jy4="; # Correct hash from build error
  };

  mechabar-patched = pkgs.runCommand "mechabar-nixos" {
    # Add sed to dependencies for the runCommand
    nativeBuildInputs = [ pkgs.gnused ];
  } ''
    # Create the output directory and copy the original source
    mkdir -p $out
    cp -r ${mechabar-src}/. $out/

    # Copy the selected theme to current-theme.css
    cp $out/themes/catppuccin-latte.css $out/current-theme.css
    
    # Apply color changes: make grey text elements white
    sed -i 's|@define-color text #......;|@define-color text #FFFFFF;|g' $out/current-theme.css
    sed -i 's|@define-color subtext0 #......;|@define-color subtext0 #FFFFFF;|g' $out/current-theme.css
    sed -i 's|@define-color subtext1 #......;|@define-color subtext1 #FFFFFF;|g' $out/current-theme.css
    sed -i 's|@define-color overlay0 #......;|@define-color overlay0 #FFFFFF;|g' $out/current-theme.css
    sed -i 's|@define-color overlay1 #......;|@define-color overlay1 #FFFFFF;|g' $out/current-theme.css
    sed -i 's|@define-color overlay2 #......;|@define-color overlay2 #FFFFFF;|g' $out/current-theme.css
    
    # Embed the content of nixos-update.sh directly
    cat > $out/scripts/system-update.sh << EOF
#!/bin/sh
# NixOS-specific script to perform a system update.
# This will be run in a terminal window.

echo "Starting NixOS system upgrade..."
sudo nixos-rebuild switch --upgrade

# Keep the terminal open to see the result
echo "Update process finished. Press Enter to close this window."
read
EOF

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
