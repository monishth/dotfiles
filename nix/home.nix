{ config
, pkgs
, pkgs-unstable
, inputs
, ...
}:
let
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    ${pkgs.waybar}/bin/waybar &
    ${pkgs.swww}/bin/swww init &

    sleep 1

    ${pkgs.swww}/bin/swww img ~/wallpaper/wallpaper-1.jpg &
  '';
  onePassPath = "~/.1password/agent.sock";
in
{
  # TODO please change the username & home directory to your own
  home.username = "monish";
  home.homeDirectory = "/home/monish";

  xdg.configFile = {
    "tmux/tmux.conf" = {
      source = "${inputs.oh-my-tmux}/.tmux.conf";
    };
    "tmux/tmux.conf.local" = {
      source = ../.config/.tmux.conf.local;
    };
    "rofi" = {
      source = ../.config/rofi;
      recursive = true;
    };
    "waybar/config.jsonc" = {
      source = ../.config/waybar/config;
    };
    "waybar/style.css" = {
      source = ../.config/waybar/style.css;
    };
    "hypr/hypridle.conf" = {
      source = ../.config/hypridle.conf;
    };
    "hypr/hyprlock.conf" = {
      source = ../.config/hyprlock.conf;
    };
  };

  home.file = {
    ".local/bin/tmux-sessionizer" = {
      source = ../scripts/tmux-sessionizer;
    };
    "wallpaper/wallpaper-1.jpg" = {
      source = ../assets/wallpaper-1.jpg;
    };

  };

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    btop # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb

    discord
    slack
    gh
    neovim-nightly
    rustup
    clang
    gnumake
    fzf
    unstable.ticktick
    eza
    rofi-wayland

    nodejs_18
    vesktop
    tmux
    unstable.lazygit
    unstable.cliphist
    unstable.waybar
    unstable.slurp
    unstable.grim
    unstable.imv
    unstable.hypridle
    unstable.hyprlock
    unstable.brightnessctl
    unstable.spotify
    unstable.neofetch
    unstable.gnome.gnome-calculator
    unstable.rofi-calc

    inputs.rose-pine-hyprcursor.packages.x86_64-linux.default

  ];

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      # ms-vsliveshare.vsliveshare
    ];
  };

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Monish Thirukkumaran";
    userEmail = "monish.thir@gmail.com";

  };

  programs.gh.gitCredentialHelper.enable = true;

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      aws.disabled = true;
      gcloud.disabled = true;
    };
  };

  programs.zoxide.enable = true;
  programs.zoxide.enableFishIntegration = true;

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.kitty = {
    enable = true;
    # custom settings
    package = pkgs-unstable.kitty;
    font.name = "FiraCode Nerd Font Mono Reg";
    settings = {
      background_opacity = "0.7";
    };
  };

  # programs.neovim = {
  #  enable = true;
  #  defaultEditor = true;
  # };
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
          IdentityAgent ${onePassPath}
    '';
  };

  programs.fish = {
    enable = true;
    # TODO add your custom bashrc here
    shellInit = ''
      set -U fish_greeting ""
      set -x NPM_TOKEN 6f65d006-ab4c-4b69-a982-e2424c621d35
      set -x EDITOR 'nvim'
      fish_add_path $HOME/.bin
      fish_add_path $HOME/.local/bin
    '';

    # set some aliases, feel free to add more or remove some
    shellAliases = {
      nvim = "NVIM_APPNAME=astronvim_v4 command nvim";
      cd = "z";
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

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      ''${startupScript}/bin/start''
      "wl-paste --type text --watch cliphist store #Stores only text data"
      "wl-paste --type image --watch cliphist store #Stores only image data"
      "hypridle"
    ];
    general = {
      gaps_in = 5;
      gaps_out = 20;
      layout = "master";
    };
    decoration = {
      rounding = 3;
      dim_inactive = true;
      dim_strength = 0.2;
      blur = { passes = 3; size = 4; };
    };
    windowrule = "rounding 10,^(kitty)$";
    input = {
      kb_layout = "gb";
    };
    # windowrulev2 = [
    #   "suppressevent maximize, class:.*"
    # ];
    "$mainMod" = "SUPER";
    bind = [
      "$mainMod, Q, exec, kitty"
      ''$mainMod, SPACE, exec, rofi -show combi -modes combi -combi-modes "window,drun,run,calc"''
      # ''$mainMod, SPACE, exec, rofi -show calc ''
      "ALT, F4, killactive"
      "$mainMod, h, movefocus, l"
      "$mainMod, j, movefocus, d"
      "$mainMod, k, movefocus, u"
      "$mainMod, l, movefocus, r"
      "$mainMod SHIFT, c, movetoworkspacesilent, special"
      "$mainMod, c, togglespecialworkspace"
      "$mainMod SHIFT, h, movewindow, l"
      "$mainMod SHIFT, j, movewindow, d"
      "$mainMod SHIFT, k, movewindow, u"
      "$mainMod SHIFT, l, movewindow, r"
      "$mainMod, left, moveintogroup, l"
      "$mainMod, right, moveintogroup, r"
      "$mainMod, up, moveintogroup, u"
      "$mainMod, down, moveintogroup, d"
      "$mainMod, bracketright, changegroupactive, f"
      "$mainMod, bracketleft, changegroupactive, b"
      "$mainMod, semicolon, togglegroup"
      "$mainMod, m, fullscreen, 1"
      "$mainMod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
      "$mainMod, S, exec, grim ~/Pictures/screenshot_$(date +'%s_grim.png')"
      ''$mainMod CTRL, S, exec, grim -g "$(slurp -o)" ~/Pictures/screenshot_$(date +'%s_grim.png')''
      ''$mainMod CTRL SHIFT, S, exec, grim -g "$(slurp)" ~/Pictures/screenshot_$(date +'%s_grim.png')''
    ];
    bindm = [ "$mainMod, moouse:272, movewindow" ];
    monitor = [
      "DP-1, 5120x1440@240, 0x1080, 1"
      "DP-2, 2560x1080, 0x0, 1"
    ];
    env = [
      "LIBVA_DRIVER_NAME,nvidia"
      "ELECTRON_OZONE_PLATFORM_HINT,wayland"
      "XDG_SESSION_TYPE,wayland"
      "GBM_BACKEND,nvidia-drm"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      "WLR_NO_HARDWARE_CURSORS,1"
      "WLR_RENDERER_ALLOW_SOFTWARE,1"
      "HYPRCURSOR_THEME,rose-pint-hyprcursor"
    ];
    master = { orientation = "center"; };
  };
  # home.file.".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink
  #   ".tmux.conf";
  # home.file.".tmux.conf.local".source = config.lib.file.mkOutOfStoreSymlink
  #   ".tmux.conf.local";

  # programs.tmux = {
  #   enable = true;
  # };
  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
