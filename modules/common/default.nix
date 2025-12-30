{ pkgs, ... }:
{
  imports = [
    ./user.nix
    ./packages.nix
    ./environment.nix
    ./service.nix
  ];

  # nix settings
  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      experimental-features = "nix-command flakes";
    };
  };
  nixpkgs.config.allowUnfree = true;
}
