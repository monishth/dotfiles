{ config
, pkgs
, ...
}:
let
  npm_token = builtins.readFile ../../../npm_token;
in
{
  programs.fish = {
    enable = true;
    shellInit = ''
      set -U fish_greeting ""
      set -x NPM_TOKEN ${npm_token}
      set -x EDITOR 'nvim'
      fish_add_path $HOME/.bin
      fish_add_path $HOME/.local/bin
      fish_add_path $HOME/go/bin
      any-nix-shell fish | source
    '';
    shellAliases = {
      nvim = "NVIM_APPNAME=astronvim_v4 command nvim";
      ls = "eza -l";
    };
    shellInitLast = ''
      alias cd z
    '';
    plugins = [
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf.src;
      }
    ];
  };
  programs.bash = {
    initExtra = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };
}
