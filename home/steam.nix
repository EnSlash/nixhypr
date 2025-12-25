# /home/iershov/git/nixhypr/home/steam.nix
{ pkgs, ... }:

{
  # This method avoids the problematic home-manager `programs.steam` module
  # by directly symlinking Proton-GE into the directory where Steam looks
  # for compatibility tools.
  home.file.".steam/root/compatibilitytools.d/proton-ge-bin" = {
    source = pkgs.proton-ge-bin;
    # The `recursive` option might be needed if the source is a directory.
    # For `proton-ge-bin`, which is essentially a tarball treated as a package,
    # this ensures it's handled correctly.
    recursive = true;
  };
}
