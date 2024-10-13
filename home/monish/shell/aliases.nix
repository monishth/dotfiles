{ config
, pkgs
, ...
}: {
  home.shellAliases = {
    nvim = "NVIM_APPNAME=astronvim_v4 command nvim";
    ls = "eza -l";
  };
}
