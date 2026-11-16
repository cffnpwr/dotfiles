{
  flake.modules.homeManager.docker-buildx =
    { lib, pkgs, ... }:
    {
      home.packages = lib.filter (lib.meta.availableOn pkgs.stdenv.hostPlatform) [ pkgs.docker-buildx ];
    };
}
