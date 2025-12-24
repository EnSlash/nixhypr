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
    (pkgs.nerdfonts.override { fonts = [ "CommitMono" ]; })
  ];
}
