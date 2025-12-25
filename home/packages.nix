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
  ];
}
