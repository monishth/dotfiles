{pkgs, ...}: {
  home.packages = with pkgs; [
    unstable.swaynotificationcenter
  ];

  xdg.configFile = {
    "swaync/style.css" = {
      source = ../../../.config/swaync/style.css;
    };
  };
}
