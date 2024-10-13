{ config
, pkgs
, pkgs-unstable
, inputs
, ...
}:
let
in
{
  imports = [
    ./gtk.nix
    ./programs
    ./hyprland/config.nix
    ./shell
  ];

  home = {
    username = "monish";
    homeDirectory = "/home/monish";
    stateVersion = "23.11";
    file = {
      ".local/bin/tmux-sessionizer" = {
        source = ../../scripts/tmux-sessionizer;
      };
    };

    sessionVariables = {
      XCURSOR_THEME = "Qogir";
      XCURSOR_SIZE = "24";
    };
  };

  fonts.fontconfig.enable = true;

  programs = {
    home-manager.enable = true;
    zathura.enable = true;
  };

  programs.zathura.options = {
    selection-clipboard = "clipboard";
  };

  programs.gh.gitCredentialHelper.enable = true;


  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  xdg.desktopEntries = {
    "chrome-personal" = {
      name = "Chrome Personal";
      exec = "google-chrome-stable --profile-directory=Default";
      icon = "google-chrome";
    };
    "chrome-work" = {
      name = "Chrome Work";
      exec = ''google-chrome-stable --profile-directory="Profile 1"'';
      icon = "google-chrome";
    };
  };

  xdg.configFile = {
    "rofi" = {
      source = ../../.config/rofi;
      recursive = true;
    };
    "wallpaper/" = {
      source = ../../assets/wallpaper;
    };
  };
}
