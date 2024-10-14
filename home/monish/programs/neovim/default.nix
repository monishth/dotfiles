{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    extraLuaPackages = ps: [ps.magick];
  };

  home.file.".config/lazyvim" = {
    source = ./lazyvim;
    recursive = true;
  };
}
