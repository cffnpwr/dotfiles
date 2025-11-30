{ ... }:
{
  imports = [
    ./user.nix
    ./system.nix
    ./packages.nix
    ./programs/kmonad.nix
    ./services.nix
  ];
}
