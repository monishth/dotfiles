{ pkgs, ... }:
{
  home.packages = with pkgs; [
    unstable.go_1_25
    unstable.gopls
    unstable.delve
  ];
}
