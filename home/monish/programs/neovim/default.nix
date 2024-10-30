{
  pkgs,
  inputs,
  ...
}:
{
  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;
    extraLuaPackages = ps: [ ps.magick ];
  };

  home.file.".config/lazyvim" = {
    source = ./lazyvim;
    recursive = true;
  };

  home.file.".config/lazyvim/lua/plugins/mason.lua" = {
    source = ./mason.lua;
  };
}
