{ config
, pkgs
, pkgs-unstable
, inputs
, ...
}:
let
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    ${pkgs.swww}/bin/swww init &

    sleep 1

    ${pkgs.swww}/bin/swww img ~/wallpaper/wallpaper-1.jpg &
  '';
  onePassPath = "~/.1password/agent.sock";
  npm_token = builtins.readFile ../npm_token;

  nerdfonts = pkgs.nerdfonts.override {
    fonts = [
      "Ubuntu"
      "UbuntuMono"
      "CascadiaCode"
      "FantasqueSansMono"
      "FiraCode"
      "Mononoki"
    ];
  };

  theme = {
    name = "adw-gtk3-dark";
    package = pkgs-unstable.adw-gtk3;
  };
  font = {
    name = "Ubuntu Nerd Font";
    package = nerdfonts;
  };
  cursorTheme = {
    name = "Qogir";
    size = 24;
    package = pkgs-unstable.qogir-icon-theme;
  };
  iconTheme = {
    name = "MoreWaita";
    package = pkgs-unstable.morewaita-icon-theme;
  };
in
{
  imports = [
    inputs.ags.homeManagerModules.default
    inputs.anyrun.homeManagerModules.default
  ];

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
    "hypr/hypridle.conf" = {
      source = ../.config/hypridle.conf;
    };
    "hypr/hyprlock.conf" = {
      source = ../.config/hyprlock.conf;
    };
    # "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    # "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    # "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  };

  home.file = {
    ".local/bin/tmux-sessionizer" = {
      source = ../scripts/tmux-sessionizer;
    };
    "wallpaper/wallpaper-1.jpg" = {
      source = ../assets/wallpaper-1.jpg;
    };
    ".local/share/themes/${theme.name}" = {
      source = "${theme.package}/share/themes/${theme.name}";
    };
    ".config/gtk-4.0/gtk.css".text = ''
      window.messagedialog .response-area > button,
      window.dialog.message .dialog-action-area > button,
      .background.csd{
        border-radius: 0;
      }
    '';
  };

  home = {
    sessionVariables = {
      XCURSOR_THEME = cursorTheme.name;
      XCURSOR_SIZE = "${toString cursorTheme.size}";
    };
    pointerCursor =
      cursorTheme
      // {
        gtk.enable = true;
      };
  };

  fonts.fontconfig.enable = true;

  gtk = {
    inherit font cursorTheme iconTheme;
    theme.name = theme.name;
    enable = true;
    gtk3.extraCss = ''
      headerbar, .titlebar,
      .csd:not(.popup):not(tooltip):not(messagedialog) decoration{
        border-radius: 0;
      }
    '';
  };

  qt = {
    enable = true;
    platformTheme = "kde";
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
    unstable.fzf
    unstable.ticktick
    eza
    rofi-wayland
    go

    nodejs_18
    vesktop
    tmux
    unstable.lazygit
    unstable.cliphist
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
    unstable.zathura
    inputs.rose-pine-hyprcursor.packages.x86_64-linux.default
    (unstable.eww.overrideAttrs (final: prev: { withWayland = true; }))

    # packges for mat ui
    fuzzel
    pywal
    sassc
    dart-sass
    (python311.withPackages (p: [
      p.material-color-utilities
      p.pywayland
    ]))
    bun
    unstable.lens
    unstable.doctl
    kubectl
    wev
    dbeaver
    unstable.goxlr-utility
    fd
    unstable.swaynotificationcenter
    inputs.matugen.packages.${pkgs.system}.default
    inputs.nucleo.defaultPackage.${pkgs.system}
    unstable.jetbrains.datagrip
    networkmanager
    gtk3

    cantarell-fonts
    font-awesome
    theme.package
    font.package
    cursorTheme.package
    iconTheme.package
    gnome.adwaita-icon-theme
    papirus-icon-theme
  ];

  programs.ags = {
    enable = true;
    configDir = null; # if ags dir is managed by home-manager, it'll end up being read-only. not too cool.
    # configDir = ./.config/ags;

    extraPackages = with pkgs; [
      gtksourceview
      gtksourceview4
      sassc
      webkitgtk
      accountsservice
    ];
  };

  programs.anyrun = {
    enable = true;
    config = {
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        randr
        rink
        shell
        symbols
      ];

      width.fraction = 0.3;
      y.absolute = 15;
      hidePluginInfo = true;
      closeOnClick = true;
    };
  };

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      ms-vsliveshare.vsliveshare
    ];
    userSettings = {
      "window.titleBarStyle" = "custom";
      "workbench.colorTheme" = "Github Dark Colorblind (Beta)";
      "editor.fontFamily" = "'FiraCode Nerd Font','Droid Sans Mono', 'monospace', monospace";
    };
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
      set -x NPM_TOKEN ${npm_token}
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
      "hyprctl setcursor Qogir 24"
      "wl-paste --type text --watch cliphist store #Stores only text data"
      "wl-paste --type image --watch cliphist store #Stores only image data"
      # "hypridle"
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
    workspace = [
      "1, m:DP-1, persistent:true, default:true"
      "2, m:DP-1, persistent:true"
      "3, m:DP-1, persistent:true"
      "4, m:DP-2, persistent:true, default:true"
      "5, m:DP-2, persistent:true"
    ];
    input = {
      kb_layout = "gb";
    };
    windowrulev2 = [
      "suppressevent maximize, class:.*"
    ];
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
      "ALT, J, exec, wl-paste | jq . | wl-copy"
      "$mainMod, S, exec, grim ~/Pictures/screenshot_$(date +'%s_grim.png')"
      "$mainMod, minus, layoutmsg, mfact -0.05"
      "$mainMod, equal, layoutmsg, mfact +0.05"
      ''$mainMod CTRL, S, exec, grim -g "$(slurp -o)" ~/Pictures/screenshot_$(date +'%s_grim.png')''
      # ''$mainMod CTRL SHIFT, S, exec, grim -g "$(slurp)" ~/Pictures/screenshot_$(date +'%s_grim.png')''
      ''$mainMod CTRL SHIFT, S, exec, grim -g "$(slurp)" - | wl-copy''
    ] ++ (
      # workspaces
      # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
      builtins.concatLists (builtins.genList
        (
          x:
          let
            ws =
              let
                c = (x + 1) / 10;
              in
              builtins.toString (x + 1 - (c * 10));
          in
          [
            "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
            "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
          ]
        )
        6)
    );
    bindm = [ "$mainMod, mouse:272, movewindow" ];
    monitor = [
      "DP-1, 5120x1440@240, 0x1080, 1"
      "DP-2, 2560x1080, 1440x0, 1"
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
