{ config, extraSubstituters, extraTrustedPublicKeys, ... }:
{
  imports = [
    ./user.nix
    ./system.nix
    ./programs/kanata.nix
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
      extra-substituters = extraSubstituters;
      extra-trusted-public-keys = extraTrustedPublicKeys;
    };
  };
}
