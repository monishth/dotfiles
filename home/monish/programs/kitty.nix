{ config
, pkgs
, ...
}: {
  programs.kitty = {
    enable = true;
    package = pkgs.unstable.kitty;
    font.name = "FiraCode Nerd Font Mono Reg";
    settings = {
      background_opacity = "0.7";
      bold_font = "FiraCode Nerd Font Mono";
    };
  };
}
