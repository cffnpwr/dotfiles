{
  flake.modules.homeManager.docker-compose =
    { lib, pkgs, ... }:
    {
      home.packages = lib.filter (lib.meta.availableOn pkgs.stdenv.hostPlatform) [ pkgs.docker-compose ];
    };
}
