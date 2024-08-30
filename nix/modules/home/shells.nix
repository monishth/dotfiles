{ config
, pkgs
, pkgs-unstable
, ...
}:
let
  onePassPath = "~/.1password/agent.sock";
  npm_token = builtins.readFile ../../../npm_token;
in
{
  programs.kitty = {
    enable = true;
    # custom settings
    package = pkgs-unstable.kitty;
    font.name = "FiraCode Nerd Font Mono Reg";
    settings = {
      background_opacity = "0.7";
      bold_font = "FiraCode Nerd Font Mono";
    };
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
          IdentityAgent ${onePassPath}
    '';
  };

  programs.starship = {
    enable = true;
    enableTransience = true;
    # custom settings
    settings = {
      aws.disabled = true;
      gcloud.disabled = true;
      time.disabled = false;
      time.format = "at [$time]($style)\n";
      # cmd_duration.format = "took [$duration]($style)";
      line_break.disabled = true;
    };
  };

  programs.zoxide.enable = true;
  programs.zoxide.enableFishIntegration = true;

  programs.fish = {
    enable = true;

    # TODO add your custom bashrc here
    shellInit = ''
      set -U fish_greeting ""
      set -x NPM_TOKEN ${npm_token}
      set -x EDITOR 'nvim'
      fish_add_path $HOME/.bin
      fish_add_path $HOME/.local/bin
      fish_add_path $HOME/go/bin
      any-nix-shell fish | source
    '';

    shellInitLast = ''
      alias cd z
    '';

    # set some aliases, feel free to add more or remove some
    shellAliases = {
      nvim = "NVIM_APPNAME=astronvim_v4 command nvim";
      ls = "eza -l";
    };
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
