{ pkgs, ... }:

{
  home.packages = with pkgs; [
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
    networkmanager-dmenu
    alsa-utils
    hyprpicker
    wget
  ];
}
