{ pkgs, ... }:
{
  home.packages = with pkgs; [
    unstable.gleam
    unstable.glas
    unstable.erlang_27
  ];
}
