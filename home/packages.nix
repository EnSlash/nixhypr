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

    # Mechabar dependencies
    bluez
    brightnessctl
    fzf
    (nerdfonts.override { fonts = [ "CommitMono" ]; })
  ];
}
