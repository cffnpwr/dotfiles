{ ... }:
{
  imports = [
    ./user.nix
    ./packages.nix
    ./environment.nix
    ./fonts.nix
    ./service.nix
  ];

  # nix settings
  nix.settings = {
    experimental-features = "nix-command flakes";
  };
  nix.optimise.automatic = true;
  nixpkgs.config.allowUnfree = true;
}
