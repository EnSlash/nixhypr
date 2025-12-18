{ config, pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.gns3-gui.overrideAttrs (old: {
      version = "2.2.54";
      src = pkgs.fetchFromGitHub {
        owner = "GNS3";
        repo = "gns3-gui";
        rev = "v2.2.54";
        hash = "sha256-rR7hrNX7BE86x51yaqvTKGfcc8ESnniFNOZ8Bu1Yzuc=" ; # Нужно вычислить
      };
      
      vendorHash = ""; # Хеш вендор зависимостей
      
    }))
  ];
}
