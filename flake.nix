{
  description = "cffnpwr nix system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    cffnpwr-nixpkgs = {
      url = "github:cffnpwr/nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      agenix,
      cffnpwr-nixpkgs,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];

      flake =
        let
          overlays = [
            ({
              nixpkgs.overlays = [
                cffnpwr-nixpkgs.overlays.default
              ];
            })
          ];
        in
        {
          # Build darwin flake using:
          # $ darwin-rebuild switch --flake .#cpwr-mba2
          darwinConfigurations = {
            "cpwr-mba2" = nix-darwin.lib.darwinSystem {
              system = "aarch64-darwin";
              specialArgs = inputs;
              modules =
                overlays
                ++ (builtins.attrValues cffnpwr-nixpkgs.darwinModules)
                ++ [
                  ./modules/common
                  ./modules/darwin
                  ./hosts/cpwr-mba2

                  home-manager.darwinModules.home-manager

                  (
                    { config, pkgs, ... }:
                    {
                      home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        extraSpecialArgs = {
                          inherit (inputs) zen-browser;
                          packages = pkgs;
                        };
                        users.${config.username} = {
                          imports = [
                            ./modules/home-manager
                            agenix.homeManagerModules.default
                          ]
                          ++ (builtins.attrValues cffnpwr-nixpkgs.homeModules);
                        };
                      };
                    }
                  )
                ];
            };
          };
        };

      perSystem =
        {
          config,
          pkgs,
          system,
          ...
        }:
        {
          _module.args.pkgs = import nixpkgs {
            inherit system;
            overlays = [ cffnpwr-nixpkgs.overlays.default ];
            config.allowUnfree = true;
          };

          formatter = pkgs.nixfmt-rfc-style;

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              git
              nil
              nixd
              nixfmt-rfc-style
            ];
          };
        };
    };
}
