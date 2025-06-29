{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    ../../modules/common
  ];

  networking.hostName = "the-air-fryer";

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
    tmux
    # dolphin
  ];

  system.stateVersion = "23.11";
}
