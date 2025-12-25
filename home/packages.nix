{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Existing packages
    nsxiv
    mpv
    cmatrix
    alacritty
    jq
    steam
    upower

    # Waybar dependencies
    rofi
    cliphist
    wl-clipboard

    # Mechabar dependencies
    bluez
    brightnessctl
    fzf
    pkgs.nerd-fonts.commit-mono
  ];
}
