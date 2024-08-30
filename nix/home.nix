{ config
, pkgs
, pkgs-unstable
, pkgs-master
, inputs
, ...
}:
let
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
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in
{
  imports = [
    inputs.ags.homeManagerModules.default
    inputs.anyrun.homeManagerModules.default
    inputs.spicetify-nix.homeManagerModules.default
    ./modules/home/hyprland.nix
    ./modules/home/shells.nix
    ./modules/home/one-password.nix
  ];

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      shuffle # shuffle+ (special characters are sanitized out of ext names)
      hidePodcasts
    ];
  };

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
    "wallpaper/" = {
      source = ../assets/wallpaper;
    };

    "swaync/style.css" = {
      source = ../.config/swaync/style.css;
    };

    # "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    # "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    # "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
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

  home.file = {
    ".local/bin/tmux-sessionizer" = {
      source = ../scripts/tmux-sessionizer;
    };
    ".local/share/themes/${theme.name}" = {
      source = "${theme.package}/share/themes/${theme.name}";
    };
    ".config/gtk-4.0/gtk.css".text = ''
          window.messagedialog.response-area > button,
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
    platformTheme.name = "kde";
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
    inputs.neovim-nightly-overlay.packages.${pkgs.system}.default
    rustup
    cargo-generate
    stripe-cli
    clang
    gnumake
    unstable.fzf
    unstable.ticktick
    eza
    rofi-wayland

    nodejs_18
    nodejs_18.pkgs.pnpm
    nodejs_18.pkgs.yarn
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
    # unstable.spotify
    unstable.neofetch
    unstable.gnome.gnome-calculator
    unstable.rofi-calc
    # unstable.zathura
    # inputs.rose-pine-hyprcursor.packages.x86_64-linux.default
    (unstable.eww.overrideAttrs (final: prev: {
      withWayland = true;
    }))

    # packges for mat ui
    fuzzel
    pywal
    sassc
    dart-sass
    (python311.withPackages (p: [
      p.material-color-utilities
      p.pywayland
      p.pygobject3
      p.gst-python
    ]))
    bun
    unstable.lens
    unstable.doctl
    kubectl
    wev
    unstable.goxlr-utility
    fd
    unstable.swaynotificationcenter
    inputs.matugen.packages.${pkgs.system}.default
    inputs.nucleo.defaultPackage.${pkgs.system}
    unstable.jetbrains.datagrip
    unstable.jetbrains.goland
    networkmanager
    gtk3
    ulauncher

    cantarell-fonts
    font-awesome
    theme.package
    font.package
    cursorTheme.package
    iconTheme.package
    gnome.adwaita-icon-theme
    papirus-icon-theme

    any-nix-shell
    unstable.asciinema
    unstable.asciinema-agg
    unstable.bambu-studio
    # unstable.httpie
    unstable.httpie-desktop

    unstable.SDL2
    unstable.libjpeg
    unstable.zoom-us
    postgresql
    unstable.obsidian
    unstable.ngrok
    unstable.redli

    unstable.leiningen
    unstable.lua51Packages.lua
    unstable.lua51Packages.luarocks
    # unstable.go
    # unstable.gopls
    unstable.vlc
    unstable.sqlc
    unstable.sqlite
    unstable.remmina
    unstable.vhs
    unstable.lua-language-server
    unstable.selene
    unstable.shotcut
    unstable.nixd
    unstable.deadnix
    unstable.statix
    masterp.go
    masterp.gopls
  ];

  programs.zathura.enable = true;
  programs.zathura.options = {
    selection-clipboard = "clipboard";
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

  programs.git.extraConfig.init.defaultBranch = "main";
  programs.gh.gitCredentialHelper.enable = true;

  # starship - an customizable prompt for any shell

  # programs.neovim = {
  #  enable = true;
  #  defaultEditor = true;
  # };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";
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
