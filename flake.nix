{
  description = "UVG Selfhosting server flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs_unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flaviosConfiguration.url = "github:ElrohirGT/ConfigurationFiles";
    # Nix formatting pack
    # https://gerschtli.github.io/nix-formatter-pack/nix-formatter-pack-options.html
    nix-formatter-pack = {
      url = "github:Gerschtli/nix-formatter-pack";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs_unstable,
    nix-formatter-pack,
    home-manager,
    ...
  }: let
    forAllSystems = {
      pkgs ? nixpkgs,
      function,
    }:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "x86_64-macos"
        "aarch64-linux"
        "aarch64-darwin"
      ]
      (system:
        function {
          pkgs = import pkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [
              #inputs.something.overlays.default
            ];
          };
          inherit system;
        });
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit self;};
      system = "x86_64-linux";
      modules = [
        ./hosts/nixos/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.flavio = import ./users/flavio/home.nix;
          };
        }
      ];
    };

    formatter = forAllSystems {
      pkgs = nixpkgs_unstable;
      function = {system, ...}:
        nix-formatter-pack.lib.mkFormatter {
          pkgs = nixpkgs.legacyPackages.${system};

          config.tools = {
            deadnix.enable = true;
            alejandra.enable = true;
            statix.enable = true;
          };
        };
    };
  };
}
