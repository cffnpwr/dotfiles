{ config, ... }:
{
  imports = [
    ./user.nix
    ./system.nix
    ./programs/kmonad.nix
    ./services.nix
  ];

  # Determinate Nix configuration
  determinateNix = {
    enable = true;
    customSettings = {
      trusted-users = [
        "root"
        config.username
      ];
    };
  };
}
