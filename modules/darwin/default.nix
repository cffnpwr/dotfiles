{ ... }:
{
  imports = [
    ./user.nix
    ./system.nix
    ./programs/kmonad.nix
    ./services.nix
  ];

  # Let Determinate Nix handle Nix configuration
  nix = {
    enable = false;
    optimise.automatic = false;
  };
}
