{ ... }:

{
  home.file.".config/i3/config".source = ../i3/config;
  home.file.".config/i3/desk.jpg".source = ../i3/desk.jpg;
  home.file.".config/polybar/config.ini".source = ../polybar/config.ini;
  home.file.".config/polybar/launch.sh" = {
    source = ../polybar/launch.sh;
    executable = true;
  };
  home.file.".bashrc".source = ../configs/.bashrc;
  home.file.".tmux.conf".source = ../configs/.tmux.conf;

  home.file.".config/custom_lock.sh" = {
    source = ../configs/custom_lock.sh;
    executable = true;
  };
}
