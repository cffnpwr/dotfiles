{
  description = "dotfiles for cffnpwr";

  nixConfig = {
    extra-substituters = [
      "https://cache.numtide.com"
      "https://nix-cache.cffnpwr.dev"
    ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "nix-cache.cffnpwr.dev-1:yVSfZXVFclp7gBWnVg65wjjWPwIUSdXnscH7i1Tp4Jk="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    import-tree.url = "github:denful/import-tree";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # FlakeHub Cacheを使うため、nixpkgsをfollowsしない
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    # numtideのバイナリキャッシュを使うため、nixpkgsをfollowsしない
    llm-agents.url = "github:numtide/llm-agents.nix";

    # nixpkgsの更新を待たずにmiseのリリースを使うため、jdx/miseのflakeから導入
    mise = {
      url = "github:jdx/mise/v2026.11.14";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixpkgsの更新を待たずにgo.modが要求するGoのパッチリリースを使うため、go-overlayから導入
    go-overlay = {
      url = "github:purpleclay/go-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-homebrewで使用するhomebrew tap
    homebrew-homebrew-core = {
      url = "github:Homebrew/homebrew-core";
      flake = false;
    };
    homebrew-homebrew-cask = {
      url = "github:Homebrew/homebrew-cask";
      flake = false;
    };
    cffnpwr-homebrew-tap = {
      url = "github:cffnpwr/homebrew-tap";
      flake = false;
    };
    netbirdio-homebrew-tap = {
      url = "github:netbirdio/homebrew-tap";
      flake = false;
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      imports = [ (inputs.import-tree ./modules) ];
    };
}
