{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./git.nix
    ./kitty.nix
    ./neovim

    inputs.spicetify-nix.homeManagerModules.default
    ./spicetify.nix

    ./starship.nix
    ./tmux.nix
    ./vscode.nix
    ./zoxide.nix
  ];
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
    firefox
    discord
    slack
    gh
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
    vscode
    tmux
    unstable.lazygit
    unstable.cliphist
    unstable.slurp
    unstable.grim
    unstable.imv
    unstable.hypridle
    unstable.hyprlock
    unstable.neofetch
    unstable.gnome-calculator
    unstable.rofi-calc
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
    kubernetes-helm
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
    gnome.adwaita-icon-theme
    papirus-icon-theme
    any-nix-shell
    unstable.asciinema
    unstable.asciinema-agg
    unstable.bambu-studio
    unstable.httpie-desktop
    unstable.SDL2
    unstable.libjpeg
    unstable.zoom-us
    postgresql
    unstable.obsidian
    unstable.redli
    unstable.leiningen
    unstable.luajitPackages.lua
    unstable.luajitPackages.luarocks
    unstable.go_1_23
    unstable.gopls
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
    unstable.zig
    unstable.zls
    unstable.marksman
    unstable.watchexec
    unstable.google-chrome
  ];
}
