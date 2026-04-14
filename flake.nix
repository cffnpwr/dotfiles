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
    kanata-darwin = {
      url = "github:not-in-stock/kanata-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/=3.16.3";
    flake-parts.url = "github:hercules-ci/flake-parts";
    cffnpwr-nixpkgs = {
      url = "github:cffnpwr/nixpkgs-extras/feature/add_azookey";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agent-skills-nix = {
      url = "github:Kyure-A/agent-skills-nix";
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
      agent-skills-nix,
      cffnpwr-nixpkgs,
      flake-parts,
      zen-browser,
      llm-agents,
      ...
    }:
    let
      nixpkgsOverlays = [
        llm-agents.overlays.default
        cffnpwr-nixpkgs.overlays.default
      ];
      extraSubstituters = [
        "https://nix-cache.cffnpwr.dev"
      ];
      extraTrustedPublicKeys = [
        "cffnpwr-nixpkgs-extras:dmp2DUGwdqawLCPOsOcRxU/NpCO/qA1jha/8rmoSzvA="
      ];
    in
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
            { nixpkgs.overlays = nixpkgsOverlays; }
          ];
        in
        {
          # Build darwin flake using:
          # $ darwin-rebuild switch --flake .#cpwr-mba2
          darwinConfigurations = {
            "cpwr-mba5" = nix-darwin.lib.darwinSystem {
              system = "aarch64-darwin";
              specialArgs = inputs // {
                inherit extraSubstituters extraTrustedPublicKeys;
              };
              modules =
                overlays
                ++ (builtins.attrValues cffnpwr-nixpkgs.darwinModules)
                ++ [
                  inputs.determinate.darwinModules.default
                  inputs.kanata-darwin.darwinModules.default
                  home-manager.darwinModules.home-manager

                  ./modules/common
                  ./modules/darwin
                  ./hosts/cpwr-mba5

                  (
                    { config, pkgs, ... }:
                    {
                      home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        extraSpecialArgs = {
                          inherit inputs;
                          inherit (inputs) zen-browser;
                          packages = pkgs;
                        };
                        users.${config.username} = {
                          imports = [
                            ./modules/home-manager
                            agenix.homeManagerModules.default
                            agent-skills-nix.homeManagerModules.default
                            zen-browser.homeModules.default
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
          pkgs,
          system,
          ...
        }:
        {
          _module.args.pkgs = import nixpkgs {
            inherit system;
            overlays = nixpkgsOverlays;
            config.allowUnfree = true;
          };

          formatter = pkgs.nixfmt;

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              git
              nixd
              nixfmt
            ];
          };

          apps =
            let
              osName = if pkgs.stdenv.isDarwin then "macOS" else "nixos";
              buildCmd = if pkgs.stdenv.isDarwin then "darwin-rebuild" else "nixos-rebuild";
              extraOptions = ''
                --option extra-substituters "${builtins.concatStringsSep " " extraSubstituters}" \
                --option extra-trusted-public-keys "${builtins.concatStringsSep " " extraTrustedPublicKeys}"'';
            in
            {
              build = {
                type = "app";
                program =
                  let
                    script = pkgs.writeShellScriptBin "build-nix-system" ''
                      set -euo pipefail

                      HOST=$(hostname -s)

                      ${pkgs.gum}/bin/gum log -l info "Building ${osName} system for $HOST..."

                      ${buildCmd} build --impure --flake ${self}#$HOST ${extraOptions}

                      ${pkgs.gum}/bin/gum log -l info "Build complete."
                      ${pkgs.gum}/bin/gum log -l info "To switch to the new configuration, run: \`nix run .#switch\`"
                    '';
                  in
                  script;
              };

              switch = {
                type = "app";
                program =
                  let
                    script = pkgs.writeShellScriptBin "build-nix-system" ''
                      set -euo pipefail

                      HOST=$(hostname -s)

                      ${pkgs.gum}/bin/gum log -l info "Switching ${osName} system for $HOST..."

                      sudo ${buildCmd} switch --impure --flake ${self}#$HOST ${extraOptions}

                      ${pkgs.gum}/bin/gum log -l info "Switch complete."
                    '';
                  in
                  script;
              };

              clean-builds = {
                type = "app";
                program =
                  let
                    script = pkgs.writeShellScriptBin "clean-nix-builds" ''
                      set -euo pipefail

                      BUILDS_DIR="/nix/var/nix/builds"

                      if [ ! -d "$BUILDS_DIR" ]; then
                        ${pkgs.gum}/bin/gum log -l info "No builds directory found."
                        exit 0
                      fi

                      SIZE=$(sudo du -sh "$BUILDS_DIR" 2>/dev/null | cut -f1)
                      COUNT=$(ls "$BUILDS_DIR" 2>/dev/null | wc -l | tr -d ' ')

                      if [ "$COUNT" -eq 0 ]; then
                        ${pkgs.gum}/bin/gum log -l info "No build artifacts to clean."
                        exit 0
                      fi

                      ${pkgs.gum}/bin/gum log -l info "Found $COUNT build artifacts ($SIZE)"

                      if ${pkgs.gum}/bin/gum confirm "Delete all build artifacts?"; then
                        ${pkgs.gum}/bin/gum spin --spinner dot --title "Cleaning build artifacts..." -- sudo rm -rf "$BUILDS_DIR"/*
                        ${pkgs.gum}/bin/gum log -l info "Build artifacts cleaned."
                      else
                        ${pkgs.gum}/bin/gum log -l info "Cancelled."
                      fi
                    '';
                  in
                  script;
              };
            };
        };
    };
}
