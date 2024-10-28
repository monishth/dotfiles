{
  config,
  pkgs,
  inputs,
  ...
}:
let
  overlays = import ../../overlays {
    inherit inputs;
  };
in
{
  imports = [
    ./boot.nix
    ./audio.nix
    ./desktop.nix
    ./virtualization.nix
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    # substituters = [ "https://hyprland.cachix.org" ];
    # trusted-public-keys = [ "nix run github:ryantm/agenix -- --helphyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8Pwtkuc=" ];
  };

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [ overlays.unstable-packages ];

  services = {
    xserver.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    printing.enable = true;
    blueman.enable = true;
  };

  programs = {
    fish.enable = true;
    hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    };
  };

  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    inputs.alejandra.defaultPackage.${system}
    pavucontrol
  ];

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
}
