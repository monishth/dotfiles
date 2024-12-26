{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-23.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags.url = "github:Aylur/ags";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hy3 = {
      url = "github:outfoxxed/hy3"; # where {version} is the hyprland release version
      # or "github:outfoxxed/hy3" to follow the development branch.
      # (you may encounter issues if you dont do the same for hyprland)
      inputs.hyprland.follows = "hyprland";
    };
    # hyprland.submodules = true;
    xdg-desktop-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    oh-my-tmux = {
      url = "github:gpakosz/.tmux";
      flake = false;
    };
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-ld.url = "github:Mic92/nix-ld";
    # this line assume that you also have nixpkgs as an input
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";
    matugen = {
      url = "github:/InioX/Matugen";
    };
    nucleo = {
      url = "github:monishth/nucleo-ui";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:ch4og/zen-browser-flake";
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-master,
      home-manager,
      alejandra,
      # , nix-ld
      ...
    }:
    let
      pkgs-unstable = import nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      pkgs-master = import nixpkgs-master {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.the-air-fryer = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          inherit pkgs-unstable;
          inherit pkgs-master;
        };
        modules = [
          ./hosts/the-air-fryer
          home-manager.nixosModules.home-manager
          (
            { config, ... }:
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.monish = import ./home/monish/nixos.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                inherit pkgs-unstable;
                inherit pkgs-master;
                nixosConfig = config;
              };
            }
          )
        ];
      };
    };
}
