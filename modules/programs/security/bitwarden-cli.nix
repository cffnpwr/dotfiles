{
  flake.modules.homeManager.bitwarden-cli =
    { lib, pkgs, ... }:
    {
      home.packages = lib.filter (lib.meta.availableOn pkgs.stdenv.hostPlatform) [ pkgs.bitwarden-cli ];
    };
}
