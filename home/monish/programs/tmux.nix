{ config
, pkgs
, inputs
, ...
}: {
  programs.tmux = {
    enable = true;
  };
  xdg.configFile = {
    "tmux/tmux.conf" = {
      source = "${inputs.oh-my-tmux}/.tmux.conf";
    };
    "tmux/tmux.conf.local" = {
      source = ../../../.config/.tmux.conf.local;
    };
  };

}
