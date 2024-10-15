{ pkgs, ... }:
{
  home.packages = with pkgs; [
    unstable.nil
    unstable.nixfmt-rfc-style
    unstable.nixd
    unstable.deadnix
    unstable.statix
  ];
}
