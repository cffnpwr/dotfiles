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
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    cffnpwr-nixpkgs = {
      url = "github:cffnpwr/nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nix-darwin,
      home-manager,
      agenix,
      cffnpwr-nixpkgs,
      ...
    }@inputs:
    let
      overlays = [
        ({
          nixpkgs.overlays = [
            cffnpwr-nixpkgs.overlays.default

            # Workaround for fish build failure on Darwin (Issue #461406)
            # Remove fish from direnv's test dependencies since we only use zsh
            (final: prev: {
              direnv = prev.direnv.overrideAttrs (oldAttrs: {
                nativeCheckInputs = builtins.filter (pkg: pkg.pname or null != "fish") (
                  oldAttrs.nativeCheckInputs or [ ]
                );
                checkPhase = ''
                  runHook preCheck
                  make test-go test-bash test-zsh
                  runHook postCheck
                '';
              });
            })
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
}
