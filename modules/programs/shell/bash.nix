{
  flake.modules.homeManager.bash =
    { lib, pkgs, ... }:
    {
      home.packages = lib.filter (lib.meta.availableOn pkgs.stdenv.hostPlatform) [ pkgs.bashInteractive ];
    };
}
