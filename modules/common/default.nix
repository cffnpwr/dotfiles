{ ... }:
{
  imports = [
    ./user.nix
    ./packages.nix
    ./environment.nix
    ./service.nix
  ];

  nixpkgs.config.allowUnfree = true;
}
