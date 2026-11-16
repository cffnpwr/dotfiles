{
  flake.modules.homeManager.curl =
    { lib, pkgs, ... }:
    {
      home.packages = lib.filter (lib.meta.availableOn pkgs.stdenv.hostPlatform) [ pkgs.curl ];
    };
}
