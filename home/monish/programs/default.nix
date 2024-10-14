{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./git.nix
    ./kitty.nix
    ./neovim

    ./spicetify.nix

    ./starship.nix
    ./tmux.nix
    ./vscode.nix
    ./zoxide.nix
    ./swaync.nix
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
    nodejs_18
    nodejs_18.pkgs.pnpm
    nodejs_18.pkgs.yarn
    vscode
    tmux
    unstable.lazygit
    unstable.gnome-calculator
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
    unstable.goxlr-utility
    fd
    inputs.matugen.packages.${pkgs.system}.default
    inputs.nucleo.defaultPackage.${pkgs.system}
    unstable.jetbrains.datagrip
    unstable.jetbrains.goland
    networkmanager
    gtk3
    ulauncher
    cantarell-fonts
    unstable.asciinema
    font-awesome
    gnome.adwaita-icon-theme
    any-nix-shell
    papirus-icon-theme
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
    unstable.stylua
    unstable.nil
    unstable.nixfmt-rfc-style
  ];
}
