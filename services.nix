# /home/iershov/git/nixconf/services.nix
{ config, pkgs, ... }:

{
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Включить D-Bus (обязательно для трея)
  services.dbus.enable = true;

  # Docker
  virtualisation.docker.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Automatic cleanup of old generations
  systemd.services.nix-cleanup = {
    script = ''
      #!${pkgs.bash}/bin/bash
      # For system profile
      SYSTEM_PROFILE="/nix/var/nix/profiles/system"
      GENS_TO_DELETE_SYSTEM=$(${pkgs.nix}/bin/nix-env --list-generations --profile "$SYSTEM_PROFILE" | ${pkgs.gawk}/bin/awk '{print $1}' | ${pkgs.coreutils}/bin/head -n -10 | ${pkgs.coreutils}/bin/tr '\n' ' ')
      if [ -n "$GENS_TO_DELETE_SYSTEM" ]; then
        ${pkgs.nix}/bin/nix-env --delete-generations $GENS_TO_DELETE_SYSTEM --profile "$SYSTEM_PROFILE"
      fi

      # For home-manager profile
      HOME_PROFILE="/home/iershov/.nix-profile"
      GENS_TO_DELETE_HOME=$(${pkgs.nix}/bin/nix-env --list-generations --profile "$HOME_PROFILE" | ${pkgs.gawk}/bin/awk '{print $1}' | ${pkgs.coreutils}/bin/head -n -10 | ${pkgs.coreutils}/bin/tr '\n' ' ')
      if [ -n "$GENS_TO_DELETE_HOME" ]; then
        # This needs to run as the user
        sudo -u iershov ${pkgs.nix}/bin/nix-env --delete-generations $GENS_TO_DELETE_HOME --profile "$HOME_PROFILE"
      fi

      # Run garbage collector to free up space
      ${pkgs.nix}/bin/nix-store --gc
    '';
    serviceConfig = {
      Type = "oneshot";
    };
  };

  systemd.timers.nix-cleanup = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };
}
