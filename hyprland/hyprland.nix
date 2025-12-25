{ pkgs, ... }:

let
  waybar-minimal-src = pkgs.fetchFromGitHub {
    owner = "ashish-kus";
    repo = "waybar-minimal";
    rev = "800e62cc790794bbacf50357492910ba165bdfe4"; # Pinned commit
    sha256 = "sha256-Hk/NFfCg3Jbf94u+5An206nLvBwaFtJPc4wVWX8+ZbQ=";
  };

  # A simpler derivation to just patch the shebangs
  waybar-minimal-patched = pkgs.runCommand "waybar-minimal-nixos" {} ''
    mkdir -p $out
    cp -r ${waybar-minimal-src}/. $out/
    chmod -R +w $out
    sed -i 's|#!/bin/bash|#!/usr/bin/env bash|g' $out/src/scripts/*
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
  # First, link the base theme (for style.css and scripts)
  home.file.".config/waybar" = {
    source = waybar-minimal-patched + "/src";
    recursive = true;
  };
  # Then, override the config with our custom one
  home.file.".config/waybar/config.jsonc" = {
    source = ../waybar-config.jsonc;
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