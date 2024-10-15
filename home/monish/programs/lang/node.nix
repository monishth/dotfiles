{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs_18
    nodejs_18.pkgs.pnpm
    nodejs_18.pkgs.yarn
    unstable.eslint
    bun
  ];
}
