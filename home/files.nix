{ ... }:

{
  home.file.".bashrc".source = ../configs/.bashrc;
  home.file.".tmux.conf".source = ../configs/.tmux.conf;

  home.file.".config/custom_lock.sh" = {
    source = ../configs/custom_lock.sh;
    executable = true;
  };

  home.file.".config/wofi/style.css".text = ''
    /*
     * Catppuccin Mocha Wofi Style
     */

    * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 16px;
    }

    window {
        background-color: #1e1e2e; /* Base */
        border-radius: 10px;
        border: 2px solid #89b4fa; /* Blue */
    }

    #input {
        margin: 10px;
        padding: 10px;
        background-color: #181825; /* Mantle */
        color: #cdd6f4; /* Text */
        border: none;
        border-radius: 8px;
    }

    #inner-box {
        margin: 5px;
    }

    #outer-box {
        margin: 10px;
    }

    #scroll {
        margin-top: 10px;
    }

    #text:selected {
        color: #1e1e2e; /* Base */
    }

    #entry {
        padding: 10px;
        border-radius: 8px;
        color: #cdd6f4; /* Text */
    }

    #entry:selected {
        background-color: #89b4fa; /* Blue */
        color: #1e1e2e; /* Base */
    }

    image {
        margin-right: 10px;
    }
  '';

  home.file.".config/wofi/config".text = ''
    # Wofi config

    show=drun
    allow_images=true
    allow_markup=true
    style=style.css
    width=50%
    height=40%
    prompt=Search...
    hide_scroll=true
    insensitive=true
    normal_window=true
  '';
}
