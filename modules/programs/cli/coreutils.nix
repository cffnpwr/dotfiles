{
  flake.modules.homeManager.coreutils =
    { lib, pkgs, ... }:
    {
      home.packages = lib.filter (lib.meta.availableOn pkgs.stdenv.hostPlatform) [ pkgs.coreutils ];
    };
}
