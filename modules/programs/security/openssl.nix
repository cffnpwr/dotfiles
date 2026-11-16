{
  flake.modules.homeManager.openssl =
    { lib, pkgs, ... }:
    {
      home.packages = lib.filter (lib.meta.availableOn pkgs.stdenv.hostPlatform) [ pkgs.openssl ];
    };
}
