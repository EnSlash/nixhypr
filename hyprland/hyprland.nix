{ pkgs, ... }:

{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Enable xdg-desktop-portal-hyprland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # Set environment variables for Wayland
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  # Link the hyprland.conf file
  home.file.".config/hyprland/hyprland.conf".source = ./hyprland.conf;

  # Waybar configuration
  programs.waybar.enable = true;
  home.file.".config/waybar/config.jsonc".source = ../waybar/config.jsonc;
  home.file.".config/waybar/style.css".source = ../waybar/style.css;

  # Hyprpaper configuration
  home.file.".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;
}
