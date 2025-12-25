# /home/iershov/git/nixconf/home.nix
{ pkgs, ... }:

{
  imports = [
    ./hyprland/hyprland.nix
    ./home/packages.nix
    ./home/files.nix
    ./home/steam.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "iershov";
  home.homeDirectory = "/home/iershov";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.11"; # Please change this to your version of Home Manager

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
