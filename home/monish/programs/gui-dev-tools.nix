{ pkgs, ... }:
{
  home.packages = with pkgs; [
    unstable.jetbrains.datagrip
    unstable.jetbrains.goland
    unstable.lens
    unstable.postman
  ];
}
