{ pkgs, ... }:
{
  home.packages = with pkgs; [
    unstable.luajitPackages.lua
    unstable.luajitPackages.luarocks
    unstable.lua-language-server
    unstable.selene
    unstable.stylua
  ];
}
