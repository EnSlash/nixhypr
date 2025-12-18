{ ... }:

{
  home.file.".bashrc".source = ../configs/.bashrc;
  home.file.".tmux.conf".source = ../configs/.tmux.conf;

  home.file.".config/custom_lock.sh" = {
    source = ../configs/custom_lock.sh;
    executable = true;
  };
}
