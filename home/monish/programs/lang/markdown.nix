{ pkgs, ... }:
{
  home.packages = with pkgs; [
    unstable.marksman
  ];
}
