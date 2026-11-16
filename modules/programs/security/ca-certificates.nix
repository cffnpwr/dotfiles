{
  flake.modules.homeManager.ca-certificates =
    { lib, pkgs, ... }:
    {
      home.packages = lib.filter (lib.meta.availableOn pkgs.stdenv.hostPlatform) [ pkgs.cacert ];
    };
}
