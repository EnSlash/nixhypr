{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Gaming Essentials
    gamemode
    mangohud
    gamescope

    # Existing packages
    nsxiv
    mpv
    cmatrix
    alacritty
    jq
    steam
    upower

    # Dependencies for waybar-minimal
    rofi
    cliphist
    wl-clipboard
    light
    networkmanager_dmenu
    alsa-utils
    hyprpicker
    wget
  ];
}
