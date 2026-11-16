{
  flake.modules.homeManager.wakeonlan =
    { lib, pkgs, ... }:
    {
      home.packages = lib.filter (lib.meta.availableOn pkgs.stdenv.hostPlatform) [ pkgs.wakeonlan ];
    };
}
