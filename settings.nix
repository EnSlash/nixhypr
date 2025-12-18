# /home/iershov/git/nixconf/settings.nix
{ config, pkgs, ... }:

let
  unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz") {
    config = { allowUnfree = true; allowBroken = true; };
  };
  home-manager-src = fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
in
{
  imports = [
    ./packages.nix
    ./services.nix
    ./desktop.nix
    ./castom/hugo.nix
    ./castom/gns3.nix
    (import "${home-manager-src}/nixos")
  ];

  home-manager.users.iershov = import ./home.nix;



  nixpkgs.overlays = [ (import ./overlays.nix { unstable = unstable; }) ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.networkmanager.enable = true;
  nixpkgs.config.allowUnfree = true;

  boot.kernelParams = [ "acpi=strict" ];
  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw
}