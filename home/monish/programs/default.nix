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

    ./lang
    ./cli-dev-tools.nix
    ./gui-dev-tools.nix
    ./ssh.nix
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
    unstable.vhs
    unstable.watchexec

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
    unstable.fzf
    unstable.ticktick
    eza
    tmux
    unstable.gnome-calculator
    sassc
    dart-sass
    unstable.goxlr-utility
    fd
    inputs.matugen.packages.${pkgs.system}.default
    inputs.nucleo.defaultPackage.${pkgs.system}
    networkmanager
    gtk3
    cantarell-fonts
    font-awesome
    adwaita-icon-theme
    any-nix-shell
    papirus-icon-theme
    unstable.SDL2
    unstable.libjpeg
    unstable.zoom-us
    unstable.obsidian
    unstable.vlc
    unstable.google-chrome
    unstable.nautilus
    inputs.zen-browser.packages."${system}".default
    screen
    tio
    unstable.tana
    inputs.ghostty.packages.${pkgs.system}.default
    unstable.qFlipper
    unstable.betaflight-configurator
    unstable.darktable
    kdePackages.dolphin
    unstable.ngrok
  ];
}
