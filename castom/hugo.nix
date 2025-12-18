{ config, pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.hugo.overrideAttrs (old: {
      version = "0.126.1";
      src = pkgs.fetchFromGitHub {
        owner = "gohugoio";
        repo = "hugo";
        rev = "v0.126.1";
        hash = "sha256-c421kzgD6PFM/9Rn+NmZGyRlJPWhQPraW/4HcuRoEUU=" ; # Нужно вычислить
      };
      
      vendorHash = "sha256-VfwiA5LCAJ1pkmMCy/Dcc5bLKkNY1MHtxHcHvKLoWHs="; # Хеш вендор зависимостей
      
    }))
  ];
}
