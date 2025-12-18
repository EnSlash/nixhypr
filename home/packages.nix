{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nsxiv
    mpv
    cmatrix
    kitty
  ];
}
