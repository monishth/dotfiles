{ pkgs, ... }:
{
  home.packages = with pkgs; [
    unstable.go_1_23
    unstable.gopls
  ];
}
