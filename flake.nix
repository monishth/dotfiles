{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-23.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags.url = "github:Aylur/ags";
    hyprland.url = "github:hyprwm/Hyprland/v0.39.0";
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
  };

  outputs =
    inputs @ { nixpkgs
    , nixpkgs-unstable
    , nixpkgs-master
    , home-manager
    , alejandra
      # , nix-ld
    , ...
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
      # Please replace my-nixos with your hostname
      nixosConfigurations.the-air-fryer = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          inherit pkgs-unstable;
          inherit pkgs-master;
        };
        modules = [
          # nix-ld.nixosModules.nix-ld

          # The module in this repository defines a new module under (programs.nix-ld.dev) instead of (programs.nix-ld) 
          # to not collide with the nixpkgs version.
          # { programs.nix-ld.dev.enable = true; }
          # Import the previous configuration.nix we used,
          # so the old configuration file still takes effect
          ./nix/configuration.nix
          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # TODO replace ryan with your own username
            home-manager.users.monish = import ./nix/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit pkgs-unstable;
              inherit pkgs-master;
            };


            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };
    };
}
