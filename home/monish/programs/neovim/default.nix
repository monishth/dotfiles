{
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

  home.file.".config/lazyvim/lua/plugins/mason.lua" = {
    source = ./mason.lua;
  };
}
